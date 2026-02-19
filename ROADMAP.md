# Roadmap

This repository is an educational Solidity security lab focused on exploit-driven learning.

## v1.0 (current)
- Core modules: Reentrancy, tx.origin, Access Control, Front-Running
- Automated Hardhat tests
- CI pipeline (tests + static analysis)
- Docs per module

## Next modules (planned)
- Delegatecall / proxy takeover (advanced)
- Signature replay / ECDSA misuse
- Oracle manipulation (spot vs TWAP)
- Upgradeable storage collision patterns
- Denial-of-service (griefing / gas)
- ERC20 pitfalls (approve race, fee-on-transfer, non-standard returns)

## Quality improvements
- Add per-module “Expected tool findings” baselines
- Add screenshots / proof artifacts to docs
- Improve formatting + readability
- Add Foundry equivalent tests (optional)
