// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IAddressRegistry} from "./interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "./interfaces/compliance/IFrozenRegistry.sol";
import {DigitalToken} from "./abstracts/DigitalToken.sol";

contract DigitWalletToken is DigitalToken, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        address owner_,
        IAddressRegistry addressRegistry_,
        IFrozenRegistry frozenRegistry_
    ) DigitalToken(name_, symbol_) Ownable(owner_) {
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
