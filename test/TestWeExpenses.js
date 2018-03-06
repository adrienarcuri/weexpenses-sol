import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';

var WeExpenses = artifacts.require("./WeExpenses.sol");

contract('WeExpenses', function (accounts) {
    let instance;
    
    const SENDER_A = accounts[0]
    const SENDER_B = accounts[1]
    const SENDER_C = accounts[2]
    const SENDER_D = accounts[3]

    const payForAB = [SENDER_A, SENDER_B];
    const payForABD = [SENDER_A, SENDER_B, SENDER_D];
    const payForABCD = [SENDER_A, SENDER_B, SENDER_C, SENDER_D];

    before('setup contract once before all the tests', async function () {
        instance = await WeExpenses.new()
        //let instance = await WeExpenses.deployed()
    })

    describe("Scenario 1", function () {
        it('First participant should have his balance equal to 0', async function () {
            let balance = await instance.getBalance.call(SENDER_A)
            assert.equal(balance, 0)
        })

        it('should not create the same participant', async function () {
            await expectThrow(instance.createParticipant(1, SENDER_A, { from: SENDER_A }) )
        })

        it('should not create a participant when the sender is not a participant', async function () {
            await expectThrow(instance.createParticipant(1, SENDER_A, { from: SENDER_B }) )
        })

        it('Participants should have their balance equal to 0', async function () {
            await instance.createParticipant(1, SENDER_B, { from: SENDER_A })
            await checkGetBalance(SENDER_A, SENDER_B, 0)
            await instance.createParticipant(1, SENDER_C, { from: SENDER_B })
            await checkGetBalance(SENDER_A, SENDER_C, 0)
            await instance.createParticipant(1, SENDER_D, { from: SENDER_C })
            await checkGetBalance(SENDER_A, SENDER_D, 0)

            await checkGetMaxBalance(SENDER_A, 0, 0)
        })

        async function checkGetMaxBalance(_from, expectedMaxBalance, expectedIndex) {
            let max = await instance.getMaxBalance.call({ from: _from });
            assert.equal(max[0], expectedMaxBalance, "Expected MaxBalance are not equal");
            assert.equal(max[1], expectedIndex);
        }

        async function checkGetBalance(_from, waddress, expectedBalance) {
            assert.equal(await instance.getBalance.call(waddress, { from: _from }), expectedBalance)
        }
    })
    

    
	
});