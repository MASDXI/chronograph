// SPDX-License-Identifier: CC0-1.0
pragma solidity >=0.8.0 <0.9.0;

/// @title ERC-5679 interface
/// @dev An extension for minting and burning ERC-20.
/// See https://eips.ethereum.org/EIPS/eip-5679

/// @custom:strict do not modified this file.
// The EIP-165 identifier of this interface is 0xd0017968
interface IERC5679Ext20 {
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

// The EIP-165 identifier of this interface is 0xcce39764
interface IERC5679Ext721 {
    /// @dev Safely mints a new token with identifier `id` to `to`.
    /// @param to The recipient that will receive the newly minted token.
    /// @param id The unique token ID to be minted.
    /// @param data Arbitrary additional data forwarded to the implementation/receiver.
    function safeMint(address to, uint256 id, bytes calldata data) external;

    /// @dev Burns the token `id` from the `from` address.
    /// @param from The current owner (or source) of the token to burn.
    /// @param id The unique token ID to be burned.
    /// @param data Arbitrary additional data forwarded to the implementation.
    function burn(address from, uint256 id, bytes calldata data) external;
}

// The EIP-165 identifier of this interface is 0xf4cedd5a
interface IERC5679Ext1155 {
    /// @dev Safely mints `amount` of token type `id` to `to`.
    /// @param to The recipient that will receive the newly minted tokens.
    /// @param id The token type identifier to mint.
    /// @param amount The number of tokens of type `id` to mint.
    /// @param data Arbitrary additional data forwarded to the implementation/receiver.
    function safeMint(address to, uint256 id, uint256 amount, bytes calldata data) external;

    /// @dev Safely mints a batch of token types `ids` with corresponding `amounts` to `to`.
    /// @param to The recipient that will receive the newly minted tokens.
    /// @param ids The list of token type identifiers to mint.
    /// @param amounts The list of amounts to mint for each corresponding token ID.
    /// @param data Arbitrary additional data forwarded to the implementation/receiver.
    function safeMintBatch(
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;

    /// @dev Burns `amount` of token type `id` from `from`.
    /// @param from The account whose balance will be reduced.
    /// @param id The token type identifier to burn.
    /// @param amount The number of tokens of type `id` to burn.
    /// @param data Arbitrary additional data forwarded to the implementation.
    function burn(address from, uint256 id, uint256 amount, bytes[] calldata data) external;

    /// @dev Burns a batch of token types `ids` with corresponding `amounts` from `from`.
    /// @param from The account whose balances will be reduced.
    /// @param ids The list of token type identifiers to burn.
    /// @param amounts The list of amounts to burn for each corresponding token ID.
    /// @param data Arbitrary additional data forwarded to the implementation.
    function burnBatch(
        address from,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}
