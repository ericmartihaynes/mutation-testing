// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract BankTest is Test {
    Bank bank;
    address user;

    function setUp() public {
        bank = new Bank();
        user = msg.sender;
        vm.deal(user, 100 ether);
    }

    function testDeposit() public {
        assertEq(bank.getBalance(user), 0);
        vm.prank(user);
        bank.deposit{value: 50 ether}();
        assertEq(bank.getBalance(user), 50 ether);
    }

    function testWithdraw() public {
        uint256 startingBalance = 75 ether;
        vm.startPrank(user);
        bank.deposit{value: startingBalance}();
        assertEq(bank.getBalance(user), startingBalance);
        bank.withdraw(50 ether);
        assert(bank.getBalance(user) != startingBalance); //hmm
        vm.stopPrank();
    }

    function testWithdrawFail() public {
        vm.startPrank(user);
        bank.deposit{value: 10 ether}();
        assertEq(bank.getBalance(user), 10 ether);
        vm.expectRevert("Insufficient balance");
        bank.withdraw(15 ether);
        vm.stopPrank();
    }
}
