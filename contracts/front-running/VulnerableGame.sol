// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableGame {
    address public winner;

    function guess(uint256 number) external {
        // suppose secret number is 42
        require(winner == address(0), "already won");

        if (number == 42) {
            winner = msg.sender;
        }
    }
}
