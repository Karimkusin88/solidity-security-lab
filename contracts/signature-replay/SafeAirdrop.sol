// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

/**
 * Safer: includes contract + chainId + per-user nonce in signed message.
 * Nonce prevents replay.
 */
contract SafeAirdrop {
    using ECDSA for bytes32;

    address public signer;
    mapping(address => uint256) public nonces;
    mapping(address => uint256) public claimed;

    constructor(address signer_) {
        signer = signer_;
    }

    function claim(uint256 amount, uint256 nonce, bytes calldata sig) external {
        require(nonce == nonces[msg.sender], "bad nonce");

        bytes32 hash = keccak256(
            abi.encodePacked(
                address(this),
                block.chainid,
                msg.sender,
                amount,
                nonce
            )
        );

        bytes32 digest = MessageHashUtils.toEthSignedMessageHash(hash);

        address recovered = ECDSA.recover(digest, sig);
        require(recovered == signer, "bad sig");

        nonces[msg.sender] += 1;
        claimed[msg.sender] += amount;
    }
}
