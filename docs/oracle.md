# Oracle Manipulation Lab

## What is the issue?

Using spot price directly in DeFi contracts is dangerous.
Attackers can manipulate the price briefly and exploit contracts relying on it.

## Vulnerable Pattern
- Uses immediate spot price
- No time-weighted averaging
- No delay mechanism

## Safe Pattern
- Introduces delay between updates
- Prevents rapid price flipping
- Simulates TWAP-style logic

## Proof
```bash
npx hardhat test test/oracle/oracle.test.js

