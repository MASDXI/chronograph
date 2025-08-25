// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RetailTokenV2} from "./abstracts/RetailTokenV2.sol";
import {IERC5679Ext20 as IERC5679} from "./interfaces/IERC5679.sol";
import {IAddressRegistry} from "./interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "./interfaces/compliance/IFrozenRegistry.sol";

/// @dev Ownable is compatible with ERC-173
contract DigitalWalletTokenV2 is RetailTokenV2, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 cap_,
        uint48 startTime_,
        uint48 endTime_,
        address owner_,
        IAddressRegistry addressRegistry_,
        IFrozenRegistry frozenRegistry_
    ) RetailTokenV2(name_, symbol_, cap_, startTime_, endTime_) Ownable(owner_) {
        _updateAddressRegistry(addressRegistry_);
        _updateFrozenRegistry(frozenRegistry_);
    }

    function mint(
        address to,
        uint256 amount,
        bytes calldata data
    ) public virtual override onlyOwner {
        super.mint(to, amount, data);
    }

    function burn(
        address from,
        uint256 amount,
        bytes calldata data
    ) public virtual override onlyOwner {
        super.burn(from, amount, data);
    }

    function updateAddressRegistry(IAddressRegistry addressRegistry) public onlyOwner {
        _updateAddressRegistry(addressRegistry);
    }

    function updateFrozenRegistry(IFrozenRegistry frozenRegistry) public onlyOwner {
        _updateFrozenRegistry(frozenRegistry);
    }

    function updateMerchantDigitalToken(IERC5679 merchantDigitalToken) public onlyOwner {
        updateMerchantDigitalToken(merchantDigitalToken);
    }
}
