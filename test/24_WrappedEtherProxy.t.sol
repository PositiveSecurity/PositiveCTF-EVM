// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";

import "src/24_WrappedEtherProxy/WETH9.sol";
import "src/24_WrappedEtherProxy/WrappedEtherProxy.sol";

// forge test --match-contract WrappedEtherProxyTest -vvvv
contract WrappedEtherProxyTest is BaseTest {
    WrappedEtherProxy instance;
    WETH9 wethProxy;

    function setUp() public override {
        super.setUp();
        vm.deal(address(this), 1 ether);
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);

        WETH9 wethImplementation = new WETH9();

        instance = new WrappedEtherProxy(address(wethImplementation), 10 ether);

        wethProxy = WETH9(payable(address(instance)));

        wethProxy.deposit{value: 0.01 ether}();

        instance.setEmergencySecret(
            uint256(
                keccak256(
                    abi.encodePacked(
                        address(wethImplementation),
                        block.timestamp,
                        owner
                    )
                )
            )
        );

        vm.stopPrank();
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
