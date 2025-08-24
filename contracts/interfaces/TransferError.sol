// SPDX-License-Identifier: GPL-3.0

/// @custom:strict do not modified this file.
interface TransferError {
    enum TRANSFER_ERROR_TYPE {
        NON_CITIZEN,
        NON_MERCHANT,
        OUT_OF_AREA
    }

    error InvalidTransferType(TRANSFER_ERROR_TYPE);
}
