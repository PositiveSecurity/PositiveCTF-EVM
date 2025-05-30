// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";

import "src/22_RandaoLottery/RandaoLottery.sol";

// forge test --match-contract RandaoLotteryTest -vvvv
contract RandaoLotteryTest is BaseTest {
    RandaoLottery instance;

    function setUp() public override {
        super.setUp();
        vm.startPrank(owner);
        instance = new RandaoLottery(block.timestamp + 86400);
        vm.stopPrank();

        vm.roll(20687107);
        vm.deal(address(instance), 0.01 ether);
    }

    function testExploitLevel() public {
        /* YOUR EXPLOIT GOES HERE */

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(
            address(instance).balance == 0,
            "Solution is not solving the level"
        );
    }
}
