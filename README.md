![CI](https://github.com/Karimkusin88/solidity-security-lab/actions/workflows/ci.yml/badge.svg)
![Wake](https://github.com/Karimkusin88/solidity-security-lab/actions/workflows/wake.yml/badge.svg)
![Slither](https://github.com/Karimkusin88/solidity-security-lab/actions/workflows/slither.yml/badge.svg)

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
- [Delegatecall Takeover](docs/delegatecall.md)
- [Oracle Manipulation](docs/oracle-manipulation.md)
- [Signature Replay](docs/signature-replay.md)
- [ERC20 Approve Race](docs/erc20-approve-race.md)

---

## 📦 Modules

| Module | Key Concept | Guide |
|---|---|---|
| Reentrancy | Checks-Effects-Interactions | docs/reentrancy.md |
| tx.origin | Phishing-style auth flaw | docs/tx-origin.md |
| Access Control | Ownership hijack patterns | docs/access-control.md |
| Front-Running | Commit-reveal anti-MEV | docs/front-running.md |
| Delegatecall | Proxy storage takeover | docs/delegatecall.md |
| Oracle | Spot price manipulation | docs/oracle.md |
| Oracle Manipulation | Spot price attack | docs/oracle-manipulation.md | npx hardhat test test/oracle-manipulation/oracle-manipulation.test.js|
| Signature Replay | ECDSA replay risk | docs/signature-replay.md | `npx hardhat test test/signature-replay/signature-replay.test.js` |
| ERC20 Approve Race | Allowance front-run risk | docs/erc20-approve-race.md | `npx hardhat test test/erc20-pitfalls/approve-race.test.js`|

---


```md
## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)

## Security
See [SECURITY.md](SECURITY.md)

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
## Tooling Matrix

| Tool | Purpose | Runs in CI | Output |
|---|---|---:|---|
| Hardhat tests | Prove exploits + verify fixes | ✅ | GitHub Actions logs |
| Wake | Static analysis (Solidity-focused detectors) | ✅ | Artifact: `wake-output` |
| Slither | Static analysis (broad analyzer) | ✅ | Artifact: `slither-output` |

Notes:
- Static analysis findings are expected on intentionally vulnerable contracts.
- CI is configured to keep runs green while still publishing analysis output as artifacts.


## Roadmap
See [ROADMAP.md](ROADMAP.md)
EOF
fi
