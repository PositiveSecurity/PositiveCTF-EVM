// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";

contract BaseTest is Test {
    address player;
    uint256 playerKey;
    address owner;
    uint256 ownerKey;

    function setUp() public virtual {
        (player, playerKey) = makeAddrAndKey("player");
        (owner, ownerKey) = makeAddrAndKey("owner");
    }

    function checkSuccess() internal virtual {}

    receive() external payable virtual {}
}

// Additional contracts
contract Tree {
    uint256 randomId;
    bytes32[] public hashes;
    uint8 constant COUNTLEAFS = 4;

    bytes32[] secrets;
    bytes32[] nonces;

    function setRandomRoot(address user) public returns (bytes32) {
        for (uint256 i = 0; i < COUNTLEAFS; i++) {
            secrets.push(getRandomValue(user));
            nonces.push(getRandomValue(user));
            hashes.push(makeHash(secrets[i], nonces[i]));
        }

        uint256 count = COUNTLEAFS;
        uint256 offset = 0;

        while (count > 0) {
            for (uint256 i = 0; i < count - 1; i += 2) {
                hashes.push(
                    makeHash(hashes[offset + i], hashes[offset + i + 1])
                );
            }
            offset += count;
            count = count / 2;
        }

        return hashes[6];
    }

    function getRandomValue(address user) internal returns (bytes32 rand) {
        rand = keccak256(abi.encodePacked(block.timestamp, user, randomId++));
    }

    function makeHash(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
    }

    function _efficientHash(
        bytes32 a,
        bytes32 b
    ) private pure returns (bytes32 value) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }

    function getHashes() public view returns (bytes32[] memory) {
        return hashes;
    }
}
