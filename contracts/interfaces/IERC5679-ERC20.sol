// SPDX-License-Identifier: GPL-3.0

/// @title ERC-5679 interface
/// @dev An extension for minting and burning EIP-20.
/// See https://eips.ethereum.org/EIPS/eip-5679

/// @custom:strict do not modified this file.
interface IERC5679 {
    /// @dev Create `amount` tokens and assigns them to `to`
    /// @param to The address that will receive the minted tokens.
    /// @param amount The amount of tokens to mint.
    /// @param data Additional data with no specified format that can be included in the transaction.
    function mint(address to, uint256 amount, bytes calldata data) external;

    /// @dev Remove `amount` tokens from `from`
    /// @param from The address that the tokens will be burned from.
    /// @param amount The amount of tokens to burn.
    /// @param data Additional data with no specified format that can be included in the transaction.
    function burn(address from, uint256 amount, bytes calldata data) external;
}
