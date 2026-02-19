// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MockERC20.sol";

/**
 * Lab target: user changes allowance X->Y using approve(Y).
 * Spender can front-run to spend X, then later spend Y (double-spend).
 */
contract VulnerableSpender {
    MockERC20 public token;

    constructor(address token_) {
        token = MockERC20(token_);
    }

    function spend(address from, uint256 amount) external {
        // spender pulls tokens using allowance
        require(token.transferFrom(from, address(this), amount), "tf");
    }
}
