// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeTxOrigin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function withdrawAll() external {
        require(msg.sender == owner, "not owner");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
