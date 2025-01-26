// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

// @TODO library path need to be change.
import {ERC20EXPWhitelist as ERC7818Whitelist} from "../lib";
// import {Geographical} from  geographical library

contract Token is ERC7818Whitelist {
    // using Geographical for uint256;

    // address registry geographical can be decoupled from this token for more feasibility.
    // citizen geographical tight to the address;
    // merchant geographical tight to the address;

    constructor () ERC7818Whitelist() {}

    // `addToWhitelist` and `removeFromWhitelist` inherit from ERC7818Whitelist.

    // geographical of spender and receiver must overlaying/overlap
    function transfer(address to, uint256 value) public returns (bool) {
        // require(checkGeographical(msg.sender, to));
        // handle citizen and merchant balance update
    }

    // merchant MUST not allow to spending the token back to the citizen.
    // merchant use the unexpired balance with other merchant only.
    // citizen MUST not allow to spending/transfer to other citizen.

    // requirement to circulate the token back 'n' times before off-ramp into cash.
    // can be change to restriction period of time and minimum amount.
}

