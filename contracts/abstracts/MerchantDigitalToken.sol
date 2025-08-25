// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC2980} from "../interfaces/stagnant-IERC2980.sol";
import {IERC5679Ext20 as IERC5679} from "../interfaces/IERC5679.sol";
import {IAddressRegistry} from "../interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "../interfaces/compliance/IFrozenRegistry.sol";
import {TransferError} from "../exception/TransferError.sol";
import {LogAddress} from "../utils/LogAddress.sol";

abstract contract MerchantDigitalToken is ERC20, IERC2980, IERC5679, LogAddress, TransferError {
    uint256 private immutable _cap;
    uint256 private _totalSupply;

    IAddressRegistry private _addressRegistry;
    IFrozenRegistry private _frozenRegistry;

    mapping(address => uint256[4]) private _balances;

    error ERC20ExceededCap(uint256 increasedSupply, uint256 cap);
    error ERC20InvalidCap(uint256 cap);

    constructor(string memory name_, string memory symbol_, uint256 cap_) ERC20(name_, symbol_) {
        if (cap_ == 0) {
            revert ERC20InvalidCap(0);
        }
        _cap = cap_;
    }

    function _updateAddressRegistry(IAddressRegistry addressRegistry) internal {
        address oldAddressRegistry = address(_addressRegistry);
        _addressRegistry = addressRegistry;

        emit Log("address_registry", oldAddressRegistry, address(addressRegistry));
    }

    function _updateFrozenRegistry(IFrozenRegistry frozenRegistry) internal {
        address oldFrozenRegistry = address(frozenRegistry);
        _frozenRegistry = frozenRegistry;

        emit Log("frozen_registry", oldFrozenRegistry, address(frozenRegistry));
    }

    function _beforeTransfer(address from, address to, uint256 amount) internal virtual {
        if ((frozenlist(from) || frozenlist(to))) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.RESERVED01);
        }
        if (!(whitelist(from) && whitelist(to))) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.NON_MERCHANT);
        }
    }

    function _afterTransfer(address from, address to, uint256 amount) internal virtual {
        // @TODO something should do after transfer?
    }

    /// @dev _update to handle token transfers with circulation tracking.
    /// Cash-out timing is non-deterministic as it depends on merchant spending patterns.
    /// Tokens must circulate through the merchant network at least 3 times before becoming
    /// withdrawable. The actual time to reach withdrawable status varies based on how
    /// frequently merchants transact with each other in the local economy.
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
                uint256 value = _balances[from][3];
                if (value < amount) {
                    revert ERC20InsufficientBalance(from, value, amount);
                }
                _balances[from][3] -= amount;
                _totalSupply -= amount;
            } else {
                uint256 value = balanceOf(from);
                if (value < amount) {
                    revert ERC20InsufficientBalance(from, value, amount);
                }
                uint256 remaining = amount;
                uint256 index;
                while (remaining > 0) {
                    uint256 available = _balances[from][index];
                    if (available > 0) {
                        uint256 deductValue = remaining > available ? remaining : remaining;
                        _balances[from][index] -= deductValue;
                        uint256 toIndex = index + 1 > 3 ? 3 : index + 1;
                        _balances[to][toIndex] += deductValue;
                        remaining -= deductValue;
                    }
                }
            }
        }

        emit Transfer(from, to, amount);
    }

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function totalSupply() public view override(ERC20, IERC20) returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override(ERC20, IERC20) returns (uint256) {
        uint256 balance = _balances[account][0];
        for (uint256 index = 1; index < 4; index++) {
            balance += _balances[account][index];
        }
        return balance;
    }

    function transfer(address to, uint256 amount) public override(ERC20, IERC20) returns (bool) {
        _beforeTransfer(msg.sender, to, amount);
        _transfer(msg.sender, to, amount);
        _afterTransfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override(ERC20, IERC20) returns (bool) {
        _beforeTransfer(from, to, amount);
        _transfer(from, to, amount);
        _afterTransfer(from, to, amount);
        return true;
    }

    /// @dev See {IERC2920.frozenlist}.
    function frozenlist(address account) public view returns (bool) {
        return _frozenRegistry.isFrozen(account);
    }

    /// @dev See {IERC2920.whitelist}.
    function whitelist(address account) public view returns (bool) {
        return _addressRegistry.isMerchant(account);
    }

    /// @dev See {IERC5679-mint}.
    function mint(address to, uint256 amount, bytes calldata data) public virtual override {
        _mint(to, amount);
    }

    /// @dev See {IERC5679-burn}.
    function burn(address from, uint256 amount, bytes calldata data) public virtual override {
        _burn(from, amount);
    }

    /// @dev retrieve balance that can cash-out/off-ramp.
    function withdrawableBalanceOf(address account) public view returns (uint256) {
        return _balances[account][3];
    }
}
