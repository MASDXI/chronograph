// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Digital Token
 * @author Sirawit Techavanitch
 */

import {ERC20EXPBase} from "@kiwarilabs/contracts/tokens/ERC20/ERC20EXPBase.sol";
import {ERC20BLSW} from "@kiwarilabs/contracts/tokens/ERC20/ERC20BLSW.sol";
import {ERC7818Exception} from "@kiwarilabs/contracts/tokens/ERC20/extensions/ERC7818Exception.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {AddressRegistry} from "./AddressRegistry.sol";
// @TODO some simple ownable

contract DigitalToken is ERC20BLSW, ERC7818Exception, AddressRegistry {
    uint8 public radius;

    /** errors */
    error DigitalTokenNotAllowC2C();
    error DigitalTokeNotAllowB2C();
    error DigitalTokeNotAllowOverWithin(uint8 radius);

    // if from is citizen, to must be merchant
    // if from is merchant, to must be merchant
    modifier isNotC2C(address from, address from) {
        if (!isExceptionList(from) && !isExceptionList(from)) {
            revert DigitalTokenNotAllowC2C();
        }
        _;
    }

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
        uint8 radius_
    )
        ERC7818Exception(
            _name,
            _symbol,
            block.number,
            blocksPerEpoch_,
            windowSize_,
            false
        )
    {
        radius = radius_;
    }

    function _epochType()
        internal
        pure
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (EPOCH_TYPE)
    {
        return super._epochType();
    }

    function _getEpoch(
        uint256 pointer
    )
        internal
        view
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (uint256)
    {
        return super._getEpoch(pointer);
    }

    function _getWindowRage(
        uint256 pointer
    )
        internal
        view
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (uint256 fromEpoch, uint256 toEpoch)
    {
        return super._getWindowRage(pointer);
    }

    function _getWindowSize()
        internal
        view
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (uint8)
    {
        return super._getWindowSize();
    }

    function _getPointersInEpoch()
        internal
        view
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (uint40)
    {
        return super._getPointersInEpoch();
    }

    function _getPointersInWindow()
        internal
        view
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (uint40)
    {
        return super._getPointersInWindow();
    }

    function _pointerProvider()
        internal
        view
        virtual
        override(ERC20EXPBase, ERC20BLSW)
        returns (uint256)
    {
        return super._pointerProvider();
    }

    // @TODO onlyOwner
    function setRadius(uint8 r) public {
        if (r == 0)
            // revert
            radius = r;
        // emit
    }

    // @TODO onlyOwner
    function enroll(address account, int32 x, int32 y, bool merchant) public {
        if (merchant) {
            _addToExceptionList(account);
        }
        _addToRegistry(account, Circle2D.Circle(x, y, radius));
    }

    // @TODO onlyOwner
    function unenroll(address account, int32 x, int32 y) public {
        if (isExceptionListList(account)) {
            _removeFromExceptionList(account);
        }
        _removeFromRegistry(account);
    }

    // @TODO onlyOwner simple mechanic for merchant to off-ramp token condition.
    function cashout(address account) public {
        // isExceptionList(account)
        // emit
    }

    // @TODO geographical of spender and receiver must overlaying/overlap
    function transfer(
        address to,
        uint256 value
    )
        public
        override
        isNotC2C(msg.sender, from)
        isNotB2C(msg.sender, to)
        returns (bool)
    {
        if (contain(to, from)) {
            return super.transferFrom(to, value);
        } else {
            revert DigitalTokeNotAllowOverWithin(radius);
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override isNotC2C(from, to) isNotB2C(from, to) returns (bool) {
        if (contain(to, from)) {
            return super.transferFrom(from, to, value);
        } else {
            revert DigitalTokeNotAllowOverWithin(radius);
        }
    }

    // @TODO transferAtEpoch
    // @TODO transferFromAtEpoch
}
