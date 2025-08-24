// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/// @custom:strict do not modified this file.
interface IAddressRegistry {
    /// @dev is given the account address is registered as citizen.
    function isCitizen(address account) external returns (bool);

    /// @dev is given the account address is registered as merchant.
    function isMerchant(address account) external returns (bool);

    /// @return hash of location as identifier
    function locationId(address account) external returns (bytes32);
}
