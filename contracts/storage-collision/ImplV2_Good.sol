// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * GOOD upgrade: keeps storage layout and only appends new variables.
 */
contract ImplV2_Good {
    address public owner; // slot2 (same as V1)
    uint256 public value; // slot3 (same as V1)

    // appended at slot4
    uint256 public newField;

    function setNewField(uint256 x) external {
        require(msg.sender == owner, "not owner");
        newField = x;
    }

    function setValue(uint256 v) external {
        require(msg.sender == owner, "not owner");
        value = v;
    }
}
