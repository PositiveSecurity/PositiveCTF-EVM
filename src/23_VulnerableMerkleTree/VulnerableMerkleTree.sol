// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract VulnerableMerkleTree {
    bytes32 public root;

    mapping(bytes32 => bool) secrets;
    mapping(address => bool) public flags;

    event Verified(bytes32 nonce, bytes32 secret);

    constructor(bytes32 _root) {
        root = _root;
    }

    function verify(bytes32[] memory proof, bytes32 nonce, bytes32 secret) public {
        require(!secrets[secret], "Double spending");

        bytes32 leaf = makeHash(nonce, secret);
        require(MerkleProof.verify(proof, root, leaf), "Invalid proof");

        emit Verified(nonce, secret);

        secrets[secret] = true;

        flags[msg.sender] = true;
    }

    function makeHash(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}
