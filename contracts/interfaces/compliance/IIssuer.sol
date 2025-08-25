// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/// @title Issuer Interface
/// @dev Issuable interface for Swiss Compliant Asset.
/// See https://eips.ethereum.org/EIPS/eip-2980 #Issuers

interface IIssuer {
    /// @dev getter to determine if address has issuer role
    function isIssuer(address _addr) external view returns (bool);

    /// @dev add a new issuer address
    /// Throws unless `msg.sender` is the contract owner
    /// @param _operator address
    /// @return true if the address was not an issuer, false if the address was already an issuer
    function addIssuer(address _operator) external returns (bool);

    /// @dev remove an address from issuers
    /// Throws unless `msg.sender` is the contract owner
    /// @param _operator address
    /// @return true if the address has been removed from issuers, false if the address wasn't in the issuer list in the first place
    function removeIssuer(address _operator) external returns (bool);

    /// @dev Allows the current issuer to transfer its role to a newIssuer
    /// Throws unless `msg.sender` is an Issuer operator
    /// @param _newIssuer The address to transfer the issuer role to
    function transferIssuer(address _newIssuer) external;
}
