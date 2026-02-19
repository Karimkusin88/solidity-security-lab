const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Storage Collision Lab", function () {
  it("Bad upgrade corrupts storage (owner/value)", async () => {
    const [admin, alice] = await ethers.getSigners();

    const V1 = await ethers.getContractFactory("ImplV1");
    const v1 = await V1.deploy();
    await v1.waitForDeployment();

    const Proxy = await ethers.getContractFactory("SimpleProxy");
    const proxy = await Proxy.deploy(await v1.getAddress());
    await proxy.waitForDeployment();

    const v1AsProxy = await ethers.getContractAt("ImplV1", await proxy.getAddress());

    await v1AsProxy.initialize(alice.address);
    await v1AsProxy.connect(alice).setValue(1337);

    expect(await v1AsProxy.owner()).to.equal(alice.address);
    expect(await v1AsProxy.value()).to.equal(1337);

    // Upgrade to bad V2
    const V2Bad = await ethers.getContractFactory("ImplV2_Bad");
    const v2bad = await V2Bad.deploy();
    await v2bad.waitForDeployment();

    await proxy.connect(admin).upgradeTo(await v2bad.getAddress());

    const v2BadAsProxy = await ethers.getContractAt("ImplV2_Bad", await proxy.getAddress());

    // Now reading "newField" actually reads slot2 which used to be owner
    const newField = await v2BadAsProxy.newField();
    expect(newField).to.not.equal(0n);

    // Owner is now garbage (used to be value slot)
    const ownerCorrupted = await v2BadAsProxy.owner();
    expect(ownerCorrupted).to.not.equal(alice.address);
  });

  it("Good upgrade preserves storage and allows new field", async () => {
    const [admin, alice] = await ethers.getSigners();

    const V1 = await ethers.getContractFactory("ImplV1");
    const v1 = await V1.deploy();
    await v1.waitForDeployment();

    const Proxy = await ethers.getContractFactory("SimpleProxy");
    const proxy = await Proxy.deploy(await v1.getAddress());
    await proxy.waitForDeployment();

    const v1AsProxy = await ethers.getContractAt("ImplV1", await proxy.getAddress());

    await v1AsProxy.initialize(alice.address);
    await v1AsProxy.connect(alice).setValue(1337);

    // Upgrade to good V2
    const V2Good = await ethers.getContractFactory("ImplV2_Good");
    const v2good = await V2Good.deploy();
    await v2good.waitForDeployment();

    await proxy.connect(admin).upgradeTo(await v2good.getAddress());

    const v2GoodAsProxy = await ethers.getContractAt("ImplV2_Good", await proxy.getAddress());

    // storage preserved
    expect(await v2GoodAsProxy.owner()).to.equal(alice.address);
    expect(await v2GoodAsProxy.value()).to.equal(1337);

    // new field works
    await v2GoodAsProxy.connect(alice).setNewField(42);
    expect(await v2GoodAsProxy.newField()).to.equal(42);
  });
});
