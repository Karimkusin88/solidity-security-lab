// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MockERC20.sol";

/**
 * Shows safer allowance update pattern: set to 0 before setting new value.
 */
contract SafeAllowanceHelper {
    function safeApprove(MockERC20 token, address spender, uint256 newAmount) external {
        // Owner = msg.sender
        // Reset to 0 first (mitigates approve race)
        require(token.approve(spender, 0), "reset fail");
        require(token.approve(spender, newAmount), "set fail");
    }
}
