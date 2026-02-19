// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Simplified vulnerable oracle example.
 * Uses spot price directly without delay or averaging.
 */
contract VulnerableOracle {
    uint256 public price; // spot price

    function setPrice(uint256 newPrice) external {
        price = newPrice;
    }

    function buy() external view returns (uint256) {
        // Price used instantly
        return price;
    }
}
