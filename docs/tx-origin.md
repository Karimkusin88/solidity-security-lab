# tx.origin Lab

## What is the issue?

Using `tx.origin` for authorization is unsafe.

`tx.origin` returns the original external account that started the transaction.
If a victim interacts with a malicious contract, that contract can call your contract — and `tx.origin` will still be the victim's address.

This allows phishing-style attacks.

It also breaks compatibility with account abstraction (e.g. ERC-4337).

---

## Where in this repo

- Vulnerable: contracts/tx-origin/VulnerableTxOrigin.sol
- Safe: contracts/tx-origin/SafeTxOrigin.sol
- Test: test/tx-origin/tx-origin.test.js

---

## How the exploit works

1. Victim is the owner of the vulnerable contract.
2. Attacker deploys a malicious helper contract.
3. Victim calls attacker contract.
4. Attacker contract calls withdrawAll() on vulnerable contract.
5. `tx.origin == owner` passes.
6. Funds are drained.

---

## Fix

Never use `tx.origin` for authorization.

Use:
- `msg.sender`
- Ownable
- Role-based access control

---

## Proof

Run:

```bash
npx hardhat test test/tx-origin/tx-origin.test.js
```

Expected:
- Vulnerable contract can be exploited
- Safe contract res

## Expected Wake findings
- `tx-origin` on `VulnerableTxOrigin` is expected (intentional).
- `SafeTxOrigin` should not use `tx.origin` for authorization.

## Expected Wake findings
- `tx-origin` on `VulnerableTxOrigin` is expected (intentional).
- `SafeTxOrigin` should not use `tx.origin` for authorization.
