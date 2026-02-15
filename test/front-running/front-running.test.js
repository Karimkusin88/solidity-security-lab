const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Front-Running Lab", function () {

  it("VulnerableGame allows copycat attack", async () => {
    const [alice, bob] = await ethers.getSigners();

    const Game = await ethers.getContractFactory("VulnerableGame");
    const game = await Game.deploy();
    await game.waitForDeployment();

    // Alice submits correct guess
    await game.connect(alice).guess(42);

    expect(await game.winner()).to.equal(alice.address);
  });


  it("SafeGame protects with commit-reveal", async () => {
    const [alice] = await ethers.getSigners();

    const Game = await ethers.getContractFactory("SafeGame");
    const game = await Game.deploy();
    await game.waitForDeployment();

    const number = 42;
    const secret = "my-secret";

    const hash = ethers.keccak256(
      ethers.solidityPacked(["uint256", "string"], [number, secret])
    );

    await game.connect(alice).commit(hash);
    await game.connect(alice).reveal(number, secret);

    expect(await game.winner()).to.equal(alice.address);
  });

});
