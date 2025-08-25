// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {IERC5679Ext20 as IERC5679} from "../interfaces/IERC5679.sol";
import {IERC6372} from "../interfaces/review-IERC6372.sol";
import {IAddressRegistry} from "../interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "../interfaces/compliance/IFrozenRegistry.sol";
import {TransferError} from "../exception/TransferError.sol";
import {LogAddress} from "../utils/LogAddress.sol";

abstract contract DigitalTokenV2 is
    ERC20,
    ERC20Capped,
    IERC5679,
    IERC6372,
    LogAddress,
    TransferError
{
    struct Timestamp {
        uint48 start;
        uint48 end;
    }

    IERC5679 private _merchantDigitalToken;
    IAddressRegistry private _addressRegistry;
    IFrozenRegistry private _frozenRegistry;

    Timestamp private _Timestamp;

    event TimestampUpdated(Timestamp oldTimestamp, Timestamp newTimestamp);

    error InvalidStartTime(uint48 startTime, uint48 endTime);
    error InvalidTime();

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 cap_,
        uint48 startTime_,
        uint48 endTime_
    ) ERC20(name_, symbol_) ERC20Capped(cap_) {
        _updateTime(startTime_, endTime_);
    }

    function _updateTime(uint48 start, uint48 end) internal virtual {
        if (start == 0 || end == 0) {
            revert InvalidTime();
        }
        if (start <= end) {
            revert InvalidStartTime(start, end);
        }
        Timestamp memory oldTimestamp = _Timestamp;
        _Timestamp.start = start;
        _Timestamp.end = end;

        emit TimestampUpdated(oldTimestamp, _Timestamp);
    }

    function _updateMerchantDigitalToken(IERC5679 merchantDigitalToken) internal virtual {
        address oldMerchantDigitalToken = address(_merchantDigitalToken);
        _merchantDigitalToken = merchantDigitalToken;

        emit Log(
            "merchant_digital_token",
            oldMerchantDigitalToken,
            address(merchantDigitalToken)
        );
    }

    function _updateAddressRegistry(IAddressRegistry addressRegistry) internal virtual {
        address oldAddressRegistry = address(_addressRegistry);
        _addressRegistry = addressRegistry;

        emit Log("address_registry", oldAddressRegistry, address(addressRegistry));
    }

    function _updateFrozenRegistry(IFrozenRegistry frozenRegistry) internal {
        address oldFrozenRegistry = address(frozenRegistry);
        _frozenRegistry = frozenRegistry;

        emit Log("frozen_registry", oldFrozenRegistry, address(frozenRegistry));
    }

    function _beforeTransfer(address from, address to, uint256 amount) internal virtual {
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

    function _afterTransfer(address from, address to, uint256 amount) internal {
        _burn(to, amount);
        _merchantDigitalToken.mint(to, amount, "");
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Capped) {
        super._update(from, to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        _beforeTransfer(msg.sender, to, amount);
        _transfer(msg.sender, to, amount);
        _afterTransfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        _beforeTransfer(from, to, amount);
        _transfer(from, to, amount);
        _afterTransfer(from, to, amount);
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

    function startTime() public view returns (uint48) {
        return _Timestamp.start;
    }

    function endTime() public view returns (uint48) {
        return _Timestamp.end;
    }

    /// @dev if true citizen can transfer, otherwise not.
    function isTransferable() public view returns (bool) {
        return clock() >= _Timestamp.start && clock() <= _Timestamp.end;
    }
}
