pragma solidity ^0.4.10;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/WeExpenses.sol";

contract TestWeExpenses {
    //address constant SENDER_0 = tx.origin;
    address constant SENDER_A = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    address constant SENDER_B = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
    address constant SENDER_C = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
    address constant SENDER_D = 0x583031D1113aD414F02576BD6afaBfb302140225;

    address[] payForABCD = [SENDER_A, SENDER_B, SENDER_C, SENDER_D];
    address[] payForAB = [SENDER_A, SENDER_B];
    address[] payForABD = [SENDER_A, SENDER_B, SENDER_D];

    WeExpenses weExpenses = new WeExpenses("God");

    function testCreateParticipants() public {
        weExpenses.createParticipant("Alice", SENDER_A);
        weExpenses.createParticipant("Bob", SENDER_B);
        weExpenses.createParticipant("Cris", SENDER_C);
        weExpenses.createParticipant("Dede", SENDER_D);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 0);
        checkGetBalance(SENDER_D, 0);
        checkGetMaxBalance(0, 0);
    }

    function testCreateExpense1() public {
        weExpenses.createExpense("Expense1", 10000, 1519135382, SENDER_A, payForABCD);
        checkGetBalance(SENDER_A, 7500);
        checkGetBalance(SENDER_B, -2500);
        checkGetBalance(SENDER_C, -2500);
        checkGetBalance(SENDER_D, -2500);
        checkGetMaxBalance(7500, 0);
        weExpenses.giveAgreement(0);
        checkGetAgreement(0, msg.sender, true);
    }

    function testCreateExpense2() public {
        weExpenses.createExpense("Expense2", 5000, 1519135382, SENDER_B, payForAB);
        checkGetBalance(SENDER_A, 5000);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, -2500);
        checkGetBalance(SENDER_D, -2500);
        checkGetMaxBalance(5000, 0);
    }

    function testCreateExpense3() public {
        weExpenses.createExpense("Expense3", 30000, 1519135382, SENDER_C, payForABD);
        checkGetBalance(SENDER_A, -5000);
        checkGetBalance(SENDER_B, -10000);
        checkGetBalance(SENDER_C, 27500);
        checkGetBalance(SENDER_D, -12500);
        checkGetMaxBalance(27500, 2);
    }

    function testCreateRefund1() public {
        weExpenses.createRefund("Refund1", 5000, 1519135382, SENDER_A, SENDER_C);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, -10000);
        checkGetBalance(SENDER_C, 22500);
        checkGetBalance(SENDER_D, -12500);
        checkGetMaxBalance(22500, 2);
    }

    function testCreateRefund2() public {
        weExpenses.createRefund("Refund2", 10000, 1519135382, SENDER_B, SENDER_C);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 12500);
        checkGetBalance(SENDER_D, -12500);
        checkGetMaxBalance(12500, 2);
    }

    function testCreateRefund3() public {
        weExpenses.createRefund("Refund3", 12500, 1519135382, SENDER_D, SENDER_C);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 0);
        checkGetBalance(SENDER_D, 0);
        checkGetMaxBalance(0, 0);
    }

    function testCreateExpense4() public {
        weExpenses.createExpense("Expense4", 10000, 1519135382, SENDER_C, payForABD);
        checkGetBalance(SENDER_A, -3333);
        checkGetBalance(SENDER_B, -3333);
        checkGetBalance(SENDER_C, 10000);
        checkGetBalance(SENDER_D, -3333);
        checkGetMaxBalance(10000, 2);
    }

    function testCreateRefund4() public {
        weExpenses.createRefund("Refund4", 3333, 1519135382, SENDER_A, SENDER_C);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, -3333);
        checkGetBalance(SENDER_C, 6667);
        checkGetBalance(SENDER_D, -3333);
        checkGetMaxBalance(6667, 2);
    }

    function testCreateRefund5() public {
        weExpenses.createRefund("Refund5", 3333, 1519135382, SENDER_B, SENDER_C);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 3334);
        checkGetBalance(SENDER_D, -3333);
        checkGetMaxBalance(3334, 2);
    }

    function testCreateRefund6() public {
        weExpenses.createRefund("Refund6", 3333, 1519135382, SENDER_D, SENDER_C);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 1);
        checkGetBalance(SENDER_D, 0);
        checkGetMaxBalance(1, 2);
    }
    
    function checkGetBalance(address waddress, int expectedBalance) public {
        Assert.equal(weExpenses.getBalance(waddress), expectedBalance, "Balance should be equal");
    }

    function checkGetMaxBalance(int expectedMax, uint expectedIndex) public {
        var (max, index) = weExpenses.getMaxBalance();
        Assert.equal(max, expectedMax, "MaxBalance should be equal");
        Assert.equal(index, expectedIndex, "Index should be equal");
    }

    function checkGetAgreement(uint indexExpense, address waddress, bool expectedAgreement) public {
        Assert.equal(weExpenses.getAgreement(indexExpense, waddress), expectedAgreement, "Agreement should be equal");
    }

}


