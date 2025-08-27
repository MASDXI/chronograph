import {expect} from "chai";
import {hexlify, randomBytes, ZeroHash} from "ethers";
import hre, {network} from "hardhat";

describe("AddressRegistry", function () {
  const expectLocationHash = randomBytes(32);

  afterEach(async function () {
    await network.provider.send("hardhat_reset");
  });

  it("[SUCCESS]: Add address to citizen list", async function () {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const AddressRegistry = await hre.ethers.getContractFactory("AddressRegistry");
    const addressRegistry = await AddressRegistry.deploy(owner.address);

    await expect(addressRegistry.addAddressToCitizenList(otherAccount.address, expectLocationHash))
      .to.emit(addressRegistry, "AddedToCitizenList")
      .withArgs(owner.address, otherAccount.address);

    expect(await addressRegistry.isCitizen(otherAccount.address)).to.equal(true);
    expect((await addressRegistry.locationId(otherAccount.address)).toString()).to.equal(hexlify(expectLocationHash));
  });

  it("[SUCCESS]: Add address to merchant list", async function () {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const AddressRegistry = await hre.ethers.getContractFactory("AddressRegistry");
    const addressRegistry = await AddressRegistry.deploy(owner.address);

    await expect(addressRegistry.addAddressToMerchantList(otherAccount.address, expectLocationHash))
      .to.emit(addressRegistry, "AddedToMerchantList")
      .withArgs(owner.address, otherAccount.address);

    expect(await addressRegistry.isMerchant(otherAccount.address)).to.equal(true);
    expect((await addressRegistry.locationId(otherAccount.address)).toString()).to.equal(hexlify(expectLocationHash));
  });

  it("[SUCCESS]: Remove address from citizen list", async function () {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const AddressRegistry = await hre.ethers.getContractFactory("AddressRegistry");
    const addressRegistry = await AddressRegistry.deploy(owner.address);
    await addressRegistry.addAddressToCitizenList(otherAccount.address, expectLocationHash);
    await expect(addressRegistry.removeAddressFromCitizenList(otherAccount.address))
      .to.emit(addressRegistry, "RemovedFromCitizenList")
      .withArgs(owner.address, otherAccount.address);

    expect(await addressRegistry.isCitizen(otherAccount.address)).to.equal(false);
    expect((await addressRegistry.locationId(otherAccount.address)).toString()).to.equal(ZeroHash);
  });

  it("[SUCCESS]: Remove address from merchant list", async function () {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const AddressRegistry = await hre.ethers.getContractFactory("AddressRegistry");
    const addressRegistry = await AddressRegistry.deploy(owner.address);
    await addressRegistry.addAddressToMerchantList(otherAccount.address, expectLocationHash);
    await expect(addressRegistry.removeAddressFromMerchantList(otherAccount.address))
      .to.emit(addressRegistry, "RemovedFromMerchantList")
      .withArgs(owner.address, otherAccount.address);

    expect(await addressRegistry.isMerchant(otherAccount.address)).to.equal(false);
    expect((await addressRegistry.locationId(otherAccount.address)).toString()).to.equal(ZeroHash);
  });
});
