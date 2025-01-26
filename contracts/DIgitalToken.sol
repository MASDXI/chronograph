// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Digital Token
 * @author Sirawit Techavanitch
 */

// @TODO library path need to be change.
import {ERC20EXPWhitelist as ERC7818Whitelist} from "../lib";

import {AddressRegistry} from "./AddressRegistry.sol";

contract Token is ERC7818Whitelist, AddressRegistry {
    // address registry geographical can be decoupled from this token for more feasibility.

    constructor () ERC7818Whitelist() {}

    // `addToWhitelist` and `removeFromWhitelist` inherit from ERC7818Whitelist.
    
    // @TODO function to enrolled citizen or merchant address store address and geographical.
    // @TODO function to unenrolled citizen or merchant address remove address and geographical.
    // @TODO simple mechanic for merchant to off-ramp token condition.

    // @TODO geographical of spender and receiver must overlaying/overlap
    function transfer(address to, uint256 value) public returns (bool) {
        // @TODO handle citizen or merchant balance update
    }
}

