const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("tx.origin Lab", function () {

  it("Vulnerable contract can be exploited", async () => {
    const [owner, attackerEOA] = await ethers.getSigners();

    const Vulnerable = await ethers.getContractFactory("VulnerableTxOrigin");
    const vulnerable = await Vulnerable.connect(owner).deploy();
    await vulnerable.waitForDeployment();

    // fund vulnerable contract
    await owner.sendTransaction({
      to: await vulnerable.getAddress(),
      value: ethers.parseEther("2"),
    });

    const Attacker = await ethers.getContractFactory("TxOriginAttacker");
    const attacker = await Attacker.connect(attackerEOA).deploy(await vulnerable.getAddress());
    await attacker.waitForDeployment();

    // owner gets tricked into calling attacker contract
    await attacker.connect(owner).attack();

    // attacker contract should now hold funds
    const attackerBalance = await ethers.provider.getBalance(await attacker.getAddress());
    expect(attackerBalance).to.equal(ethers.parseEther("2"));
  });


  it("Safe contract resists tx.origin exploit", async () => {
    const [owner, attackerEOA] = await ethers.getSigners();

    const Safe = await ethers.getContractFactory("SafeTxOrigin");
    const safe = await Safe.connect(owner).deploy();
    await safe.waitForDeployment();

    await owner.sendTransaction({
      to: await safe.getAddress(),
      value: ethers.parseEther("2"),
    });

    const Attacker = await ethers.getContractFactory("TxOriginAttacker");
    const attacker = await Attacker.connect(attackerEOA).deploy(await safe.getAddress());
    await attacker.waitForDeployment();

    await expect(
      attacker.connect(owner).attack()
    ).to.be.reverted;

    expect(await ethers.provider.getBalance(await safe.getAddress()))
      .to.equal(ethers.parseEther("2"));
  });

});
