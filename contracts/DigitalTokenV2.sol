// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC5679} from "./interfaces/IERC5679-ERC20.sol";
import {IERC6372} from "./interfaces/review-IERC6372.sol";

/// @custom:strict allowed to override _updateTime, _updateRegistry and _updateMerchantToken only.
abstract contract DigitalWalletTokenLite is ERC20, IERC6372 {
    uint48 private _startTime;
    uint48 private _endTime;

    IERC5679 private _merchantToken;

    // @TODO AddressRegistry;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function _beforeTransfer(address from, address to, uint256 amount) internal {
        if (isTransferPeriod()) {
            // @TODO
            // from (Citizen) and to (Citizen) not allowed C2C transfer.
            // from (Merchant) and to (Citizen) not allowed B2C transfer.
            // from (Citizen) and to (Merchant) are in same district.
        }
    }

    function _afterTransfer(address from, address to, uint256 amount) internal {
        _burn(to, amount);
        _merchantToken.mint(to, amount, "");
    }

    function _updateTime(uint48 startTime, uint48 endTime) internal virtual {
        _startTime = startTime;
        _endTime = endTime;

        // @TODO emit event
    }

    function _updateMerchantToken(IERC5679 merchantToken) internal virtual {
        _merchantToken = merchantToken;

        // @TODO emit event
    }

    // @TODO
    // function _updateAddressRegistry(IAddressRegistry addressRegistry) internal virtual {}

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

    /// @dev See {IERC6372-clock}.
    function clock() public view returns (uint48) {
        return uint48(block.timestamp);
    }

    /// @dev See {IERC6372-CLOCK_MODE}.
    function CLOCK_MODE() public view returns (string memory) {
        return string.concat("mode=timestamp&from=eip155:", Strings.toString(block.chainid));
    }

    function startTime() public view returns (uint48) {
        return _startTime;
    }

    function endTime() public view returns (uint48) {
        return _endTime;
    }

    function isTransferable() public view returns (bool) {
        return clock() >= _startTime && clock() <= _endTime;
    }
}
