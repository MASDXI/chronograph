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

    event AddedToCitizenList(address indexed caller, address indexed account);
    event RemovedFromCitizenList(address indexed caller, address indexed account);
    event AddedToMerchantList(address indexed caller, address indexed account);
    event RemovedFromMerchantList(address indexed caller, address indexed account);

    error InvalidLocation();

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

    /// @dev RESERVED01 mean InvalidAddressAlreadyMerchant
    function addAddressToCitizenList(
        address account,
        bytes32 location
    ) public onlyOwner returns (bool) {
        if (account == address(0)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.INVALID_ADDRESS);
        }
        if (location == bytes32(0)) {
            revert InvalidLocation();
        }
        if (isCitizen(account)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.EXIST);
        }
        if (isMerchant(account)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.RESERVED01);
        }
        _citizenList[account] = true;
        _locationList[account] = location;

        emit AddedToCitizenList(msg.sender, account);

        return true;
    }

    function removeCitizen(address account) public onlyOwner returns (bool) {
        if (!isCitizen(account)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.NOT_EXIST);
        }
        delete _citizenList[account];
        delete _locationList[account];

        emit RemovedFromCitizenList(msg.sender, account);

        return true;
    }

    /// @dev RESERVED02 mean InvalidAddressAlreadyCitizen
    function registerMerchant(address account, bytes32 location) public onlyOwner returns (bool) {
        if (account == address(0)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.INVALID_ADDRESS);
        }
        if (location == bytes32(0)) {
            revert InvalidLocation();
        }
        if (isMerchant(account)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.EXIST);
        }
        if (isCitizen(account)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.RESERVED02);
        }
        _merchantList[account] = true;
        _locationList[account] = location;

        emit AddedToMerchantList(msg.sender, account);

        return true;
    }

    function removeMerchant(address account) public onlyOwner returns (bool) {
        if (!isMerchant(account)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.NOT_EXIST);
        }
        delete _merchantList[account];
        delete _locationList[account];

        emit RemovedFromMerchantList(msg.sender, account);

        return true;
    }
}
