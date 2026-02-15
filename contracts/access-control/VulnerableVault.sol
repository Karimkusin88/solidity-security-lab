// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableVault {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // ❌ BUG: anyone can change owner
    function setOwner(address newOwner) external {
        owner = newOwner;
    }

    function withdrawAll() external {
        require(msg.sender == owner, "not owner");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
