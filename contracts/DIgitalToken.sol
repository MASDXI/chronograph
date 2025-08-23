// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC7818} from "@kiwarilabs/contracts/tokens/ERC20/ERC7818.sol";
import {ERC7818Exception} from "@kiwarilabs/contracts/tokens/ERC20/extensions/ERC7818Exception.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {AddressRegistry} from "./AddressRegistry.sol";

contract DigitalToken is ERC7818Exception, AddressRegistry, Ownable {
    uint8 public radius;

    event DigitalTokenRadiusUpdated(uint8 oldRadius, uint8 newRadius);
    event DigitalTokenCashOut(address indexed merchant, uint256 value);

    error DigitalTokenInvalidRadius();
    error DigitalTokenNotAllowC2C();
    error DigitalTokeNotAllowB2C();
    error DigitalTokeNotAllowOverWithin(uint8 radius);
    error DigitalTokenNotAllowCitizenToCashOut();

    // if from is citizen, to must be merchant
    modifier isNotC2C(address from, address from) {
        if (!isExceptionList(from) && !isExceptionList(from)) {
            revert DigitalTokenNotAllowC2C();
        }
        _;
    }

    // if from is merchant, to must be merchant
    modifier isNotB2C(address from, address from) {
        if (isExceptionList(from) && !isExceptionList(to)) {
            revert DigitalTokeNotAllowB2C();
        }
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint40 blocksPerEpoch_,
        uint8 windowSize_,
        uint8 radius_,
        address owner_
    ) ERC7818Exception(_name, _symbol, block.number, blocksPerEpoch_, windowSize_, false) Ownable(owner_) {
        radius = radius_;
    }

    function epochType() internal pure virtual override returns (EPOCH_TYPE) {
        return EPOCH_TYPE.TIME_BASED
    }

    function _pointerProvider() internal view virtual override returns (uint256) {
        return block.timestamp;
    }

    function setRadius(uint8 r) public onlyOwner {
        uint8 oldRadius = _radius;
        if (r == 0) revert DigitalTokenInvalidRadius();
        _radius = r;

        emit DigitalTokenRadiusUpdated(oldRadius, r);
    }

    function enroll(address account, int32 x, int32 y, bool merchant) public onlyOwner {
        if (merchant) {
            _addToExceptionList(account);
        }
        _addToRegistry(account, Circle2D.Circle(x, y, radius));
    }

    function unenroll(address account, int32 x, int32 y) public onlyOwner {
        if (isExceptionListList(account)) {
            _removeFromExceptionList(account);
        }
        _removeFromRegistry(account);
    }

    function cashOut(address account, uint256 value) public onlyOwner {
        if (!isExceptionList(account)) revert DigitalTokenNotAllowCitizenToCashOut();
        // _burn(account);

        emit DigitalTokenCashOut(account, value);
    }

    function transfer(address to, uint256 value) public override isNotC2C(msg.sender, from) isNotB2C(msg.sender, to) returns (bool) {
        if (contain(to, from)) {
            return super.transferFrom(to, value);
        } else {
            revert DigitalTokeNotAllowOverWithin(radius);
        }
    }

    function transferFrom(address from, address to, uint256 value) public override isNotC2C(from, to) isNotB2C(from, to) returns (bool) {
        if (contain(to, from)) {
            return super.transferFrom(from, to, value);
        } else {
            revert DigitalTokeNotAllowOverWithin(radius);
        }
    }

    // @TODO transferAtEpoch

    // @TODO transferFromAtEpoch
}
