# Access Control Lab

## What is the issue?
Access control bugs happen when privileged actions can be executed by unauthorized users due to:
- missing checks (no `onlyOwner`)
- incorrect modifiers / role logic
- unsafe ownership change patterns
- bad initialization of admin/owner

These issues often lead to full takeover (ownership hijack) or fund loss.

---

## Where in this repo
- Contracts: `contracts/access-control/*`
- Tests: `test/access-control/access-control.test.js`

---

## How the exploit works (high level)
Common takeover flow:
1. Contract exposes a privileged function (e.g., setOwner / transferOwnership / withdraw).
2. The function lacks proper access control.
3. Attacker calls it and becomes owner/admin (or triggers privileged action directly).
4. Attacker drains funds or changes configuration permanently.

---

## Fix
Use proven patterns:
- OpenZeppelin `Ownable`
- OpenZeppelin `AccessControl` (roles)

Checklist:
- Owner/admin set only once (constructor or initializer)
- All admin functions protected (`onlyOwner` / `onlyRole`)
- Emit events on ownership/role changes
- Avoid custom auth unless necessary

---

## Proof
Run:
```bash
npx hardhat test test/access-control/access-control.test.js

