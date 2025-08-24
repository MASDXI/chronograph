// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC5679} from "./interfaces/IERC5679-ERC20.sol";

/// @custom:strict allowed to override _updateRegistry only.
abstract contract MerchantDigitalToken is ERC20, IERC5679 {
    // IAddressRegistry private _addressRegistry;

    mapping(address => uint256[4]) private _balances;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    // @TODO
    // function _updateAddressRegistry(IAddressRegistry addressRegistry) internal virtual {}

    function decimals() public view override returns (uint8) {
        return 6;
    }

    function mint(address to, uint256 amount, bytes calldata data) public virtual override {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount, bytes calldata data) public virtual override {
        _burn(from, amount);
    }

    function _update(address to, uint256 amount) public override returns (bool) {
        // @TODO transfer rule if current balance at index not enough then next.
        // from (Merchant) and to (Citizen) not allowed B2C transfer.
        // from (Merchant) and to (Merchant) B2B transfer.
        // minting mint to _balances[][0] only.
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
        // burning from _balance[][4] only.
        return true;
    }
}
