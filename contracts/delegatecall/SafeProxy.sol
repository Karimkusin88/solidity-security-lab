// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Safer version: only owner can set implementation.
 * Minimal example (not a full proxy standard).
 */
contract SafeProxy {
    address public implementation; // slot 0
    address public owner;          // slot 1

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    // ✅ Only owner can change implementation
    function setImplementation(address impl) external onlyOwner {
        require(impl.code.length > 0, "impl not contract");
        implementation = impl;
    }

    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "no impl");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
