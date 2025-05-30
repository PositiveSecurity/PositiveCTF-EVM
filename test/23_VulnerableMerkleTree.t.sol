// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {BaseTest, Tree} from "./BaseTest.t.sol";

import "src/23_VulnerableMerkleTree/VulnerableMerkleTree.sol";

// forge test --match-contract VulnerableMerkleTreeTest -vvvv
contract VulnerableMerkleTreeTest is BaseTest, Tree {
    VulnerableMerkleTree instance;

    function setUp() public override {
        super.setUp();
        vm.startPrank(owner);

        instance = new VulnerableMerkleTree(setRandomRoot(player));
        setVerify();

        vm.stopPrank();
    }

    function testExploitLevel() public {
        /* YOUR EXPLOIT GOES HERE */

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.flags(player), "Solution is not solving the level");
    }

    function setVerify() internal {
        bytes32[] memory proof1;
        bytes32[] memory proof2;
        bytes32[] memory proof3;
        bytes32[] memory proof4;

        proof1 = new bytes32[](2);
        proof1[0] = hashes[1];
        proof1[1] = hashes[5];

        proof2 = new bytes32[](2);
        proof2[0] = hashes[0];
        proof2[1] = hashes[5];

        proof3 = new bytes32[](2);
        proof3[0] = hashes[3];
        proof3[1] = hashes[4];

        proof4 = new bytes32[](2);
        proof4[0] = hashes[2];
        proof4[1] = hashes[4];

        instance.verify(proof1, nonces[0], secrets[0]);
        instance.verify(proof2, nonces[1], secrets[1]);
        instance.verify(proof3, nonces[2], secrets[2]);
        instance.verify(proof4, nonces[3], secrets[3]);
    }
}
