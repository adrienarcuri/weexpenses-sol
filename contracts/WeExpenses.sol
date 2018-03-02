pragma solidity ^0.4.10;

/// @title WeExpenses : sharing expenses with WeExpenses.
contract WeExpenses {
    // Participant is a person or an organization which can be part of 
    struct Participant {
        string name; // name of the participant or the organization
        address waddress; // address of the participant
        int balance; // balance of the participant in cents (int type because balance can be negative).
        uint index; // index of the participant in the address list
    }

    // Expense which will be part of all the expenses
    struct Expense {
        string title; // title or designation of the expense
        uint amount; // amount of the expense in cents (uint type because amount must not be negative)
        uint date; // date of the expense 
        address payBy; // The participant who pays the expense
        address[] payFor; // The list of participants who apply for the expense
        mapping(address => bool)  agreements; //  Allow to know if a participant in the payFor array have given is agreement to contributes to the expense
    }

    // Refund which will be part of all the refunds
    struct Refund {
        string title; // title or designation of the refund
        uint amount; // amount of the refund in cents(uint type because amount must not be negative)
        uint date; // date of the refund
        address refundBy; // The participant who refunds
        address refundFor; // The refunded participant
    }

    // This declares a state variable that
    // stores a `Participant` struct for each possible address.
    mapping(address => Participant) public participants;

    address[] public addressList;

    bool public deployed = false; // Allow the creation of the first participant when the contract deployed
    
    // A dynamically-sized array of `Expenses` structs.
    Expense[] public expenses;

    // A dynamically-sized array of `Refunds` structs.
    Refund[] public refunds;

    // This modifier requires that the sender of the transaction is registred as participant
    modifier onlyByParticipant () {
        require(msg.sender == participants[msg.sender].waddress || !deployed); // You must be a participant to create an expense
        _;
    }

    /// Create a new WeExpenses contract
    function WeExpenses(string name) public {
        createParticipant(name, msg.sender);
        deployed = true;
    }

    // Create a new expense and add it in the expenses list
    function createExpense(string title, uint amount, uint date,
     address payBy, address[] payFor) external onlyByParticipant() {
        require(payFor.length <= 20); // Limit the number of contributors of one expense
        verifyIfParticipant(payBy);
        verifyIfParticipants(payFor);
        require(!isDuplicateInPayFor(payFor));

        Expense memory expense = Expense(title, amount, date, payBy, payFor);
        expenses.push(expense);
        syncBalanceExp(expense);
    }

    // Verify if several addresses are registred as participant. Return true if we found duplicate else false.
    function isDuplicateInPayFor(address[] listAddress) internal pure returns (bool) {
        uint counter;
        for (uint i=0; i<listAddress.length; i++) {
            counter = 0;
            address addr = listAddress[i];
            for (uint j=0; j<listAddress.length; j++) {
                if (addr == listAddress[j]) { counter++; }
                if (counter == 2) { return true; }
            }
        }
        return false;
    }

    // Verify if several addresses are registred as participant
    function verifyIfParticipants(address[] listAddress) internal view {
        for(uint i=0; i < listAddress.length; i++) {
            verifyIfParticipant(listAddress[i]);
        }
    }

    // Verify if an address is registered as participant
    function verifyIfParticipant(address waddress) internal view {
        require(waddress == participants[waddress].waddress);
    }

    // Give agreement of the sender to an expense
    function setAgreement(uint indexExpense, bool agree) onlyByParticipant() public {
        uint numberOfAgreeBefore = getNumberOfAgreements();
        require(expense.agreements);
        Expense storage expense = expenses[indexExpense];
        expense.agreements[msg.sender] = agree;
        uint numberOfAgreeAfter = getNumberOfAgreements();
        if (numberOfAgreeBefore == 0 && numberOfAgreeAfter == 1) {
            syncBalance(indexExpense);
        } else if (numberOfAgreeBefore == 1 && numberOfAgreeAfter == 0){
            revertBalance(indexExpense);
        } else{
            revertBalance(indexExpense);
            syncBalance(indexExpense);
        }
    }

    // Get agreement of depending on the indexExpenses and address of the participant
    function getAgreement(uint indexExpense, address waddress)  public view returns (bool) {
        return expenses[indexExpense].agreements[waddress];
    }

    // Get the number of agreements of a given expense
    function getNumberOfAgreements(uint indexExpense) public returns (uint) {
        Expense storage expense = expenses[indexExpense];
        uint numberOfAgreements = 0;
        for (uint i = 0; i < expense.payFor.length; i++) {
            if(expense.agreements[expense.payFor[i]] == true) {
                numberOfAgreements++;
            }                
        }
        return numberOfAgreements;  
    }

    // Create a new participant in the participants mapping
    function createParticipant(string name, address waddress) onlyByParticipant() public {
        require(waddress != participants[waddress].waddress || !deployed); //only one address per participant
        Participant memory participant = Participant({name: name, waddress: waddress, balance: 0, index: 0});
        participant.index = addressList.push(waddress)-1; //add the address to the addressList
        participants[waddress] = participant;
    }

    // Create a new refund and add it in the refunds list
    function createRefund(string title, uint amount, uint date,
     address refundBy, address refundFor) onlyByParticipant() external {
        verifyIfParticipant(refundBy);
        verifyIfParticipant(refundFor);
        Refund memory refund = Refund({title: title, amount: amount, date: date, refundBy: refundBy, refundFor: refundFor});
        refunds.push(refund);
        syncBalanceRef(refund);
    }

    // Synchronize the balance after each new expense
    function syncBalanceExp(Expense expense) internal {
        uint contributors = getNumberOfAgreements(index);
        require(contributors > 0);

        uint portion = expense.amount / contributors;
        participants[expense.payBy].balance += int(expense.amount);
        for (uint i = 0; i < expense.payFor.length; i++) {
                participants[expense.payFor[i]].balance -= int(portion);
        }       
    }

    // Synchronize the balance after each new expense #NEW
    function syncBalance(uint indexExpense) internal {
        uint contributors = getNumberOfAgreements(indexExpense);
        require(contributors > 0);
        Expense memory expense = expenses[indexExpense].amount;
        uint portion = expense.amount / contributors;
        participants[expense.payBy].balance += int(expense.amount);
        for (uint i = 0; i < expense.payFor.length; i++) {
            if (expense.agreement[expense.payFor[i]]){
                participants[expense.payFor[i]].balance -= int(portion);
            }   
        }       
    }

    // Revert the state of the balance before to add the expense
    function revertBalance(uint indexExpense) internal {
        uint contributors = getNumberOfAgreements(indexExpense);
        require(contributors > 0);
        Expense memory expense = expenses[indexExpense].amount;
        uint portion = expense.amount / contributors;
        participants[expense.payBy].balance -= int(expense.amount);
        for (uint i = 0; i < expense.payFor.length; i++) {
            if (expense.agreement[expense.payFor[i]]){
                participants[expense.payFor[i]].balance += int(portion);
            }   
        }       
    }

    function triggerSync() public {

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
        return (max, index);
    }

    // Get Balance of a participant
    function getBalance(address waddress) public view returns (int) {
        return participants[waddress].balance;
    }
  
    // Synchronize the balance after each new refund
    function syncBalanceRef(Refund refund) internal {
        participants[refund.refundFor].balance -= int(refund.amount);
        participants[refund.refundBy].balance += int(refund.amount);
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
    
