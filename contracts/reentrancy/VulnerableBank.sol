// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient");

        // ❌ Vulnerable: external call before state update
        (bool ok,) = msg.sender.call{value: amount}("");
        ok; // biar ga warning, dan kita sengaja ga revert

        balances[msg.sender] -= amount;
    }

    function bankBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
