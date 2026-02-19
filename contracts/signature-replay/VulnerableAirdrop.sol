// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

/**
 * Vulnerable: signature authorizes claim but is replayable (no nonce).
 */
contract VulnerableAirdrop {
    using ECDSA for bytes32;

    address public signer;
    mapping(address => uint256) public claimed;

    constructor(address signer_) {
        signer = signer_;
    }

    function claim(uint256 amount, bytes calldata sig) external {
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, amount));
        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(hash);

        address recovered = ECDSA.recover(digest, sig);
        require(recovered == signer, "bad sig");

        claimed[msg.sender] += amount;
    }
}
