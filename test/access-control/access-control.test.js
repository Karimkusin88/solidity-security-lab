const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Access Control Lab", function () {

  it("VulnerableVault can be hijacked", async () => {
    const [deployer, attacker] = await ethers.getSigners();

    const Vault = await ethers.getContractFactory("VulnerableVault");
    const vault = await Vault.connect(deployer).deploy();
    await vault.waitForDeployment();

    // fund vault with 2 ETH
    await deployer.sendTransaction({
      to: await vault.getAddress(),
      value: ethers.parseEther("2"),
    });

    // attacker takes ownership
    await vault.connect(attacker).setOwner(attacker.address);

    // attacker withdraws funds
    await expect(
      vault.connect(attacker).withdrawAll()
    ).to.not.be.reverted;
  });


  it("SafeVault prevents ownership hijack", async () => {
    const [deployer, attacker] = await ethers.getSigners();

    const Vault = await ethers.getContractFactory("SafeVault");
    const vault = await Vault.connect(deployer).deploy();
    await vault.waitForDeployment();

    await deployer.sendTransaction({
      to: await vault.getAddress(),
      value: ethers.parseEther("2"),
    });

    // attacker tries to withdraw
    await expect(
      vault.connect(attacker).withdrawAll()
    ).to.be.reverted;
  });

});
