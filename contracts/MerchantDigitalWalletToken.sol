// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {WholesaleDigitalToken} from "./abstracts/WholesaleDigitalToken.sol";
import {AddressRegistryError} from "./exception/AddressRegistryError.sol";
import {IAddressRegistry} from "./interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "./interfaces/compliance/IFrozenRegistry.sol";
import {IIssuer} from "./interfaces/compliance/IIssuer.sol";

/// @dev Ownable is compatible with ERC-173
contract MerchantDigitalWalletToken is
    AddressRegistryError,
    IIssuer,
    WholesaleDigitalToken,
    Ownable
{
    address private _issuer;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 cap_,
        address owner_,
        IAddressRegistry addressRegistry_,
        IFrozenRegistry frozenRegistry_
    ) WholesaleDigitalToken(name_, symbol_, cap_) Ownable(owner_) {
        _updateAddressRegistry(addressRegistry_);
        _updateFrozenRegistry(frozenRegistry_);
    }

    function mint(address to, uint256 amount, bytes calldata data) public virtual override {
        if (!isIssuer(msg.sender)) {
            revert(); // @TODO
        }
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

    function isIssuer(address account) public view override returns (bool) {
        return _issuer == account;
    }

    function addIssuer(address issuer) public override onlyOwner returns (bool) {
        if (issuer == address(0)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.INVALID_ADDRESS);
        }
        if (isIssuer(issuer)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.EXIST);
        }
        address oldIssuer = _issuer;
        _issuer = issuer;

        emit Log("issuer_address", oldIssuer, issuer);
    }

    function removeIssuer(address issuer) public override onlyOwner returns (bool) {
        if (!isIssuer(issuer)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.NOT_EXIST);
        }
        address oldIssuer = _issuer;
        delete _issuer;

        emit Log("issuer_address", oldIssuer, address(0));
    }

    /// @dev RESERVED_01 mean InvalidCallerNotOwnerOrIssuer;
    function transferIssuer(address newIssuer) public override {
        if (!isIssuer(msg.sender) || msg.sender != owner()) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.RESERVED01);
        }
        if (newIssuer == address(0)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.INVALID_ADDRESS);
        }
        if (isIssuer(newIssuer)) {
            revert InvalidAddressRegistryType(REGISTRY_ERROR_TYPE.EXIST);
        }
        address oldIssuer = _issuer;
        _issuer = newIssuer;

        emit Log("issuer_address", oldIssuer, newIssuer);
    }
}
