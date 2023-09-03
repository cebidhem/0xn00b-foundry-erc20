// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    uint256 public constant STARTING_BALANCE = 100 ether;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function testTransfers() public {
        uint256 transferAmount = 50;

        // Bob transfers tokens to Carol.
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        // Assert balances.
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);

        // Attempting to transfer more than the balance should fail.
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        ourToken.transfer(bob, STARTING_BALANCE + 1);
    }

    function testDecimals() public {
        // Check the decimal places of the token.
        assertEq(ourToken.decimals(), 18); // Assuming 18 decimal places
    }

    function testSymbolAndName() public {
        // Check the symbol and name of the token.
        assertEq(ourToken.symbol(), "CEB");
        assertEq(ourToken.name(), "cebidhem");
    }

    function testTotalSupply() public {
        // Check the total supply of the token.
        assertEq(ourToken.totalSupply(), STARTING_BALANCE);
    }
}
