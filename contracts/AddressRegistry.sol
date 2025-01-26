// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Address Registry for mapping address and geolocate
 * @author Sirawit Techavanitch
 */

import {Geographical} from "./Geographical.sol";

abstract contract AddressRegistry {
    using Geographical for uint256;

    struct Geolocation {
        // maybe latitude longitude
    }

    // citizen geographical tight to the address;
    // merchant geographical tight to the address;

    mapping(address => Geolocation) private _registry;

    function _addToRegistry(address account, Geolocation memory geolocate) internal {
        // @TODO check not contain first.
        _registry[account] = geolocate;
    }

    function _removeFromRegistry(address account) internal {
        // @TODO check contain first.
        _registry[account] = Geolocation(0);
    }

    function geolocateOf(address account) public view returns (Geolocation memory) {
        return _registry[account];
    }

    // some internal helper function below.
}