// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Safe: pull over push.
 */
contract SafeDistributor {
    mapping(address => uint256) public balances;

    constructor(address[] memory recipients) payable {
        uint256 share = msg.value / recipients.length;
        for (uint256 i = 0; i < recipients.length; i++) {
            balances[recipients[i]] += share;
        }
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "no balance");

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
