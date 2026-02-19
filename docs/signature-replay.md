# Signature Replay Lab

## What is the issue?
A signature can be valid forever unless you bind it to a one-time constraint.
If a contract verifies a signature but does not use a nonce (or similar),
an attacker can replay the same signature multiple times.

## Where in this repo
- Vulnerable: `contracts/signature-replay/VulnerableAirdrop.sol`
- Safe: `contracts/signature-replay/SafeAirdrop.sol`
- Tests: `test/signature-replay/signature-replay.test.js`

## Exploit (high level)
1. User obtains a valid signature from a trusted signer.
2. User calls `claim()` once (works).
3. User calls `claim()` again with the same signature (replay).
4. Contract accepts again and increments claim.

## Fix
- Add per-user nonce
- Include `address(this)` and `chainId` in the signed message (domain separation)
- Increment nonce after successful verification

## Proof
```bash
npx hardhat test test/signature-replay/signature-replay.test.js

