// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Extremely simplified AMM (x*y=k) for lab purposes.
 * Price = y/x (spot). Attackers can manipulate by swapping.
 */
contract SimpleAMM {
    uint256 public reserveX; // tokenX reserve
    uint256 public reserveY; // tokenY reserve

    constructor(uint256 x, uint256 y) {
        require(x > 0 && y > 0, "bad reserves");
        reserveX = x;
        reserveY = y;
    }

    function spotPriceYperX() public view returns (uint256) {
        // scaled by 1e18 for precision: price = reserveY / reserveX
        return (reserveY * 1e18) / reserveX;
    }

    // Swap X in, get Y out (no fees, simplified)
    function swapXforY(uint256 amountXIn) external returns (uint256 amountYOut) {
        require(amountXIn > 0, "bad in");
        // constant product
        uint256 k = reserveX * reserveY;

        uint256 newReserveX = reserveX + amountXIn;
        uint256 newReserveY = k / newReserveX;

        require(newReserveY < reserveY, "no out");
        amountYOut = reserveY - newReserveY;

        reserveX = newReserveX;
        reserveY = newReserveY;
    }

    // Swap Y in, get X out
    function swapYforX(uint256 amountYIn) external returns (uint256 amountXOut) {
        require(amountYIn > 0, "bad in");
        uint256 k = reserveX * reserveY;

        uint256 newReserveY = reserveY + amountYIn;
        uint256 newReserveX = k / newReserveY;

        require(newReserveX < reserveX, "no out");
        amountXOut = reserveX - newReserveX;

        reserveX = newReserveX;
        reserveY = newReserveY;
    }
}
