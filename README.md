# Solidity Security Lab

Hands-on playground to learn and demonstrate common smart contract vulnerabilities + secure fixes.  
Built with **Hardhat** and fully covered by automated tests.

---

## ✅ Vulnerabilities Covered

### 1) Reentrancy (V2 stable)
- `VulnerableBankV2` → drain via reentrancy
- `SafeBankV2` → fixed with Checks-Effects-Interactions
- `ReentrancyAttackerV2` → exploit contract

### 2) Access Control Hijack
- `VulnerableVault` → attacker can take ownership
- `SafeVault` → fixed with `Ownable`

### 3) tx.origin Authentication Flaw
- `VulnerableTxOrigin` → phishing-style exploit
- `SafeTxOrigin` → fixed by using `msg.sender`

### 4) Front-Running (Commit-Reveal)
- `VulnerableGame` → guess exposed (copycat risk)
- `SafeGame` → commit-reveal protection

---

## 🧪 Run Locally

```bash
npm install
npx hardhat compile
npx hardhat test
## 🎯 Purpose

This lab is designed to:

- Understand how vulnerabilities are exploited
- Implement secure patterns
- Validate fixes through automated tests
- Learn how security tooling detects issues

---

## 🏆 Community Recognition

This Security Lab received engagement from the **Wake Framework** team —  
a Solidity-focused security tooling framework.

The lab was built to simulate and validate:

- Real-world reentrancy exploits
- Ownership hijacking patterns
- tx.origin phishing attacks
- Front-running vulnerabilities (commit-reveal protection)

Wake's interaction indicates that the vulnerability simulations
align with practical security tooling and detection standards.

This project aims to bridge the gap between:
- Learning exploits
- Writing secure smart contracts
- Understanding automated vulnerability detection

---

