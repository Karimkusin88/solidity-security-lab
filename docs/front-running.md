# Front-Running Lab

## What is front-running?

Front-running happens when an attacker observes a pending transaction (mempool),
copies or reacts to it, and submits a transaction with higher priority so it executes first.

This is common in:
- games with revealed moves
- first-come-first-served rewards
- predictable “secret” inputs
- DEX / MEV scenarios

---

## Where in this repo

- Contracts: contracts/front-running/*
- Tests: test/front-running/front-running.test.js

---

## How the exploit works (high level)

1. Victim submits a transaction revealing a move/secret.
2. Attacker sees it in the mempool.
3. Attacker submits the same move with higher priority.
4. Attacker’s tx executes first and wins/steals the outcome.

---

## Fix

Use commit-reveal:
1. Commit: submit hash(secret, salt)
2. Reveal later: submit secret + salt
3. Contract verifies hash matches commit

Other mitigations:
- private mempool / relays
- batch auctions
- reduce value of being first

---

## Proof

Run:

```bash
npx hardhat test test/front-running/front-running.test.js
```

Expected:
- VulnerableGame allows copycat attack
- SafeGame protects with commit-reveal
