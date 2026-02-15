// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableTxOrigin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // ❌ WRONG: using tx.origin
    function withdrawAll() external {
        require(tx.origin == owner, "not owner");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
