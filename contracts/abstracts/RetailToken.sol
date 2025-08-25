// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC7818} from "@kiwarilabs/contracts/tokens/ERC20/ERC7818.sol";
import {ERC7818Exception} from "@kiwarilabs/contracts/tokens/ERC20/extensions/ERC7818Exception.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC5679Ext20 as IERC5679} from "../interfaces/IERC5679.sol";
import {IERC6372} from "../interfaces/review-IERC6372.sol";
import {IAddressRegistry} from "../interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "../interfaces/compliance/IFrozenRegistry.sol";
import {TransferError} from "../exception/TransferError.sol";
import {LogAddress} from "../utils/LogAddress.sol";

abstract contract RetailToken is
    IERC5679,
    ERC7818,
    ERC7818Exception,
    LogAddress,
    TransferError
{
    IERC5679 private _merchantDigitalToken;
    IAddressRegistry private _addressRegistry;
    IFrozenRegistry private _frozenRegistry;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initTimestamp,
        uint40 duration,
        uint8 size
    ) ERC7818(name_, symbol_, initTimestamp, duration, size, false) {}

    function _beforeTransfer(address from, address to, uint256 amount) internal virtual {
        if (!(_addressRegistry.isCitizen(from) && _addressRegistry.isMerchant(to))) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.NON_CITIZEN);
        }
        if (_addressRegistry.locationId(from) != _addressRegistry.locationId(to)) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.OUT_OF_AREA);
        }
    }

    function _afterTransfer(address from, address to, uint256 amount) internal virtual {
        _burnFromException(to, amount);
        _merchantDigitalToken.mint(to, amount, "");
    }

    /// @dev RESERVED01 mean InvalidAddressFromOrToIsFrozen
    function _beforeTransferAtEpoch(
        uint256 epoch,
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        if (_frozenRegistry.isFrozen(from) || _frozenRegistry.isFrozen(to)) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.RESERVED01);
        }
        if (!(_addressRegistry.isCitizen(from) && _addressRegistry.isMerchant(to))) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.NON_CITIZEN);
        }
        if (_addressRegistry.locationId(from) != _addressRegistry.locationId(to)) {
            revert InvalidTransferType(TRANSFER_ERROR_TYPE.OUT_OF_AREA);
        }
    }

    function _afterTransferAtEpoch(
        uint256 epoch,
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        _burnFromException(to, amount);
        _merchantDigitalToken.mint(to, amount, "");
    }

    function _pointerProvider() internal view override returns (uint256) {
        return block.timestamp;
    }

    function _updateMerchantDigitalToken(IERC5679 merchantDigitalToken) internal {
        address oldMerchantDigitalToken = address(_merchantDigitalToken);
        _merchantDigitalToken = merchantDigitalToken;

        emit Log(
            "merchant_digital_token",
            oldMerchantDigitalToken,
            address(merchantDigitalToken)
        );
    }

    function _updateAddressRegistry(IAddressRegistry addressRegistry) internal {
        address oldAddressRegistry = address(_addressRegistry);
        _addressRegistry = addressRegistry;

        emit Log("address_registry", oldAddressRegistry, address(addressRegistry));
    }

    function _updateFrozenRegistry(IFrozenRegistry frozenRegistry) internal {
        address oldFrozenRegistry = address(frozenRegistry);
        _frozenRegistry = frozenRegistry;

        emit Log("frozen_registry", oldFrozenRegistry, address(frozenRegistry));
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function balanceOf(
        address account
    ) public view virtual override(ERC7818, ERC7818Exception) returns (uint256) {
        return super.balanceOf(account);
    }

    function transfer(
        address to,
        uint256 amount
    ) public override(ERC7818, ERC7818Exception) returns (bool) {
        _beforeTransfer(msg.sender, to, amount);
        super.transfer(to, amount);
        _afterTransfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override(ERC7818, ERC7818Exception) returns (bool) {
        _beforeTransfer(from, to, amount);
        super.transferFrom(from, to, amount);
        _afterTransfer(from, to, amount);
        return true;
    }

    function transferAtEpoch(
        uint256 epoch,
        address to,
        uint256 amount
    ) public override(ERC7818, ERC7818Exception) returns (bool) {
        _beforeTransferAtEpoch(epoch, msg.sender, to, amount);
        super.transferAtEpoch(epoch, to, amount);
        _afterTransferAtEpoch(epoch, msg.sender, to, amount);
        return true;
    }

    function transferFromAtEpoch(
        uint256 epoch,
        address from,
        address to,
        uint256 amount
    ) public override(ERC7818, ERC7818Exception) returns (bool) {
        _beforeTransferAtEpoch(epoch, from, to, amount);
        super.transferFromAtEpoch(epoch, from, to, amount);
        _afterTransferAtEpoch(epoch, from, to, amount);
        return true;
    }

    /// @dev See {IERC5679-mint}.
    function mint(address to, uint256 amount, bytes calldata data) public virtual override {
        _mint(to, amount);
    }

    /// @dev See {IERC5679-burn}.
    function burn(address from, uint256 amount, bytes calldata data) public virtual override {
        _burn(from, amount);
    }

    /// @dev See {IERC6372-clock}.
    function clock() public view returns (uint48) {
        return uint48(block.timestamp);
    }

    /// @dev See {IERC6372-CLOCK_MODE}.
    function CLOCK_MODE() public view returns (string memory) {
        return string.concat("mode=timestamp&from=eip155:", Strings.toString(block.chainid));
    }

    /// @dev epochType match with CLOCK_MODE
    function epochType() public pure override returns (EPOCH_TYPE) {
        return EPOCH_TYPE.TIME_BASED;
    }
}
