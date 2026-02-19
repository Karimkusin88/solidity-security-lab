// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SimpleAMM.sol";

/**
 * Safer pattern (lab): uses a price snapshot updated by a keeper,
 * and requires the snapshot to be at least MIN_AGE seconds old.
 * This blocks same-tx manipulation -> update -> borrow.
 */
contract SafeLending {
    SimpleAMM public amm;

    mapping(address => uint256) public collateralX;
    mapping(address => uint256) public debtY;

    uint256 public constant LTV_BPS = 5000; // 50%
    uint256 public constant MIN_AGE = 60;   // 60s snapshot age requirement

    uint256 public lastPrice;     // 1e18
    uint256 public lastUpdatedAt; // timestamp

    constructor(address amm_) {
        amm = SimpleAMM(amm_);
        // initialize snapshot
        lastPrice = amm.spotPriceYperX();
        lastUpdatedAt = block.timestamp;
    }

    function updatePriceSnapshot() external {
        lastPrice = amm.spotPriceYperX();
        lastUpdatedAt = block.timestamp;
    }

    function depositCollateral(uint256 amountX) external {
        require(amountX > 0, "bad amount");
        collateralX[msg.sender] += amountX;
    }

    function maxBorrowY(address user) public view returns (uint256) {
        require(block.timestamp >= lastUpdatedAt + MIN_AGE, "snapshot too fresh");
        uint256 valueY = (collateralX[user] * lastPrice) / 1e18;
        return (valueY * LTV_BPS) / 10000;
    }

    function borrow(uint256 amountY) external {
        uint256 maxY = maxBorrowY(msg.sender);
        require(debtY[msg.sender] + amountY <= maxY, "exceeds limit");
        debtY[msg.sender] += amountY;
    }
}
