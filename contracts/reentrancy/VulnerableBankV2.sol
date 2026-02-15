// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBankV2 {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawAll() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "no balance");

        // ❌ Vulnerable: interaction first
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "send failed");

        // effects later
        balances[msg.sender] = 0;
    }

    function bankBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
