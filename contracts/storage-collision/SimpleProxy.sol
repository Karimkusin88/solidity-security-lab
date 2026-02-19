// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Minimal EIP-1967-style proxy for lab.
 * Stores implementation/admin in dedicated slots to avoid storage collision
 * with implementation variables.
 */
contract SimpleProxy {
    // keccak256("eip1967.proxy.implementation") - 1
    bytes32 private constant IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // keccak256("eip1967.proxy.admin") - 1
    bytes32 private constant ADMIN_SLOT =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    constructor(address impl) {
        _setAdmin(msg.sender);
        _setImplementation(impl);
    }

    function admin() public view returns (address a) {
        bytes32 slot = ADMIN_SLOT;
        assembly { a := sload(slot) }
    }

    function implementation() public view returns (address i) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly { i := sload(slot) }
    }

    function upgradeTo(address newImpl) external {
        require(msg.sender == admin(), "not admin");
        _setImplementation(newImpl);
    }

    function _setAdmin(address a) internal {
        bytes32 slot = ADMIN_SLOT;
        assembly { sstore(slot, a) }
    }

    function _setImplementation(address i) internal {
        require(i.code.length > 0, "impl not contract");
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly { sstore(slot, i) }
    }

    fallback() external payable {
        address impl = implementation();
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
