

const Token = artifacts.require('HERC115520');
const Receiver= artifacts.require('./ERC/ERC1155MockReceiver')

function include(arr,obj) {
    return (arr.indexOf(obj) != -1);
}
function convertToNumbers(arr){
    arr.forEach((value,key)=>{
        arr[key]=value.toNumber()
    })
    return arr;
}
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
     mutabledata="other thing"
    tx = await mainContract.create(swordQuantity, swordUri,"sword","sd", {from: user1});
   
   

    let maceQuantity = 1000;
    let maceUri = 'https://metadata.enjincoin.io/mace.json';
    tx = await mainContract.create(maceQuantity, maceUri,"mace","mc", {from: user1});
    let list=await  mainContract.getAllOwnedTokens(user1)
    console.log(list)
    assert.equal(list[1].toNumber(),2,"token 1 is in list")
    assert.equal(list[2].toNumber(),3,"token 2 is in list")
    assert.equal(list[3].toNumber(),4,"token 3 is in list")
    
    })    
    it("updates token list with transfers",async()=>{
        //safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data)
        //safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)
        await  mainContract.safeTransferFrom(user1,user2,2,5,"0x00001",{from:user1})
        await  mainContract.safeTransferFrom(user1,user2,3,50,"0x00001",{from:user1})
        console.log(await  mainContract.getAllOwnedTokens(user1))
        let list=await  mainContract.getAllOwnedTokens(user1)
        list=convertToNumbers(list)
        console.log(list)
        let list2=await  mainContract.getAllOwnedTokens(user2)
        list2=convertToNumbers(list2)
        list.forEach((value,key)=>{
          console.log(value,key)
        })
        assert.equal(list.length,3,"user1 should have lost a token")
        assert.equal(list[1],4,"token 2 is in list")
        assert.equal(list[2],3,"token 3 is in list")
        list2.forEach((value,key)=>{
            console.log(value,key)
          })
        let result=include(list,4)
        console.log(result)  
    })
    it("updates token list with a batchtransfer",async()=>{
        //safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data)
        //safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)
        await  mainContract.safeBatchTransferFrom(user1,user2,[3,4],[150,500],"0x00001",{from:user1})
        let list =await  mainContract.getAllOwnedTokens(user1)
        list=convertToNumbers(list)
        console.log(list)
        let result=include(list,3)
        console.log(result)  
        assert.equal(false,result,'token should no long ')
        
    })
    it("updates token list with batchtransfer of all tokens between users",async()=>{
        //safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data)
        //safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)
        let list =await  mainContract.getAllOwnedTokens(user2)
        list=convertToNumbers(list)
        await  mainContract.safeBatchTransferFrom(user2,user3,[2,3,4],[5,200,500],"0x00001",{from:user2})
        let updatedlist =await  mainContract.getAllOwnedTokens(user2)
        updatedlist=convertToNumbers(updatedlist)
        let list2 =await  mainContract.getAllOwnedTokens(user3)
        list2=convertToNumbers(list2)
        console.log(list2)
        assert.equal(updatedlist.length,0,'user2 two owns no tokens')
        assert.equal(list2,[ 2, 3, 4 ],'user3 now has tokens 2 3 and 4')
    })
})