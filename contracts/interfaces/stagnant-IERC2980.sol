// SPDX-License-Identifier: CC0-1.0
pragma solidity >=0.8.0 <0.9.0;

/// @title ERC-2980 interface
/// @dev An interface for asset tokens, compliant with Swiss Law and compatible with ERC-20.
/// See https://eips.ethereum.org/EIPS/eip-2980

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC2980 is IERC20 {
    /// @dev This emits when funds are reassigned
    event FundsReassigned(address from, address to, uint256 amount);

    /// @dev This emits when funds are revoked
    event FundsRevoked(address from, uint256 amount);

    /// @dev This emits when an address is frozen
    event FundsFrozen(address target);

    ///@dev getter to determine if address is in frozenlist
    function frozenlist(address _operator) external view returns (bool);

    /// @dev getter to determine if address is in whitelist
    function whitelist(address _operator) external view returns (bool);
}
