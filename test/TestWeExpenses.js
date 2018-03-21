import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';

var WeExpenses = artifacts.require("./WeExpenses.sol");

contract('WeExpenses', function (accounts) {
    let instance;
    
    const ZERO_ADDR = 0x0000000000000000000000000000000000000000
    const SENDER_A = accounts[0]
    const SENDER_B = accounts[1]
    const SENDER_C = accounts[2]
    const SENDER_D = accounts[3]

    const UNKOWN_ADDR = accounts[9]

    const payForAB = [SENDER_A, SENDER_B];
    const payForABD = [SENDER_A, SENDER_B, SENDER_D];
    const payForABCD = [SENDER_A, SENDER_B, SENDER_C, SENDER_D];

    before('setup contract once before all the tests', async function () {
        instance = await WeExpenses.new("Alice")
        //let instance = await WeExpenses.deployed()
    })

    describe("Init Participants", function () {
        it('First participant should have his balance equal to 0', async function () {
            let balance = await instance.getBalance.call(SENDER_A)
            assert.equal(balance, 0)
        })

        it('should not create a participant with the same address', async function () {
            await expectThrow(instance.createParticipant("Alice", SENDER_A, { from: SENDER_A }) )
        })

        it('should not create a participant when the sender is not a participant', async function () {
            await expectThrow(instance.createParticipant("Alice", SENDER_B, { from: UNKOWN_ADDR }) )
        })

        it('should not create a participant which has an uninitialized address', async function () {
            await expectThrow(instance.createParticipant("0 addresss", ZERO_ADDR, { from: SENDER_A }) )
        })

        it('Participants should have their balance equal to 0', async function () {
            await instance.createParticipant("Bob", SENDER_B, { from: SENDER_A })
            await checkGetBalance(SENDER_A, SENDER_B, 0)
            await instance.createParticipant("Cris", SENDER_C, { from: SENDER_B })
            await checkGetBalance(SENDER_A, SENDER_C, 0)
            await instance.createParticipant("Dede", SENDER_D, { from: SENDER_C })
            await checkGetBalance(SENDER_A, SENDER_D, 0)
            await checkGetMaxBalance(SENDER_A, 0, 0)
        })
        /** 
        it('should not create a expense when the sender is not a participant', async function () {
            await expectThrow(instance.createParticipant("0 addresss", ZERO_ADDR, { from: SENDER_A }) )
        })
        */

        it('should create expenses', async function () {
            instance.createExpense("Expense1", 10000, 1519135382, payForABCD, { from: SENDER_A })
            //await checkGetExpense(SENDER_A, 0);
            instance.createExpense("Expense2", 5000, 1519135382, payForAB, { from: SENDER_B })
            //await checkGetExpense(SENDER_A, 1);
            instance.createExpense("Expense3", 30000, 1519135382, payForABD, { from: SENDER_A })
            //await checkGetExpense(SENDER_A, 2);
        })

        it('should not set the agreement of Expense1 when agreement is set to false for the first time', async function() {
            await expectThrow(instance.setAgreement(0, false, { from: SENDER_A}))
        })

        it('should not set the agreement of Expense1 when the participant is not registred', async function() {
            await expectThrow(instance.setAgreement(0, true, { from: UNKOWN_ADDR}))
        })
        /** 
        it('should not set the agreement of Expense2 when the participant is not a payee', async function() {
            await expectThrow(instance.setAgreement(1, true, { from: SENDER_D}))
        })
        */

        it('should set the agreement of B to true for Expense1', async function() {
            await instance.setAgreement(0, true, { from: SENDER_B})
            await checkGetAgreement(SENDER_A, 0, SENDER_B, true, { from: SENDER_A})
            await checkGetBalance(SENDER_A, SENDER_A, 10000)
            await checkGetBalance(SENDER_A, SENDER_B, -10000)
            await checkGetBalance(SENDER_A, SENDER_C, 0)
            await checkGetBalance(SENDER_A, SENDER_D, 0)
        })

        it('should set the agreement of A to true for Expense1', async function() {
            await instance.setAgreement(0, true, { from: SENDER_A})
            await checkGetAgreement(SENDER_A, 0, SENDER_A, true, { from: SENDER_A})
            await checkGetBalance(SENDER_A, SENDER_A, 5000)
            await checkGetBalance(SENDER_A, SENDER_B, -5000)
            await checkGetBalance(SENDER_A, SENDER_C, 0)
            await checkGetBalance(SENDER_A, SENDER_D, 0)
        })

        it('should set the agreement of C to true for Expense1', async function() {
            await instance.setAgreement(0, true, { from: SENDER_C})
            await checkGetAgreement(SENDER_A, 0, SENDER_C, true, { from: SENDER_A})
            await checkGetBalance(SENDER_A, SENDER_A, 6667)
            await checkGetBalance(SENDER_A, SENDER_B, -3333)
            await checkGetBalance(SENDER_A, SENDER_C, -3333)
            await checkGetBalance(SENDER_A, SENDER_D, 0)
        })

        it('should set the agreement of D to true for Expense1', async function() {
            await instance.setAgreement(0, true, { from: SENDER_D})
            await checkGetAgreement(SENDER_A, 0, SENDER_D, true, { from: SENDER_A})
            await checkGetBalance(SENDER_A, SENDER_A, 7500)
            await checkGetBalance(SENDER_A, SENDER_B, -2500)
            await checkGetBalance(SENDER_A, SENDER_C, -2500)
            await checkGetBalance(SENDER_A, SENDER_D, -2500)
        })

        it('should set the agreement of D to false for Expense1', async function() {
            await instance.setAgreement(0, false, { from: SENDER_D})
            await checkGetAgreement(SENDER_A, 0, SENDER_D, false, { from: SENDER_A})
            await checkGetBalance(SENDER_A, SENDER_A, 6667)
            await checkGetBalance(SENDER_A, SENDER_B, -3333)
            await checkGetBalance(SENDER_A, SENDER_C, -3333)
            await checkGetBalance(SENDER_A, SENDER_D, 0)
        })

        it('should not create a payment', async function () {
            await expectThrow(instance.createPayment("Payment", SENDER_A, { from: UNKOWN_ADDR}))
            await expectThrow(instance.createPayment("Payment", SENDER_A, { from: SENDER_A, value: 1000}))
            await expectThrow(instance.createPayment("Payment", SENDER_A, { from: SENDER_B, value: 0}))
            await expectThrow(instance.createPayment("Payment", UNKOWN_ADDR, { from: SENDER_B, value: 1000}))
        })

        it('should create a payment from B to A', async function () {
            checkGetWithdrawal(SENDER_A, SENDER_A, 0)
            await instance.createPayment("Payment1", SENDER_A, { from: SENDER_B, value: 1000})
            checkGetWithdrawal(SENDER_A, SENDER_A, 1000)
            await checkGetBalance(SENDER_A, SENDER_A, 5667)
            await checkGetBalance(SENDER_A, SENDER_B, -2333)
        })

        it('should not withdraw', async function () {
            await expectThrow(instance.withdraw({ from: SENDER_B }))
            await expectThrow(instance.withdraw({ from: SENDER_D }))
            await expectThrow(instance.withdraw({ from: UNKOWN_ADDR }))
        })

        it('should withdraw available money for A', async function () {
            checkGetWithdrawal(SENDER_A, SENDER_A, 1000)
            await instance.withdraw({ from: SENDER_A })
            checkGetWithdrawal(SENDER_A, SENDER_A, 0)
        })        

        async function checkGetMaxBalance(_from, expectedMaxBalance, expectedIndex) {
            let max = await instance.getMaxBalance.call({ from: _from });
            assert.equal(max[0], expectedMaxBalance, "Expected MaxBalance are not equal");
            assert.equal(max[1], expectedIndex);
        }

        async function checkGetBalance(_from, waddress, expectedBalance) {
            let balance = await instance.getBalance.call(waddress, { from: _from })
            assert.equal(balance.toNumber(), expectedBalance)
        }

        async function checkGetWithdrawal(_from, waddress, expectedWithdrawal) {
            let withdrawal = await instance.getWithdrawal.call(waddress, { from: _from })
            assert.equal(withdrawal.toNumber(), expectedWithdrawal)
        }

        async function checkGetExpense(_from, indexExpense) {
            let expense = await instance.expenses.call(indexExpense, { from: _from })
            assert.typeOf(expense, 'array')
            assert.lengthOf(expense, 5)
        }

        async function checkGetAgreement(_from, indexExpense, waddress, expectedAgreement) {
            let agreement = await instance.getAgreement(indexExpense, waddress, { from: _from })
            assert.equal(agreement, expectedAgreement)
        }
    })
    
});