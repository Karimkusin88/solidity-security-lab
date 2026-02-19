![CI](../../actions/workflows/ci.yml/badge.svg)
![Wake](../../actions/workflows/wake.yml/badge.svg)

# 🛡️ Solidity Security Lab

Hands-on playground to learn, simulate, and fix real-world smart contract vulnerabilities.

Built with **Hardhat**, fully covered by automated tests, and structured to demonstrate both exploitation and mitigation patterns.

---

## 🎯 Purpose

This lab is designed to:

- Understand how vulnerabilities are exploited in real EVM environments
- Implement secure smart contract patterns
- Validate fixes through automated tests
- Learn how security tooling detects issues
- Build a practical security engineering portfolio

This is not just theory — each vulnerability includes:
- A vulnerable contract
- An exploit contract (when applicable)
- A secure implementation
- A passing test suite validating the fix

---

## ✅ Vulnerabilities Covered

### 1️⃣ Reentrancy (Drain Attack Simulation)

**Contracts:**
- `VulnerableBankV2`
- `ReentrancyAttackerV2`
- `SafeBankV2`

**Concept:**
- External call before state update
- Recursive withdrawal exploit
- Checks-Effects-Interactions pattern

**Fix:**
- State updated before external call
- Proper withdrawal ordering

---

### 2️⃣ Access Control Hijack

**Contracts:**
- `VulnerableVault`
- `SafeVault`

**Concept:**
- Missing access control
- Ownership takeover risk

**Fix:**
- `Ownable`
- Restricted privileged functions

---

### 3️⃣ tx.origin Authentication Flaw

**Contracts:**
- `VulnerableTxOrigin`
- `SafeTxOrigin`

**Concept:**
- Phishing-style contract attack
- `tx.origin` misuse

**Fix:**
- Replace `tx.origin` with `msg.sender`
- Strict caller validation

---

### 4️⃣ Front-Running (Commit-Reveal Pattern)

**Contracts:**
- `VulnerableGame`
- `SafeGame`

**Concept:**
- Public guess visibility
- Transaction ordering manipulation

**Fix:**
- Commit-reveal scheme
- Hash-based commitment

---

## 🧪 Testing Strategy

All vulnerabilities are validated through automated Hardhat tests:

- Exploit succeeds on vulnerable contract
- Exploit fails on secure implementation
- State integrity is verified
- Edge cases covered

## Security Tooling
- ✅ Unit tests (Hardhat)
- ✅ CI (GitHub Actions)
- ✅ Static analysis (Wake)
Artifacts: Wake output is uploaded on every run.

Run locally:

```bash
npm install
npx hardhat compile
npx hardhat test

🏗 Architecture Overview
contracts/
 ├── access-control/
 ├── reentrancy/
 ├── tx-origin/
 └── frontrunning/

test/
 ├── access-control.test.js
 ├── reentrancy.test.js
 ├── txorigin.test.js
 └── frontrunning.test.js

Each vulnerability follows a consistent structure:

Vulnerable implementation

Safe implementation

Exploit simulation

Test verification

🏆 Community Recognition

This project received engagement from the Wake Framework team,
a Solidity-focused security tooling framework.

The lab simulates patterns that automated security tools detect in real audits, including:

Reentrancy vulnerabilities

Privilege escalation

tx.origin misuse

Front-running risk

This demonstrates alignment with practical security tooling standards.

🧠 What This Demonstrates

Deep understanding of EVM execution flow

Exploit-driven learning approach

Secure contract architecture design

Testing discipline

Security engineering mindset

🚀 Why This Matters

Smart contract security is not optional.

Small architectural decisions can result in:

Fund drainage

Ownership hijack

Phishing attacks

Economic manipulation

Understanding both exploitation and mitigation is critical for:

DeFi development

Smart contract auditing

Protocol engineering

Security research

📜 License

MIT
