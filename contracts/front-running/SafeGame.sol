// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeGame {
    address public winner;

    mapping(address => bytes32) public commits;

    function commit(bytes32 hash) external {
        commits[msg.sender] = hash;
    }

    function reveal(uint256 number, string memory secret) external {
        require(winner == address(0), "already won");

        bytes32 hash = keccak256(abi.encodePacked(number, secret));
        require(commits[msg.sender] == hash, "invalid reveal");

        if (number == 42) {
            winner = msg.sender;
        }
    }
}
