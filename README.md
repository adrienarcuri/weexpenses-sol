# Group Expenses : WeExpenses

WeExpense is a solidity smart contract to manage group expenses on Ethereum Blockchain.
It allows participants to record expenses in order to settle debts in a trusless environment.
Only registered participant can add other participant.
Feel free to reuse this smart contract to create a group expense for experimental use only.

## Getting start

We use [Truffle](https://github.com/trufflesuite/truffle) as development environment framework.
Clone this Github project and make sur you have the following installed :

```
npm install -g ethereumjs-testrpc
npm install -g truffle
```

Then, run :

```
npm install
```

## Test

```
truffle test
```

## Test it in Remix IDE

The contract is testable in [Remix IDE](https://remix.ethereum.org/).
You can use this test set :

CreateContract by the owner Alice which will be also a participant :
```javascript
"Alice"
// "0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
```

CreateParticipant Bob :
```javascript
"Bob", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"

"Cris", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"

"Denis", "0x583031d1113ad414f02576bd6afabfb302140225"
```

CreateExpense payed by Alice for Bob:

```javascript
"Expense1", 10000, 1519135382, ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "0x583031d1113ad414f02576bd6afabfb302140225"]

"Expense2", 5000, 1519135382, ["0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"]
"Dede", "0x583031d1113ad414f02576bd6afabfb302140225"
```

setAgreement :
```
0, true // Give your agreement for the expense 1
0, false
```

createPayement : 
```
"Payment1", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db" // Send payment to Bob. "msg.value" must be > 0
"Payment2", "0x583031d1113ad414f02576bd6afabfb302140225" // Send payment to Denis. "msg.value" must be > 0

```
