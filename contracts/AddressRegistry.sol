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
        uint256 latitude;
        uint256 longitude;
    }

    /** errors */
    // @TODO declare custom error

    /** events */
    event AddressGeolocateMapped(
        address indexed account,
        uint256 latitude,
        uint256 longitude
    );
    event AddressGeolocateUnmapped(address indexed account);

    mapping(address => Geolocation) private _registry;

    function _addToRegistry(
        address account,
        Geolocation memory geolocate
    ) internal {
        Geolocation memory geolocateCache = _registry[account];
        if (geolocateCache.latitude == 0 && geolocateCache.longitude == 0) {
            _registry[account] = geolocate;
            emit AddressGeolocateMapped(
                account,
                geolocate.latitude,
                geolocate.longitude
            );
        } else {
            // @TODO revert
        }
    }

    function _removeFromRegistry(address account) internal {
        Geolocation memory geolocateCache = _registry[account];
        if (geolocateCache.latitude == 0 && geolocateCache.longitude == 0) {
            // @TODO revert
        } else {
            delete _registry[account];
            emit AddressGeolocateUnmapped(account);
        }
    }

    function geolocateOf(
        address account
    ) public view returns (Geolocation memory) {
        return _registry[account];
    }

    // some internal helper function below.
}
