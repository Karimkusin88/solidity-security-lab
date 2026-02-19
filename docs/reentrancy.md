# Reentrancy Lab

## What is reentrancy?
Reentrancy happens when a contract makes an external call (e.g., sending ETH) before updating its internal state, allowing an attacker to re-enter the function and repeat the withdrawal.

## Where in this repo
- Vulnerable: contracts/reentrancy/VulnerableBank.sol
- Vulnerable V2: contracts/reentrancy/VulnerableBankV2.sol
- Safe versions: SafeBank / SafeBankV2
- Test: test/reentrancy/reentrancy.test.js

## How the exploit works
1. Attacker deposits ETH.
2. Attacker calls withdraw.
3. Contract sends ETH using `call`.
4. Fallback re-enters withdraw before balance is updated.
5. Funds get drained.

## Fix
Use Checks-Effects-Interactions:
- Check balance
- Update state
- Then interact (send ETH)

Optional: use ReentrancyGuard.

## Proof
Run:
```bash
npx hardhat test test/reentrancy/reentrancy.test.js

## Expected Wake findings
- `reentrancy` on `VulnerableBank*` is expected (intentional).
- `SafeBank*` should not trigger the reentrancy detector.

MD

## Expected Wake findings
- `reentrancy` on `VulnerableBank*` is expected (intentional).
- `SafeBank*` should not trigger the reentrancy detector.
