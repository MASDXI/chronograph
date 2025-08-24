// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC5679} from "./interfaces/IERC5679-ERC20.sol";

// @TODO
abstract contract DigitalWalletTokenLite is ERC20, IERC5679 {

    mapping(address => uint256 [4]) private _balances;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function mint(address to, uint256 amount, bytes calldata data) public {
        _balances[to][0] += amount;
    }

    function burn(address from, uint256 amount, bytes calldata data) public {
        // @TODO check enough balance to burn.
        _balances[from][3] -= amount;
    }

    // @TODO transfer rule
    // from (Merchant) and to (Citizen) not allowed B2C transfer.
    // from (Merchant) and to (Merchant) B2B transfer.
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
