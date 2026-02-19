const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Signature Replay Lab", function () {
  it("VulnerableAirdrop allows signature replay", async () => {
    const [signer, user] = await ethers.getSigners();

    const Vulnerable = await ethers.getContractFactory("VulnerableAirdrop");
    const airdrop = await Vulnerable.deploy(signer.address);
    await airdrop.waitForDeployment();

    const amount = 100n;

    // Sign message: keccak(msg.sender, amount) with eth_sign style prefix
    const messageHash = ethers.solidityPackedKeccak256(
      ["address", "uint256"],
      [user.address, amount]
    );

    const sig = await signer.signMessage(ethers.getBytes(messageHash));

    await airdrop.connect(user).claim(amount, sig);
    await airdrop.connect(user).claim(amount, sig); // replay

    expect(await airdrop.claimed(user.address)).to.equal(200n);
  });

  it("SafeAirdrop blocks replay using nonce", async () => {
    const [signer, user] = await ethers.getSigners();

    const Safe = await ethers.getContractFactory("SafeAirdrop");
    const airdrop = await Safe.deploy(signer.address);
    await airdrop.waitForDeployment();

    const amount = 100n;
    const nonce = 0n;

    const messageHash = ethers.solidityPackedKeccak256(
      ["address", "uint256", "address", "uint256", "uint256"],
      [
        await airdrop.getAddress(),
        await ethers.provider.getNetwork().then(n => n.chainId),
        user.address,
        amount,
        nonce
      ]
    );

    const sig = await signer.signMessage(ethers.getBytes(messageHash));

    await airdrop.connect(user).claim(amount, nonce, sig);

    // Replay should fail because nonce already incremented
    await expect(
      airdrop.connect(user).claim(amount, nonce, sig)
    ).to.be.revertedWith("bad nonce");

    expect(await airdrop.claimed(user.address)).to.equal(100n);
  });
});
