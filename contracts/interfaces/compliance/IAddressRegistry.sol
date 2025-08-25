// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

interface IAddressRegistry {
    /// @dev Is given the account address is registered as citizen.
    function isCitizen(address account) external view returns (bool);

    /// @dev Is given the account address is registered as merchant.
    function isMerchant(address account) external view returns (bool);

    /// @return hash of location as identifier
    function locationId(address account) external view returns (bytes32);
}
