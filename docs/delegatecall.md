# Delegatecall / Proxy Takeover Lab

## What is the issue?
`delegatecall` executes code from another contract **in the storage context of the caller**.
If an attacker can control the delegatecall target (implementation), they can overwrite critical state (e.g., `owner`) and take over the contract.

## Where in this repo
- Vulnerable: `contracts/delegatecall/VulnerableProxy.sol`
- Safe: `contracts/delegatecall/SafeProxy.sol`
- Attacker: `contracts/delegatecall/ProxyAttacker.sol`
- Test: `test/delegatecall/delegatecall.test.js`

## Exploit (high level)
1. Attacker sets the proxy `implementation` to a malicious contract.
2. Attacker calls `pwn()` through the proxy.
3. Proxy `delegatecall`s into attacker code.
4. Attacker code writes to proxy storage slot(s) and overwrites `owner`.
5. Ownership is hijacked.

## Fix
- Restrict upgrades (onlyOwner / roles)
- Validate implementation is a contract (`code.length > 0`)
- Prefer audited proxy standards for production (EIP-1967 / UUPS)

## Proof
Run:
```bash
npx hardhat test test/delegatecall/delegatecall.test.js

