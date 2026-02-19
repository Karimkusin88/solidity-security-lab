const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DoS Lab", function () {

  it("VulnerableDistributor: one reverting receiver blocks all", async () => {
    const [user1] = await ethers.getSigners();

    const Reverter = await ethers.getContractFactory("RevertingReceiver");
    const bad = await Reverter.deploy();
    await bad.waitForDeployment();

    const recipients = [user1.address, await bad.getAddress()];

    const Distributor = await ethers.getContractFactory("VulnerableDistributor");
    const dist = await Distributor.deploy(recipients, {
      value: ethers.parseEther("1")
    });
    await dist.waitForDeployment();

    await expect(dist.distribute()).to.be.reverted;
  });

  it("SafeDistributor: good users can withdraw even if bad receiver reverts", async () => {
    const [user1] = await ethers.getSigners();

    const Reverter = await ethers.getContractFactory("RevertingReceiver");
    const bad = await Reverter.deploy();
    await bad.waitForDeployment();

    const recipients = [user1.address, await bad.getAddress()];

    const Safe = await ethers.getContractFactory("SafeDistributor");
    const safe = await Safe.deploy(recipients, {
      value: ethers.parseEther("1")
    });
    await safe.waitForDeployment();

    // Good user can withdraw
    await expect(safe.connect(user1).withdraw()).to.not.be.reverted;

    // The contract address (bad) cannot withdraw because it reverts
    const tx = await safe.withdraw.staticCall({ from: await bad.getAddress() }).catch(() => "reverted");
    expect(tx).to.equal("reverted");
  });

});
