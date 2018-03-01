pragma solidity ^0.4.10;

/// @title WeExpenses : sharing expenses with WeExpenses.
contract WeExpenses {
    // Participant is a person or an organization which can be part of 
    struct Participant {
        string name; // name of the participant or the organization
        address waddress; // address of the participant
        int balance; // balance of the participant (int type because balance can be negative)
        uint index; // index of the participant in the address list
    }

    // Expense which will be part of all the expenses
    struct Expense {
        string title; // title or designation of the expense
        uint amount; // amount of the expense (uint type because amount must not be negative)
        uint date; // date of the expense 
        address payBy; // The participant who pays the expense
        address[] payFor; // The list of participants who apply for the expense
    }

    // Refund which will be part of all the refunds
    struct Refund {
        string title; // title or designation of the refund
        uint amount; // amount of the refund (uint type because amount must not be negative)
        uint date; // date of the refund
        address refundBy; // The participant who refunds
        address refundFor; // The refunded participant
    }

    // This declares a state variable that
    // stores a `Participant` struct for each possible address.
    mapping(address => Participant) public participants;

    address[] public addressList;
    

    // A dynamically-sized array of `Expenses` structs.
    Expense[] public expenses;

    // A dynamically-sized array of `Refunds` structs.
    Refund[] public refunds;    

    /// Create a new WeExpenses
    function WeExpenses() public {}

    // Create a new expense and add it in the expenses list
    function createExpense(string title, uint amount, uint date, address payBy, address[] payFor) external {
        Expense memory expense = Expense(title, amount, date, payBy, payFor);
        expenses.push(expense);
        syncBalanceExp(expense);
    }

    // Create a new participant in the participants mapping
    function createParticipant(string name, address waddress) public {
        Participant memory participant = Participant({name: name, waddress: waddress, balance: 0, index: 0});
        participant.index = addressList.push(waddress)-1; //add the address to the addressList
        participants[waddress] = participant;
    }

    // Create a new refund and add it in the refunds list
    function createRefund(string title, uint amount, uint date, address refundBy, address refundFor) external {
        Refund memory refund = Refund({title: title, amount: amount, date: date, refundBy: refundBy, refundFor: refundFor});
        refunds.push(refund);
        syncBalanceRef(refundFor, amount);
    }

    // Synchronize the balance after each new expense
    function syncBalanceExp(Expense expense) internal {
        uint portion = expense.amount / expense.payFor.length;
        participants[expense.payBy].balance += int(expense.amount);
        for (uint i = 0; i < expense.payFor.length; i++) {
                participants[expense.payFor[i]].balance -= int(portion);
        }       
    }

    // Return maximum balance and the index of the list of participants
    function getMaxBalance() public view returns (int, uint) {
        int max = participants[addressList[0]].balance;
        uint index = 0;
        for (uint i = 1; i < addressList.length; i++) {
            if (max != max256(max, participants[addressList[i]].balance)) {
                max = participants[addressList[i]].balance;
                index = i;
            }
        }
        return (max,index);
    }

    // Get Balance of a participant
    function getBalance(address waddress) public view returns (int) {
        return participants[waddress].balance;
    }

    // Get Participant
    function getParticipant(address waddress) public view returns (Participant) {
        return participants[waddress];
    }

    // Get Expense
    function getExpense(uint i) public view returns (Expense) {
        return expenses[i];
    }
  
    // Synchronize the balance after each new refund
    function syncBalanceRef(address to, uint amount) internal {
        participants[to].balance -= int(amount);
        participants[msg.sender].balance += int(amount);
    }

    // Get the list of PayFor of an expense
    function getExpensePayFor(uint i) public view returns (address[]) {
      return expenses[i].payFor;
    }

    function max256(int256 a, int256 b) internal pure returns (int256) {
        return a >= b ? a : b;
    }

    function min256(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }    
}
    
