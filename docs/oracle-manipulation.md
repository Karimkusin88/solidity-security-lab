# Oracle Manipulation Lab (Spot Price Attack)

## What is the issue?
Using AMM **spot price** as an oracle is dangerous. Attackers can manipulate reserves with a large swap, then immediately call a function that relies on the manipulated price in the same transaction / block window.

## Where in this repo
- AMM: `contracts/oracle-manipulation/SimpleAMM.sol`
- Vulnerable: `contracts/oracle-manipulation/VulnerableLending.sol`
- Safe-ish: `contracts/oracle-manipulation/SafeLending.sol`
- Tests: `test/oracle-manipulation/oracle-manipulation.test.js`

## Exploit (high level)
1. Deposit collateral.
2. Perform a large swap to move reserves and manipulate spot price.
3. Borrow using inflated collateral valuation.

## Fix (production guidance)
- Use TWAP or external oracle (e.g., Chainlink) depending on protocol needs.
- Add time delays / price snapshots that cannot be updated and used instantly.
- Use circuit breakers (max price deviation), and liquidity-aware designs.

## Proof
```bash
npx hardhat test test/oracle-manipulation/oracle-manipulation.test.js

## Expected Wake findings
- Vulnerable oracle patterns may trigger oracle-related or economic-risk heuristics (tool coverage varies).
- Safe variant should prevent same-window update-and-borrow flows.
