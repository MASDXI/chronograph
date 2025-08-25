// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/// @title Freezable Interface
/// @dev Freezable interface for Swiss Compliant Asset.
/// See https://eips.ethereum.org/EIPS/eip-2980 #Frozenlist

interface IFrozenRegistry {
    /// @dev This emits when an address is frozen
    event FundsFrozen(address target);

    /// @dev This emits when an address is frozen (currently missing in proposal)
    event FundsUnfrozen(address target);

    /// @dev Is given the account address is registered as merchant.
    function isFrozen(address account) external view returns (bool);

    ///@dev add an address to the frozenlist
    ///Throws unless `msg.sender` is an Issuer operator
    ///@param _operator address to add
    ///@return true if the address was added to the frozenlist, false if the address was already in the frozenlist
    function addAddressToFrozenlist(address _operator) external returns (bool);

    ///@dev remove an address from the frozenlist
    ///Throws unless `msg.sender` is an Issuer operator
    ///@param _operator address to remove
    ///@return true if the address was removed from the frozenlist, false if the address wasn't in the frozenlist in the first place
    function removeAddressFromFrozenlist(address _operator) external returns (bool);
}
