// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC7818} from "@kiwarilabs/contracts/tokens/ERC20/ERC7818.sol";
import {ERC7818Exception} from "@kiwarilabs/contracts/tokens/ERC20/extensions/ERC7818Exception.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @custom:strict allowed to override _beforeTransfer and _afterTransfer only.
abstract contract DigitalWalletToken is ERC7818, ERC7818Exception {
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC7818(_name, _symbol, block.timestamp, 15778458, 1, false) {
        // epoch duration is 6 months 15_778_458 seconds
        // window size 1 epoch
    }

    function _beforeTransfer(address from, address to, uint256 amount) internal virtual {
        // @TODO
        // from (Citizen) and to (Citizen) not allowed C2C transfer.
        // from (Merchant) and to (Citizen) not allowed B2C transfer.
        // from (Citizen) and to (Merchant) are in same district.
    }

    function _afterTransfer(address from, address to, uint256 amount) internal virtual {
        // @TODO
        // burn received token from Merchant.
        // mint UTXO token to Merchant.
    }

    function _pointerProvider() internal view override returns (uint256) {
        return block.timestamp;
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function epochType() public pure override returns (EPOCH_TYPE) {
        return EPOCH_TYPE.TIME_BASED;
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
        _beforeTransfer(msg.sender, to, amount);
        super.transferAtEpoch(epoch, to, amount);
        _afterTransfer(msg.sender, to, amount);

        return true;
    }

    function transferFromAtEpoch(
        uint256 epoch,
        address from,
        address to,
        uint256 amount
    ) public override(ERC7818, ERC7818Exception) returns (bool) {
        _beforeTransfer(from, to, amount);
        super.transferFromAtEpoch(epoch, from, to, amount);
        _afterTransfer(from, to, amount);

        return true;
    }
}
