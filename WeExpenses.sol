pragma solidity ^0.4.10;

/// @title WeExpenses : sharing expenses with WeExpenses.
contract WeExpenses {
    // Participant is a person or an organization which can be part of 
    struct Participant {
        string name; // name of the participant or the organization
        address waddress; // address of the participant
        int balance; // balance of the participant (int type because balance can be negative)
    }

    // Expense which will be part of all the expenses
    struct Expense {
        string title; // title or designation of the expense
        uint amount; // amount of the expense (uint type because amount must not be negative)
        uint date; // date of the expense 
        address payBy; // The participant who pays the expense
        address[] payFor; // The list of participants who apply for the expense
    }

    // This declares a state variable that
    // stores a `Participant` struct for each possible address.
    mapping(address => Participant) public participants;

    // A dynamically-sized array of `Expenses` structs.
    Expense[] public expenses;

    /// Create a new WeExpenses contract with the creator as first participant
    function WeExpenses(string name) public {
        createParticipant(name, msg.sender);
    }

    // Create a new expense and add it in the expenses list
    function createExpense(string title, uint amount, uint date, address payBy, address[] payFor) public {
        Expense memory expense = Expense({title: title, amount: amount, date: date, payBy: payBy, payFor: payFor});
        expenses.push(expense);
        syncBalance(expense, payBy);
    }

    // Create a new participant in the participants mapping
    function createParticipant(string name, address waddress) public {
        Participant memory participant = Participant({name: name, waddress: waddress, balance: 0});
        participants[waddress] = participant;
    }

    // Synchronize the balance after each new expense
    function syncBalance(Expense expense, address sender) internal {
        uint portion = expense.amount / expense.payFor.length;
        participants[sender].balance += int(expense.amount);
        for (uint i = 0; i < expense.payFor.length; i++) {
                participants[sender].balance -= int(portion);
        }        
    }

}