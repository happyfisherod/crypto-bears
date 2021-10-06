const CryptoBears = artifacts.require("CryptoBears");
const utils = require("./helpers/utils");
const time = require("./helpers/time");
var expect = require('chai').expect;
const bearNames = ["Bear 1", "Bear 2"];
contract("CryptoBears", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await CryptoBears.new();
    });
    it("should be able to create a new bear", async () => {
        const result = await contractInstance.createRandomBear(bearNames[0], {from: alice});
        expect(result.receipt.status).to.equal(true);
        expect(result.logs[0].args.name).to.equal(bearNames[0]);
    })
    it("should not allow two bears", async () => {
        await contractInstance.createRandomBear(bearNames[0], {from: alice});
        await utils.shouldThrow(contractInstance.createRandomBear(bearNames[1], {from: alice}));
    })
    context("with the single-step transfer scenario", async () => {
        it("should transfer a bear", async () => {
            const result = await contractInstance.createRandomBear(bearNames[0], {from: alice});
            const bearId = result.logs[0].args.bearId.toNumber();
            await contractInstance.transferFrom(alice, bob, bearId, {from: alice});
            const newOwner = await contractInstance.ownerOf(bearId);
            expect(newOwner).to.equal(bob);
        })
    })
    context("with the two-step transfer scenario", async () => {
        it("should approve and then transfer a bear when the approved address calls transferFrom", async () => {
            const result = await contractInstance.createRandomBear(bearNames[0], {from: alice});
            const bearId = result.logs[0].args.bearId.toNumber();
            await contractInstance.approve(bob, bearId, {from: alice});
            await contractInstance.transferFrom(alice, bob, bearId, {from: bob});
            const newOwner = await contractInstance.ownerOf(bearId);
            expect(newOwner).to.equal(bob);
        })
        it("should approve and then transfer a bear when the owner calls transferFrom", async () => {
            const result = await contractInstance.createRandomBear(bearNames[0], {from: alice});
            const bearId = result.logs[0].args.bearId.toNumber();
            await contractInstance.approve(bob, bearId, {from: alice});
            await contractInstance.transferFrom(alice, bob, bearId, {from: alice});
            const newOwner = await contractInstance.ownerOf(bearId);
            expect(newOwner).to.equal(bob);
         })
    })
    it("bears should be able to attack another bear", async () => {
        let result;
        result = await contractInstance.createRandomBear(bearNames[0], {from: alice});
        const firstBearId = result.logs[0].args.bearId.toNumber();
        result = await contractInstance.createRandomBear(bearNames[1], {from: bob});
        const secondBearId = result.logs[0].args.bearId.toNumber();
        await time.increase(time.duration.days(1));
        await contractInstance.attack(firstBearId, secondBearId, {from: alice});
        expect(result.receipt.status).to.equal(true);
    })
})
