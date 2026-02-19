![CI](https://github.com/Karimkusin88/solidity-security-lab/actions/workflows/ci.yml/badge.svg)
![Wake](https://github.com/Karimkusin88/solidity-security-lab/actions/workflows/wake.yml/badge.svg)

# 🛡️ Solidity Security Lab

Hands-on playground to simulate, exploit, and fix real-world smart contract vulnerabilities.

Built with **Hardhat**, validated with automated tests, and analyzed using **Wake static analysis**.

---

## 🎯 Purpose

This repository demonstrates practical smart contract security engineering by:

- Reproducing real exploit patterns
- Implementing secure mitigations
- Validating fixes with automated tests
- Running static analysis in CI
- Structuring vulnerabilities in a consistent lab format

Each module includes:
- Vulnerable implementation
- Secure implementation
- Exploit simulation
- Automated test verification

---

## 📚 Lab Guides

- [Reentrancy](docs/reentrancy.md)
- [tx.origin](docs/tx-origin.md)
- [Access Control](docs/access-control.md)
- [Front-Running](docs/front-running.md)
- Delegatecall Takeover (advanced)
- `[Delegatecall Takeover](docs/delegatecall.md)`

---

## 📦 Modules

| Module | Key Concept | Guide |
|---|---|---|
| Reentrancy | Checks-Effects-Interactions | docs/reentrancy.md |
| tx.origin | Phishing-style auth flaw | docs/tx-origin.md |
| Access Control | Ownership hijack patterns | docs/access-control.md |
| Front-Running | Commit-reveal anti-MEV | docs/front-running.md |
| Delegatecall | Proxy storage takeover | docs/delegatecall.md |

---

## 🧪 Testing

All modules are validated via Hardhat tests:

```bash
npm install
npx hardhat test

🏗 Project Structure
contracts/
 ├── access-control/
 ├── reentrancy/
 ├── tx-origin/
 ├── front-running/
 └── delegatecall/

test/
 ├── access-control/
 ├── reentrancy/
 ├── tx-origin/
 ├── front-running/
 └── delegatecall/

📜 License

MIT