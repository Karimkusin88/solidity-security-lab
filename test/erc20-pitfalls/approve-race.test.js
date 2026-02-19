const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC20 Pitfalls Lab - Approve Race Condition", function () {
  it("Vulnerable pattern: spender can spend old allowance then new allowance (X + Y)", async () => {
    const [user, spenderEOA] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("MockERC20");
    const token = await Token.deploy();
    await token.waitForDeployment();

    const Spender = await ethers.getContractFactory("VulnerableSpender");
    const spender = await Spender.deploy(await token.getAddress());
    await spender.waitForDeployment();

    await token.mint(user.address, 1000);

    // User approves X=100
    await token.connect(user).approve(await spender.getAddress(), 100);

    // "Front-run": spender spends old allowance X=100 before user updates allowance
    await spender.connect(spenderEOA).spend(user.address, 100);

    // User updates allowance to Y=200 using approve(200) (vulnerable pattern)
    await token.connect(user).approve(await spender.getAddress(), 200);

    // Spender spends again up to Y=200
    await spender.connect(spenderEOA).spend(user.address, 200);

    expect(await token.balanceOf(await spender.getAddress())).to.equal(300);
    expect(await token.balanceOf(user.address)).to.equal(700);
  });

  it("Safer pattern: reset to 0 before setting new allowance reduces race window", async () => {
    const [user, spenderEOA] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("MockERC20");
    const token = await Token.deploy();
    await token.waitForDeployment();

    const Spender = await ethers.getContractFactory("VulnerableSpender");
    const spender = await Spender.deploy(await token.getAddress());
    await spender.waitForDeployment();

    await token.mint(user.address, 1000);

    // Approve X=100
    await token.connect(user).approve(await spender.getAddress(), 100);

    // Spender spends X=100 (could happen)
    await spender.connect(spenderEOA).spend(user.address, 100);

    // Safer update pattern: approve(0) then approve(200)
    await token.connect(user).approve(await spender.getAddress(), 0);
    await token.connect(user).approve(await spender.getAddress(), 200);

    // Spender can only spend up to 200 next
    await spender.connect(spenderEOA).spend(user.address, 200);

    expect(await token.balanceOf(await spender.getAddress())).to.equal(300);
    expect(await token.balanceOf(user.address)).to.equal(700);
  });
});
