// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IAddressRegistry} from "./interfaces/compliance/IAddressRegistry.sol";
import {IFrozenRegistry} from "./interfaces/compliance/IFrozenRegistry.sol";
import {IIssuer} from "./interfaces/compliance/IIssuer.sol";
import {MerchantDigitalToken} from "./abstracts/MerchantDigitalToken.sol";

contract MerchantToken is IIssuer, MerchantDigitalToken, Ownable {
    address private _issuer;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 cap_,
        address owner_,
        IAddressRegistry addressRegistry_,
        IFrozenRegistry frozenRegistry_
    ) MerchantDigitalToken(name_, symbol_, cap_) Ownable(owner_) {
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
            revert(); // @TODO
        }
        if (isIssuer(issuer)) {
            revert(); // @TODO
        }
        address oldIssuer = _issuer;
        _issuer = issuer;

        emit Log("issuer_address", oldIssuer, issuer);
    }

    function removeIssuer(address issuer) public override onlyOwner returns (bool) {
        if (issuer == address(0)) {
            revert(); // @TODO
        }
        if (!isIssuer(issuer)) {
            revert(); // @TODO
        }
        address oldIssuer = _issuer;
        delete _issuer;

        emit Log("issuer_address", oldIssuer, address(0));
    }

    function transferIssuer(address newIssuer) public override {
        if (!isIssuer(msg.sender) || msg.sender != owner()) {
            revert(); // @TODO
        }
        if (newIssuer == address(0)) {
            revert(); // @TODO
        }
        if (isIssuer(newIssuer)) {
            revert(); // @TODO
        }
        address oldIssuer = _issuer;
        _issuer = newIssuer;

        emit Log("issuer_address", oldIssuer, newIssuer);
    }
}
