//const NFT = artifacts.require('NFTCreator');
const Token= artifacts.require('HERC115520')
const FT=artifacts.require('Futurist')
const expectThrow = require('./helpers/expectThrow');



contract("tests the NFT creator",(accounts)=>{
    before(async () => {
        user1 = accounts[0];
        user2 = accounts[1];
        user3 = accounts[2];
        user4 = accounts[3];
        FTContract = await FT.deployed();
        mainContract= await Token.deployed()
       // FTcontract=await FT.deployed();
        
    });

     it('Create initial items and adds them to list', async () => {
    let hammerQuantity = 5;
    let hammerUri = 'https://metadata.enjincoin.io/hammer.json';
    let mutabledata="something"
    tx = await mainContract.create(hammerQuantity, hammerUri,"hammer","hm", {from: user1});
    
    

   

    let swordQuantity = 200;
    let swordUri = 'https://metadata.enjincoin.io/sword.json';
     mutabledata="other thing"
    tx = await mainContract.create(swordQuantity, swordUri,"sword","sd", {from: user1});
   
   

    let maceQuantity = 1000;
    let maceUri = 'https://metadata.enjincoin.io/mace.json';
    tx = await mainContract.create(maceQuantity, maceUri,"mace","mc", {from: user1});
    let list=await  mainContract.getAllOwnedTokens(user1)
    console.log(list)
    assert.equal(list[0].toNumber(),2,"token 1 is in list")
    assert.equal(list[1].toNumber(),3,"token 2 is in list")
    assert.equal(list[2].toNumber(),4,"token 3 is in list")
    
    })  
     it('can pause the contract',async()=>{
        await expectThrow(mainContract.pause({from:accounts[2]}))
        await mainContract.pause()
        console.log(await mainContract.paused())
        assert.equal(await mainContract.paused(),true,'contract is paused')
     })
 

    it('transfers cannot happen when pasued', async () => {
        await expectThrow(mainContract.safeTransferFrom(user1,user2,2,5,"0x00001",{from:user1}))
        await  expectThrow(mainContract.safeTransferFrom(user1,user2,3,50,"0x00001",{from:user1}))

        })  
    
 


})