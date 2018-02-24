pragma solidity ^0.4.10;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/WeExpenses.sol";

contract TestWeExpenses {
    address constant SENDER_A = tx.origin;
    address constant SENDER_B = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
    address constant SENDER_C = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;

    address[] payFor = [SENDER_A, SENDER_B, SENDER_C];
    address[] payFor2 = [SENDER_A, SENDER_C];
    address[] payFor3 = [SENDER_A];


    string senderNameA = "Alice";

    WeExpenses weExpenses = new WeExpenses(senderNameA);

    function testBalanceFirstParticipant() public {
        checkBalanceFirstParticipant();
    }

    function testCreateParticipant() public {
        weExpenses.createParticipant("Bob", SENDER_B);
        weExpenses.createParticipant("Cris", SENDER_C);
        checkGetBalance(SENDER_B, 0);
        checkGetBalance(SENDER_C, 0);
    }

    function testCreateExpense() public {
        weExpenses.createExpense("Expense1", 90, 1519135382, SENDER_A, payFor);
        checkGetBalance(SENDER_A, 60);
        checkGetBalance(SENDER_B, -30);
        checkGetBalance(SENDER_C, -30);
    }

    function testCreateExpense2() public {
        weExpenses.createExpense("Expense2", 100, 1519135382, SENDER_B, payFor2);
        checkGetBalance(SENDER_A, 10);
        checkGetBalance(SENDER_B, 70);
        checkGetBalance(SENDER_C, -80);
    }

    function testCreateExpense3() public {
        weExpenses.createExpense("Expense2", 20, 1519135382, SENDER_C, payFor3);
        checkGetBalance(SENDER_A, -10);
        checkGetBalance(SENDER_B, 70);
        checkGetBalance(SENDER_C, -60);
    }
    
    function checkBalanceFirstParticipant() public {
        int expected = 0;
        Assert.equal(weExpenses.getBalance(tx.origin), expected, "First Participant should have 0 in his balance initially");    }

    function checkGetBalance(address waddress, int expectedBalance) public {
        Assert.equal(weExpenses.getBalance(waddress), expectedBalance, "Balance should be equal");
    }

}



