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
