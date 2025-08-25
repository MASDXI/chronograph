// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RetailToken} from "./abstracts/RetailToken.sol";
import {IAddressRegistry} from "./interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "./interfaces/compliance/IFrozenRegistry.sol";

/// @dev Ownable is compatible with ERC-173
contract DigitalWalletToken is RetailToken, Ownable {
    /// @dev hardcoded configuration to match requirement.
    // epoch duration is 6 months 15_778_458 seconds
    // window size 1 epoch
    constructor(
        string memory name_,
        string memory symbol_,
        address owner_,
        IAddressRegistry addressRegistry_,
        IFrozenRegistry frozenRegistry_
    ) RetailToken(name_, symbol_, block.timestamp, 15_778_458, 1) Ownable(owner_) {
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
}
