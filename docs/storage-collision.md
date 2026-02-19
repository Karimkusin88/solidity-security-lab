# Storage Collision Lab (Upgradeable Contracts)

## What is the issue?
In upgradeable contracts, storage lives in the proxy.
If a new implementation changes variable order, storage slots shift and state becomes corrupted.

## Where in this repo
- Proxy: `contracts/storage-collision/SimpleProxy.sol`
- V1: `contracts/storage-collision/ImplV1.sol`
- V2 Bad: `contracts/storage-collision/ImplV2_Bad.sol`
- V2 Good: `contracts/storage-collision/ImplV2_Good.sol`
- Tests: `test/storage-collision/storage-collision.test.js`

## Fix
- Never reorder or insert variables in the middle
- Only append new variables at the end
- Use storage gaps / audited upgrade patterns (OpenZeppelin)

## Proof
```bash
npx hardhat test test/storage-collision/storage-collision.test.js

