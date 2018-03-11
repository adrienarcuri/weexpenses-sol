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
        instance = await WeExpenses.new()
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

        it('should not create a expense when the sender is not a participant', async function () {
            await expectThrow(instance.createParticipant("0 addresss", ZERO_ADDR, { from: SENDER_A }) )
        })

        it('should create an expense', async function () {
            instance.createExpense("Expense1", 10000, 1519135382, SENDER_A, payForABCD, { from: SENDER_A })
            await checkGetExpense(SENDER_A, 0)
            instance.createExpense("Expense2", 5000, 1519135382, SENDER_B, payForAB, { from: SENDER_A })
            await checkGetExpense(SENDER_A, 1)
            instance.createExpense("Expense3", 30000, 1519135382, SENDER_C, payForABD, { from: SENDER_A })
            await checkGetExpense(SENDER_A, 2)
        })

        async function checkGetMaxBalance(_from, expectedMaxBalance, expectedIndex) {
            let max = await instance.getMaxBalance.call({ from: _from });
            assert.equal(max[0], expectedMaxBalance, "Expected MaxBalance are not equal");
            assert.equal(max[1], expectedIndex);
        }

        async function checkGetBalance(_from, waddress, expectedBalance) {
            assert.equal(await instance.getBalance.call(waddress, { from: _from }), expectedBalance)
        }

        async function checkGetExpense(_from, indexExpense) {
            let expense = await instance.expenses.call(indexExpense, { from: _from })
            assert.typeOf(expense, 'array')
            assert.lengthOf(expense, 5)
        }

        async function checkGet(_from, indexExpense) {
            let expense = await instance.expenses.call(indexExpense, { from: _from })
            assert.typeOf(expense, 'array')
            assert.lengthOf(expense, 5)
        }
    })
    

    
	
});