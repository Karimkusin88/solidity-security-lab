# ERC20 Pitfalls Lab — Approve Race Condition

## What is the issue?
If a user changes an allowance from X to Y using `approve(Y)` directly, a spender can:
1) spend the old allowance X before the update (front-run),
2) then spend the new allowance Y after the update.

Result: spender can drain up to X + Y.

## Where in this repo
- Token: `contracts/erc20-pitfalls/MockERC20.sol`
- Spender: `contracts/erc20-pitfalls/VulnerableSpender.sol`
- Safe pattern helper: `contracts/erc20-pitfalls/SafeAllowanceHelper.sol`
- Tests: `test/erc20-pitfalls/approve-race.test.js`

## Fix patterns
- Reset allowance to 0 before setting a new value:
  - `approve(spender, 0)` then `approve(spender, newAmount)`
- Prefer `increaseAllowance/decreaseAllowance` if token supports it.
- For protocols: consider pull-based approvals per action (permits / signatures) when appropriate.

## Proof
```bash
npx hardhat test test/erc20-pitfalls/approve-race.test.js

