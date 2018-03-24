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

3. Create several expenses : Alice pays 100 [Finney](https://medium.com/@tjayrush/what-the-f-is-a-finney-8e727f29e77f) for the food for all. Bob pays for restaurant 50 Finney only for Alice and him. Cris pays 300 Finney of travel cost for Alice, Bob and Denis but not for him. Do not forget to change sender's account when you submit the transaction :

createExpense :
```javascript
// From Alice's account
"Food", 100000000000000000, 1519135382, ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "0x583031d1113ad414f02576bd6afabfb302140225"]

// From Bob's account
"Restaurant", 50000000000000000, 1519135382, ["0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c"]

// From Cris's account
"Travel", 300000000000000000, 1519135382, ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x583031d1113ad414f02576bd6afabfb302140225"]
```

4. Each participant involved in an expense give its agreement for the expense.

setAgreement :
```javascript
// From Alice's account, Bob's account, Cris's account, Denis's account for expense "Food" (4 times)
0, true
```
5. Get the balance of each participant. You should have the following : Alice: 75000000000000000, Bob: -25000000000000000, Cris: -25000000000000000, Denis: -25000000000000000.

GetBalance : 
```javascript
"0xca35b7d915458ef540ade6068dfe2f44e8fa733c"

"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"

"0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"

"0x583031d1113ad414f02576bd6afabfb302140225"

```
6. Make a payment from Bob to Alice of 25 Finney. When you use this function, do not forget to send ether corresponding to the amount of the payment, otherwise the payment fails. 

CreatePayment :
```javascript
// From Bob's account
"TxBobToAlice","0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
```

7. Observe Alice's withdrawal. It should be equal to 2500.

GetWithdrawal or withdrawals :
```javascript
"0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
```

8. Withdraw from Alice's account. Just push "withdraw. :

withdraw

Observe Alice's withdrawal again (step 7). It should be equal to 0. The Alice's account should be increased by 25 Finney (0.025).
Observe all the balance (step 5). You should have : Alice: 50000000000000000, Bob: 0, Cris: -25000000000000000, Denis: -25000000000000000.

9. Cancel the agreement of Cris on the first expense.

GetWithdrawal or withdrawals :
setAgreement
```javascript
// From Cris' account
0, false
```

Observe all the balances (step 5).

You should have : Alice: 41666666666666667, Bob: -8333333333333333 Cris: 0, Denis: -33333333333333333.


## License

Realesed under MIT License [here](https://github.com/adrienarcuri/weexpenses-sol/blob/master/LICENSE).
