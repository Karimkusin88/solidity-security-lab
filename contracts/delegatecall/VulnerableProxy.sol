// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Intentionally vulnerable proxy-like contract.
 * Anyone can set the implementation, then calls are delegatecalled into it.
 * Attackers can take over storage (e.g., owner) via delegatecall.
 */
contract VulnerableProxy {
    address public implementation; // slot 0
    address public owner;          // slot 1

    constructor() {
        owner = msg.sender;
    }

    // ❌ Vulnerable: anyone can change implementation
    function setImplementation(address impl) external {
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
