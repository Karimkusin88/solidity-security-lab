// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SimpleAMM.sol";

/**
 * Vulnerable: uses AMM spot price as oracle in the same transaction.
 * Borrow limit depends on spot price which can be manipulated.
 */
contract VulnerableLending {
    SimpleAMM public amm;

    // Collateral is in X, borrow is in Y (virtual accounting)
    mapping(address => uint256) public collateralX;
    mapping(address => uint256) public debtY;

    uint256 public constant LTV_BPS = 5000; // 50% LTV

    constructor(address amm_) {
        amm = SimpleAMM(amm_);
    }

    function depositCollateral(uint256 amountX) external {
        require(amountX > 0, "bad amount");
        collateralX[msg.sender] += amountX;
    }

    function maxBorrowY(address user) public view returns (uint256) {
        // collateral value in Y = collateralX * price(Y/X)
        uint256 price = amm.spotPriceYperX(); // 1e18
        uint256 valueY = (collateralX[user] * price) / 1e18;
        return (valueY * LTV_BPS) / 10000;
    }

    function borrow(uint256 amountY) external {
        uint256 maxY = maxBorrowY(msg.sender);
        require(debtY[msg.sender] + amountY <= maxY, "exceeds limit");
        debtY[msg.sender] += amountY; // virtual mint/borrow
    }
}
