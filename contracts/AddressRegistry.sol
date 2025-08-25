// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AddressRegistryError} from "./exception/AddressRegistryError.sol";
import {IAddressRegistry} from "./interfaces/compliance/IAddressRegistry.sol";

/// @dev Ownable is compatible with ERC-173
contract AddressRegistry is AddressRegistryError, IAddressRegistry, Ownable {
    mapping(address => bool) private _citizenList;
    mapping(address => bool) private _merchantList;
    mapping(address => bytes32) private _locationList;

    constructor(address owner_) Ownable(owner_) {}

    function isCitizen(address account) public view override returns (bool) {
        return _citizenList[account];
    }

    function isMerchant(address account) public view override onlyOwner returns (bool) {
        return _merchantList[account];
    }

    function locationId(address account) public view override onlyOwner returns (bytes32) {
        return _locationList[account];
    }

    function addAddressToCitizenList(
        address account,
        bytes32 location
    ) public onlyOwner returns (bool) {
        // @TODO check
        _citizenList[account] = true;
        _locationList[account] = location;
        return true;
    }

    function removeCitizen(address account) public onlyOwner returns (bool) {
        // @TODO check
        delete _citizenList[account];
        delete _locationList[account];

        // @TODO emit 

        return true;
    }

    function registerMerchant(address account, bytes32 location) public onlyOwner returns (bool) {
        // @TODO check
        _merchantList[account] = true;
        _locationList[account] = location;

        // @TODO emit 

        return true;
    }

    function removeMerchant(address account) public onlyOwner returns (bool) {
        delete _merchantList[account];
        delete _locationList[account];

        // @TODO emit 

        return true;
    }
}
