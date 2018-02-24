import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/WeExpenses.sol";

contract TestWeExpenses {
  function testInitialBalanceWithNewWeExpensesContract() public {
    WeExpenses weExpenses = new WeExpenses("Alice");
    int expected = 0;
    Assert.equal(weExpenses.getBalance(tx.origin), expected, "First Participant should have 0 in his balance initially");
  }
}
