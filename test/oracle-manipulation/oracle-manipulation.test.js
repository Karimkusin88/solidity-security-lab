const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Oracle Manipulation Lab (AMM spot price)", function () {
  it("VulnerableLending: attacker manipulates spot price and borrows more", async () => {
    const [deployer, attacker] = await ethers.getSigners();

    // Start with reserves: X=1000, Y=1000 => price ~ 1.0
    const AMM = await ethers.getContractFactory("SimpleAMM", deployer);
    const amm = await AMM.deploy(1000n, 1000n);
    await amm.waitForDeployment();

    const Lend = await ethers.getContractFactory("VulnerableLending", deployer);
    const lend = await Lend.deploy(await amm.getAddress());
    await lend.waitForDeployment();

    // Attacker deposits collateral: 10 X
    await lend.connect(attacker).depositCollateral(10);

    const priceBefore = await amm.spotPriceYperX();
    const maxBefore = await lend.maxBorrowY(attacker.address);

    // Manipulate price: push Y reserve up by swapping Y in (raise Y/X)
    // We don't model real token balances; AMM is virtual. Just move reserves.
    await amm.connect(attacker).swapYforX(900); // big Y in => reserveY increases, reserveX decreases -> price Y/X increases

    const priceAfter = await amm.spotPriceYperX();
    const maxAfter = await lend.maxBorrowY(attacker.address);

    expect(priceAfter).to.be.gt(priceBefore);
    expect(maxAfter).to.be.gt(maxBefore);

    // Borrow an amount that would exceed before, but fits after manipulation
    const borrowAmt = maxAfter;
    await lend.connect(attacker).borrow(borrowAmt);

    expect(await lend.debtY(attacker.address)).to.equal(borrowAmt);
  });

  it("SafeLending: blocks borrowing using a fresh snapshot after manipulation", async () => {
    const [deployer, attacker] = await ethers.getSigners();

    const AMM = await ethers.getContractFactory("SimpleAMM", deployer);
    const amm = await AMM.deploy(1000n, 1000n);
    await amm.waitForDeployment();

    const Safe = await ethers.getContractFactory("SafeLending", deployer);
    const safe = await Safe.deploy(await amm.getAddress());
    await safe.waitForDeployment();

    await safe.connect(attacker).depositCollateral(10);

    // Attacker manipulates spot price
    await amm.connect(attacker).swapYforX(900);

    // Attacker tries to update snapshot and borrow immediately (same time window)
    await safe.connect(attacker).updatePriceSnapshot();

    await expect(
      safe.connect(attacker).borrow(1)
    ).to.be.revertedWith("snapshot too fresh");
  });
});
