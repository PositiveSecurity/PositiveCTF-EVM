// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";

import {MultiSigWallet} from "src/21_MultiSigWallet/MultiSigWallet.sol";
import {Token} from "src/21_MultiSigWallet/Token.sol";

// forge test --match-contract MultiSigWalletTest -vvvv
contract MultiSigWalletTest is BaseTest {
    MultiSigWallet instance;
    Token token;

    function setUp() public override {
        super.setUp();
        vm.startPrank(owner);

        address[] memory owners = new address[](5);

        owners[0] = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;
        owners[1] = 0xBadDcAfebADDCafEBaDDCaFeBaDDCaFebADdCafE;
        owners[2] = player;
        owners[3] = 0xC0fFEebaBEC0ffEEbABEC0fFeEbABec0ffeEbABe;
        owners[4] = 0xfEe1deADfEe1DEaDfEE1DEADFEe1deADfee1dEAD;

        instance = new MultiSigWallet(owners, 3);
        token = new Token(address(instance));

        vm.stopPrank();
    }

    function testExploitLevel() public {
        /* YOUR EXPLOIT GOES HERE */

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(
            token.balanceOf(address(instance)) == 0,
            "Solution is not solving the level"
        );
    }
}
