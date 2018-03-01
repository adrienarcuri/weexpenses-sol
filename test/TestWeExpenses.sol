pragma solidity ^0.4.10;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/WeExpenses.sol";

contract TestWeExpenses {
    address constant SENDER_A = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    address constant SENDER_B = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
    address constant SENDER_C = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
    address constant SENDER_D = 0x583031D1113aD414F02576BD6afaBfb302140225;

    address[] payFor1 = [SENDER_A, SENDER_B, SENDER_C, SENDER_D];
    address[] payFor2 = [SENDER_A, SENDER_B];
    address[] payFor3 = [SENDER_A, SENDER_B, SENDER_D];

    WeExpenses weExpenses = new WeExpenses();

    function testCreateParticipant() public {
        weExpenses.createParticipant("Alice", SENDER_A);
        weExpenses.createParticipant("Bob", SENDER_B);
        weExpenses.createParticipant("Cris", SENDER_C);
        weExpenses.createParticipant("Dede", SENDER_D);
        checkGetBalance(SENDER_A, 0);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 0);
        checkGetBalance(SENDER_D, 0);
    }

    function testCreateExpense() public {
        weExpenses.createExpense("Expense1", 100, 1519135382, SENDER_A, payFor1);
        checkGetBalance(SENDER_A, 75);
        checkGetBalance(SENDER_B, -25);
        checkGetBalance(SENDER_C, -25);
        checkGetBalance(SENDER_D, -25);
    }

    function testCreateExpense2() public {
        weExpenses.createExpense("Expense2", 50, 1519135382, SENDER_B, payFor2);
        checkGetBalance(SENDER_A, 50);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, -25);
        checkGetBalance(SENDER_D, -25);
    }

    function testCreateExpense3() public {
        weExpenses.createExpense("Expense3", 300, 1519135382, SENDER_C, payFor3);
        checkGetBalance(SENDER_A, -50);
        checkGetBalance(SENDER_B, -100);
        checkGetBalance(SENDER_C, 275);
        checkGetBalance(SENDER_D, -125);
    }
    
    function checkGetBalance(address waddress, int expectedBalance) public {
        Assert.equal(weExpenses.getBalance(waddress), expectedBalance, "Balance should be equal");
    }

}



