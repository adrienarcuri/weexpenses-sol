//import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';

var WeExpenses = artifacts.require("./WeExpenses.sol");

contract('WeExpenses', function(accounts) {
    let weExpenses

    SENDER_A = accounts[0]
    SENDER_B = accounts[1]
    SENDER_C = accounts[2]
    SENDER_D = accounts[3]

    payForAB = [SENDER_A, SENDER_B];
    payForABD = [SENDER_A, SENDER_B, SENDER_D];
    payForABCD = [SENDER_A, SENDER_B, SENDER_C, SENDER_D];
    
    beforeEach('setup contract for each test', async function () {
        instance = await WeExpenses.new()
        //let instance = await WeExpenses.deployed()
    })

    it('Participant should have his balance equal to 0', async function () {
        let balance = await instance.getBalance.call(SENDER_A)
        assert.equal(balance, 0)
    })
    
    it('Participants should have his balance equal to 0', async function () {
        await instance.createParticipant(1, SENDER_B,{from: SENDER_A})
        assert.equal(await instance.getBalance.call(SENDER_A), 0)
        await instance.createParticipant(1, SENDER_C,{from: SENDER_B})
        assert.equal(await instance.getBalance.call(SENDER_B), 0)
        await instance.createParticipant(1, SENDER_D,{from: SENDER_C})
        assert.equal(await instance.getBalance.call(SENDER_C), 0)
        let max = await instance.getMaxBalance.call({from: SENDER_A})
        assert.equal(max[0], 0);
    })

    function checkGetMaxBalance() {
        
    }
	
});