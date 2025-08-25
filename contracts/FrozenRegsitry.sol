// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AddressRegistryError} from "./exception/AddressRegistryError.sol";
import {IFrozenRegistry} from "./interfaces/compliance/IFrozenRegistry.sol";

/// @dev Ownable is compatible with ERC-173
contract FrozenRegistry is AddressRegistryError, IFrozenRegistry, Ownable {
    mapping(address => bool) private _frozenList;

    constructor(address owner_) Ownable(owner_) {}

    function isFrozen(address account) external view override returns (bool) {
        return _frozenList[account];
    }

    function addAddressToFrozenlist(address account) external override onlyOwner returns (bool) {
        // @TODO check
        _frozenList[account] = true;

        emit FundsFrozen(account);

        return true;
    }

    function removeAddressFromFrozenlist(
        address account
    ) external override onlyOwner returns (bool) {
        // @TODO check
        delete _frozenList[account];

        emit FundsUnfrozen(account);

        return true;
    }
}
