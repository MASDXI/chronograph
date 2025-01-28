// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Address Registry for mapping address and geolocate
 * @author Sirawit Techavanitch
 */

import {Circle2D as Circle} from "./Circle2D.sol";

abstract contract AddressRegistry {
    using Circle for Circle.Circle;

    /** errors */
    error AddressGeolocateExists();
    error AddressGeolocateNotExists();

    /** events */
    event AddressGeolocateMapped(
        address indexed account,
        int32 latitude,
        int32 longitude
    );

    event AddressGeolocateUnmapped(address indexed account);

    mapping(address => Circle.Circle) private _registry;

    function _addToRegistry(
        address account,
        Circle.Circle memory geolocate
    ) internal {
        Circle.Circle memory geolocateCache = _registry[account];
        if (geolocateCache.x == 0 && geolocateCache.y == 0) {
            _registry[account] = geolocate;

            emit AddressGeolocateMapped(account, geolocate.x, geolocate.y);
        } else {
            revert AddressGeolocateExists();
        }
    }

    function _removeFromRegistry(address account) internal {
        Circle.Circle memory geolocateCache = _registry[account];
        if (geolocateCache.x == 0 && geolocateCache.y == 0) {
            revert AddressGeolocateNotExists();
        } else {
            delete _registry[account];

            emit AddressGeolocateUnmapped(account);
        }
    }

    function geolocateOf(
        address account
    ) public view returns (Circle.Circle memory) {
        return _registry[account];
    }

    function contain(address a, address b) public view returns (bool) {
        return _registry[a].contain(_registry[b]);
    }

    function overlap(address a, address b) public view returns (bool) {
        return _registry[a].overlap(_registry[b]);
    }
}
