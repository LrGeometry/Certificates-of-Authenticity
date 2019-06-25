

const Token = artifacts.require('HERC1155');
const Receiver= artifacts.require('./ERC/ERC1155MockReceiver')



contract("testing enumeration and approval",(accounts)=>{



    before(async () => {
        user1 = accounts[0];
        user2 = accounts[2];
        user3 = accounts[3];
        user4 = accounts[4];
        mainContract = await Token.new();
        receiverContract = await Receiver.new();
    });


    it('Create initial items and adds them to list', async () => {
    let hammerQuantity = 5;
    let hammerUri = 'https://metadata.enjincoin.io/hammer.json';
    let mutabledata="something"
    tx = await mainContract.create(hammerQuantity, hammerUri,"hammer","hm", {from: user1});
    
    

   

    let swordQuantity = 200;
    let swordUri = 'https://metadata.enjincoin.io/sword.json';
    let mutabledata="other thing"
    tx = await mainContract.create(swordQuantity, swordUri,"sword","sd", {from: user1});
   
   

    let maceQuantity = 1000;
    let maceUri = 'https://metadata.enjincoin.io/mace.json';
    tx = await mainContract.create(maceQuantity, maceUri,"mace","mc", {from: user1});
    let list=await  mainContract.getAllOwnedTokens(user1)
    assert.equal(list[0].toNumber(),1,"token 1 is in list")
    assert.equal(list[1].toNumber(),2,"token 2 is in list")
    assert.equal(list[2].toNumber(),3,"token 3 is in list")
    
    })    
    it("updates token list with transfers",async()=>{
        //safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data)
        //safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)
        await  mainContract.safeTransferFrom(user1,user2,1,5,"0x00001",{from:user1})
        await  mainContract.safeTransferFrom(user1,user2,1,0,"0x00001",{from:user1})
        console.log(await  mainContract.getAllOwnedTokens(user1))
        console.log(await  mainContract.getAllOwnedTokens(user2))
    })
    it("updates token list with batchtransfers",async()=>{
        //safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data)
        //safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)
        await  mainContract.safeBatchTransferFrom(user1,user2,[2,3],[100,500],"0x00001",{from:user1})
        console.log(await  mainContract.getAllOwnedTokens(user1))
        console.log(await  mainContract.getAllOwnedTokens(user2))
    })
    it("updates token list with batchtransfers2",async()=>{
        //safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data)
        //safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)
        await  mainContract.safeBatchTransferFrom(user1,user2,[2,3],[100,500],"0x00001",{from:user1})
        await  mainContract.safeBatchTransferFrom(user1,user2,[2,3],[0,0],"0x00001",{from:user1})
        console.log(await  mainContract.getAllOwnedTokens(user1))
        console.log(await  mainContract.getAllOwnedTokens(user2))
    })
})