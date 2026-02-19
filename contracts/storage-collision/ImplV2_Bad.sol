// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * BAD upgrade: inserts a new variable before existing ones.
 * This shifts storage slots and corrupts state.
 */
contract ImplV2_Bad {
    uint256 public newField; // <-- inserted at slot2, overwrites old owner!
    address public owner;    // now at slot3, overwrites old value!
    uint256 public value;    // now at slot4

    function setNewField(uint256 x) external {
        newField = x;
    }

    function setValue(uint256 v) external {
        require(msg.sender == owner, "not owner");
        value = v;
    }
}
