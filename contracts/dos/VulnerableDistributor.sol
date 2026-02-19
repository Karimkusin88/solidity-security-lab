// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Vulnerable: if one receiver reverts, whole distribution fails.
 */
contract VulnerableDistributor {
    address[] public recipients;

    constructor(address[] memory _recipients) payable {
        recipients = _recipients;
    }

    function distribute() external {
        uint256 share = address(this).balance / recipients.length;

        for (uint256 i = 0; i < recipients.length; i++) {
            payable(recipients[i]).transfer(share);
        }
    }
}
