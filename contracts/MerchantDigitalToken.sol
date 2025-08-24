// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC5679} from "./interfaces/IERC5679-ERC20.sol";
import {IAddressRegistry} from "./interfaces/IAddressRegistry.sol";
import {TransferError} from "./interfaces/TransferError.sol";

/// @custom:strict allowed to override _updateRegistry only.
abstract contract MerchantDigitalToken is ERC20, IERC5679, TransferError {
    uint256 private immutable _cap;

    uint256 private _totalSupply;

    IAddressRegistry private _addressRegistry;

    mapping(address => uint256[4]) private _balances;

    error ERC20ExceededCap(uint256 increasedSupply, uint256 cap);
    error ERC20InvalidCap(uint256 cap);

    constructor(string memory name_, string memory symbol_, uint256 cap_) ERC20(name_, symbol_) {
        if (cap_ == 0) {
            revert ERC20InvalidCap(0);
        }
        _cap = cap_;
    }

    function _updateAddressRegistry(IAddressRegistry addressRegistry) internal virtual {
        _addressRegistry = addressRegistry;
        
        // @TODO emit event
    }

    function _beforeTransfer(address from, address to, uint256 amount) internal {
        if (!(_addressRegistry.isMerchant(from) && _addressRegistry.isMerchant(to))) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.NON_MERCHANT);
        }
    }

    function _afterTransfer(address from, address to, uint256 amount) internal {
        // @TODO something should do after transfer?
    }

    function _update(address from, address to, uint256 amount) internal override {
        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert ERC20ExceededCap(supply, maxSupply);
            }
            _balances[to][0] += amount;
            _totalSupply += amount;
        } else {
            if (to == address(0)) {
                _balances[from][3] -= amount;
                _totalSupply -= amount;
            } else {
                // @TODO transfer rule if current balance at index not enough then next.
                // spender spend from _balances[][0]
                // receiver receive to _balances[][1]
                // if spender spend from _balances[][1]
                // receiver receive to _balance[][2]
                // if spender spend from _balances[][2]
                // receiver receive to _balance[][3]
                // if spender spend from _balances[][3]
                // receiver receive to _balance[][4]
                // if spender spend from _balances[][4]
                // receiver receive to _balance[][4]
            }
        }
    }

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function decimals() public view override returns (uint8) {
        return 6;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        uint256 balance = _balances[account][0];
        for (uint256 index = 1; index < 4; index++) {
            balance += _balances[account][index];
        }
        return balance;
    }

    /// @dev retrieve balance that can cash-out/off-ramp.
    function withdrawableBalanceOf(address account) public view returns (uint256) {
        return _balances[account][3];
    }

    /// @dev See {IERC5679-mint}.
    function mint(address to, uint256 amount, bytes calldata data) public virtual override {
        _mint(to, amount);
    }

    /// @dev See {IERC5679-burn}.
    function burn(address from, uint256 amount, bytes calldata data) public virtual override {
        _burn(from, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        _beforeTransfer(msg.sender, to, amount);
        _transfer(msg.sender, to, amount);
        _afterTransfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        _beforeTransfer(from, to, amount);
        _transfer(from, to, amount);
        _afterTransfer(from, to, amount);
        return true;
    }
}
