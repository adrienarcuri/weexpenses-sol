pragma solidity ^0.4.0;

/// @title WeExpenses : sharing expenses with WeExpenses.
contract WeExpenses {
    // Participant is a person or an organization which can be part of 
    struct Participant {
        string name; // name of the participant or the organization
        address waddress; // address of the participant
        uint balance; // balance of the participant
    }

    // Expense which will be part of all the expenses
    struct Expense {
        string title; // title or designation of the expense
        uint amount; // amount of the expense
        uint date; // date of the expense
        Participant payBy; // The participant who pays the expense
        Participant[] payFor; // The list of participants who apply for the expense
    }

    // This declares a state variable that
    // stores a `Participant` struct for each possible address.
    mapping(address => Participant) public participants;

    // A dynamically-sized array of `Expenses` structs.
    Expense[] public expenses;

    // CreateExpense add a new expense in the expenses list
    function createExpense(Expense expense) internal {
        expenses.push(expense);
    }

    // Synchronize the balance after each new expense
    function syncBalance(Expense expense, address sender) internal {
        uint portion = expense.amount / expense.payFor.length;
        participants[sender].balance += expense.amount;
        for (uint i = 0; i < expense.payFor.length; i++) {
                participants[sender].balance -= portion;
        }        
    }

}