// SPDX-License-Identifier: CC0-1.0
pragma solidity >=0.8.0 <0.9.0;

/// @title ERC-6372 interface
/// @dev An interface for exposing a contract's clock value and details.
/// See https://eips.ethereum.org/EIPS/eip-6372

/// @custom:strict do not modified this file.
interface IERC6372 {
    /// @return uint48 the current timepoint according to the mode the contract is operating
    function clock() external view returns (uint48);

    /// @dev returns a machine-readable string description of the clock the contract is operating on.
    /// @return string mode=blocknumber&from=<CAIP-2-ID>, where <CAIP-2-ID> is a CAIP-2 Blockchain ID such as eip155:1.
    function CLOCK_MODE() external view returns (string memory);
}
