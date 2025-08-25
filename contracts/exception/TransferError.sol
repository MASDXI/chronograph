// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

interface TransferError {
    /// @dev Transfer error codes defined according to the transfer rules of the Digital Wallet project.
    enum TRANSFER_ERROR_TYPE {
        NON_CITIZEN,
        NON_MERCHANT,
        OUT_OF_AREA,
        RESERVED01,
        RESERVED02,
        RESERVED03
    }

    error InvalidTransferType(TRANSFER_ERROR_TYPE);
}
