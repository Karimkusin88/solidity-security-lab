# Solidity Security Lab

A hands-on playground for learning and demonstrating common smart contract vulnerabilities and their secure implementations.

Built using Hardhat.

---

## 🔐 Covered Vulnerabilities

### 1️⃣ Reentrancy
- VulnerableBankV2
- SafeBankV2
- ReentrancyAttackerV2
- Demonstrates state update after external call issue

### 2️⃣ Access Control
- VulnerableVault
- SafeVault (Ownable)
- Demonstrates ownership hijacking

### 3️⃣ tx.origin Authentication Flaw
- VulnerableTxOrigin
- SafeTxOrigin
- Demonstrates phishing-style contract exploitation

---

## 🧪 Run Locally

```bash
npm install
npx hardhat compile
npx hardhat test
