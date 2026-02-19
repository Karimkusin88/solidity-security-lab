const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Oracle Manipulation Lab", function () {

  it("VulnerableOracle allows instant manipulation", async () => {
    const [attacker] = await ethers.getSigners();

    const Oracle = await ethers.getContractFactory("VulnerableOracle");
    const oracle = await Oracle.deploy();
    await oracle.waitForDeployment();

    await oracle.setPrice(100);
    expect(await oracle.buy()).to.equal(100);

    // Attacker manipulates price
    await oracle.connect(attacker).setPrice(1);

    expect(await oracle.buy()).to.equal(1);
  });

  it("SafeOracle prevents rapid manipulation", async () => {
    const Oracle = await ethers.getContractFactory("SafeOracle");
    const oracle = await Oracle.deploy();
    await oracle.waitForDeployment();

    await oracle.setPrice(100);

    await expect(
      oracle.setPrice(1)
    ).to.be.revertedWith("update too soon");
  });

});
