// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

interface AddressRegistryError {
    /// @dev Reusable error for address registry like contract.
    enum REGISTRY_ERROR_TYPE {
        NOT_EXIST,
        EXIST,
        INVALID_ADDRESS,
        RESERVED01,
        RESERVED02,
        RESERVED03
    }

    error InvalidAddressRegistryType(REGISTRY_ERROR_TYPE);
}
