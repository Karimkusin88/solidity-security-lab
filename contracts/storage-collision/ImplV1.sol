// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * V1 layout:
 * slot0: implementation (proxy)
 * slot1: admin (proxy)
 * slot2: owner (V1)
 * slot3: value (V1)
 */
contract ImplV1 {
    address public owner; // slot2 (in proxy storage)
    uint256 public value; // slot3

    function initialize(address _owner) external {
        require(owner == address(0), "already init");
        owner = _owner;
    }

    function setValue(uint256 v) external {
        require(msg.sender == owner, "not owner");
        value = v;
    }
}
