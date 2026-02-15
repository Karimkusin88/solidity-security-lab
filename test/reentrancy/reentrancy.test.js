const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Reentrancy Lab (V2 stable)", function () {
  it("VulnerableBankV2 can be drained via reentrancy", async () => {
    const [attackerEOA, victim] = await ethers.getSigners();

    const Bank = await ethers.getContractFactory("VulnerableBankV2");
    const bank = await Bank.deploy();
    await bank.waitForDeployment();

    // victim deposits 5 ETH
    await bank.connect(victim).deposit({ value: ethers.parseEther("5") });

    const Attacker = await ethers.getContractFactory("ReentrancyAttackerV2");
    const attacker = await Attacker.connect(attackerEOA).deploy(await bank.getAddress());
    await attacker.waitForDeployment();

    await attacker.setMaxLoops(10);

    // attacker deposits 1 ETH and triggers drain
    await attacker.connect(attackerEOA).attack({ value: ethers.parseEther("1") });

    // bank should be drained (or near 0)
    const bankBal = await bank.bankBalance();
    expect(bankBal).to.equal(0n);
  });

  it("SafeBankV2 resists reentrancy", async () => {
    const [attackerEOA, victim] = await ethers.getSigners();

    const Bank = await ethers.getContractFactory("SafeBankV2");
    const bank = await Bank.deploy();
    await bank.waitForDeployment();

    await bank.connect(victim).deposit({ value: ethers.parseEther("5") });

    const Attacker = await ethers.getContractFactory("ReentrancyAttackerV2");
    const attacker = await Attacker.connect(attackerEOA).deploy(await bank.getAddress());
    await attacker.waitForDeployment();

    await attacker.setMaxLoops(10);

    // should revert because after first withdrawAll, balance becomes 0
    await expect(
      attacker.connect(attackerEOA).attack({ value: ethers.parseEther("1") })
    ).to.be.reverted;

    expect(await bank.bankBalance()).to.equal(ethers.parseEther("5"));
  });
});
