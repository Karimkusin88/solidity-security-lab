# Denial of Service (DoS) Lab

## Vulnerability
Sending ETH in a loop using `transfer()` can fail entirely
if one recipient reverts.

## Pattern
❌ Push payments (loop + transfer)

## Fix
✅ Pull payments pattern
Users withdraw individually.

## Proof
```bash
npx hardhat test test/dos/dos.test.js

