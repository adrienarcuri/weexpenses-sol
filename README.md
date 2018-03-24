# Group Expenses : WeExpenses

WeExpense is a solidity smart contract to manage group expenses on Ethereum Blockchain.
It allows participants to record expenses in order to settle debts in a trusless environment.
Only registered participant can add other participant.
Feel free to reuse this smart contract to create a group expense for experimental use only.

## Getting started

We use [Truffle](https://github.com/trufflesuite/truffle) as development environment framework and [Ganache CLI](https://github.com/trufflesuite/ganache-cli) as Ethereum RP client.
Clone this Github project and make sur you have the following installed :

```
npm install -g ganache-cli
npm install -g truffle
```

Then, run :

```
npm install
```

## Test

```
ganache-cli
truffle test
```

## Test it in Remix IDE

The contract is testable in [Remix IDE](https://remix.ethereum.org/).
You can use this test set :

1. Alice create the contract and register herself as a participant. Use the 1st Remix Account (0xca35b7d915458ef540ade6068dfe2f44e8fa733c) and add "Alice" in the input argument, then push Create:
Create :
```javascript
"Alice"
```

2. Create the other participants with Alice's account (only registered participant can add new participants) :
createParticipant :
```javascript
"Bob", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"
"Cris", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"
"Denis", "0x583031d1113ad414f02576bd6afabfb302140225"
```

3. Create several expenses : Alice pays 10000 wei for the food for all. Bob pays for restaurant 50000 wei only for Alice and him. Cris pays 300000 wei of travel cost for Alice, Bob and Denis but not for him. Do not forget to change sender's account when you submit the transaction :

createExpense :
```javascript
// From Alice's account
"Food", 10000, 1519135382, ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "0x583031d1113ad414f02576bd6afabfb302140225"]

// From Bob's account
"Restaurant", 50000, 1519135382, ["0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c"]

// From Cris's account
"Travel", 300000, 1519135382, ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x583031d1113ad414f02576bd6afabfb302140225"]
```

4. Each participant involved in an expense give its agreement for the expense.

setAgreement :
```javascript
// From Alice's account, Bob's account, Cris's account, Denis's account for expense "Food" (4 times)
0, true

```
5. Get the balance of each participant. You should have the following : Alice: 7500, Bob: -2500, Cris: -2500, Denis: -2500.

GetBalance : 
```javascript
"0xca35b7d915458ef540ade6068dfe2f44e8fa733c"

"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"

"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"

"0x583031d1113ad414f02576bd6afabfb302140225"

```
6. Make a payment from Bob to Alice. When you use this function, do not forget to send ether corresponding to the amount of the payment, otherwise the payment failed. 

CreatePayment :
```javascript
// From Bob's account
"TxBobToAlice","0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
```

7. //TODO

## License

Realesed under MIT License [here](https://github.com/adrienarcuri/weexpenses-sol/blob/master/LICENSE).
