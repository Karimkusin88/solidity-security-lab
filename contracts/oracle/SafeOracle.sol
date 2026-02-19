// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Simplified safer oracle example.
 * Introduces delayed price update (mock TWAP-like).
 */
contract SafeOracle {
    uint256 public price;
    uint256 public lastUpdated;
    uint256 public constant DELAY = 60;

    function setPrice(uint256 newPrice) external {
        require(block.timestamp >= lastUpdated + DELAY, "update too soon");
        price = newPrice;
        lastUpdated = block.timestamp;
    }

    function buy() external view returns (uint256) {
        return price;
    }
}
