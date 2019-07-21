const Token= artifacts.require('MetaHERC1155')

const userPrivateKey = '0x2184b8c210c5839de74a837ada675d154c152f4033193b9b9a6c2c46d286c364';
const userAddress = '0xEfA2bc4D954E233961A7340c8f421dCbE863Ec4c';
let transferHash;
let BatchtransferHash;
let approveHash;
contract("tests the NFT creator",(accounts)=>{
    before(async () => {
        
        MetaERC= await Token.deployed()
        user1=accounts[0]
        user2=accounts[1]
        user3=accounts[2]
        user4=accounts[3]
    });
    
    it('Create initial items and adds them to list', async () => {
       // let Quantity = 100*10**10;
       // let Uri = 'this is the main herc token';
       // let Uri2 = 'this is the second herc token';
       //uint256 _initialSupply, string memory _uri,string memory _mutabledata,address to,string memory name,string memory symbol,uint mintlimit
        //tx = await MetaERC.create(Quantity, Uri,"Herculus","HERC", {from: user1});
      //  tx = await MetaERC.createfor(Quantity,Uri, Uri2,user1,"Herculus2","HERC2",0);
        
        let list=await  MetaERC.getAllOwnedTokens(user1)
        assert.equal(list[0].toNumber(),1,"token 1 is in list")
       
        
       
        await MetaERC.safeTransferFrom(user1,userAddress,1,1000,'0x0',{from:user1})
        await MetaERC.safeTransferFrom(user1,userAddress,2,1000,'0x0',{from:user1})
         list=await  MetaERC.getAllOwnedTokens(userAddress)
        console.log(list)
        
        }) 




    it('Should get the metaTransfer hash', () => MetaERC. metaTransferSingleHash(
         user2, 1, 100, 0
      )
        .then((res) => {
          const metaHash = web3.utils.soliditySha3(
            MetaERC.address,"metaTransferSingleFrom",user2, 1, 100, 0
          );
    
          assert.equal(res, metaHash, 'Hash is wrong');
         transferHash = res;
        }));

//address to, uint256[] memory tokenIds, uint256[] memory values, uint256 _nonce
    it('Should get the metaBatchTransfer hash', () => MetaERC.metaTransferBatchHash(
        user2, [1,2], [100,700], 1
     )
       .then((res) => {
         //const metaHash = web3.utils.soliditySha3(
           // MetaERC.address,"metaBatchTransferFrom",user1, [1,2], [100,700], 1
         
   
        // assert.equal(res, metaHash, 'Hash is wrong');
        BatchtransferHash=res;
         console.log(res)
       }));
       //(address _spender, uint256 _id, uint256 _currentValue, uint256 _value,uint _nonce) 
       it('Should get the metaApprove hash', () => MetaERC.metaApproveHash(
        user2, 1, 0,200, 2
     )
       .then((res) => {
         const metaHash = web3.utils.soliditySha3( MetaERC.address,"metaApproveHash" ,user2, 1, 0,200, 2)
           // MetaERC.address,"metaBatchTransferFrom",user1, [1,2], [100,700], 1
         
   
        assert.equal(res, metaHash, 'Hash is wrong');
        approveHash=res;
         console.log(res)
       }));

       it('should transfer tokens',async ()=>{
        let signature= web3.eth.accounts.sign(transferHash, userPrivateKey).signature
       // (bytes memory signature,address _to, uint256 _id, uint256 _value,bytes memory _data,uint256 _nonce)
        //console.log(await MetaERC.nonces(userAddress))
        let add=await MetaERC.getSigner(transferHash,signature)
        assert.equal(add,userAddress,'address recovered accurately')
        let nonce=await MetaERC.nonces(add)
        await MetaERC.metaSafeTransferSingleFrom(signature,user2, 1, 100,'0x0',0)
        let newBal=await MetaERC.balanceOf(user2,1)
        assert.equal(newBal.toNumber(),100,'tokens sent')
        nonce=await MetaERC.nonces(add)
        assert.equal(nonce.toNumber(),1,'nonce updated')
      })

      it('should do a batch transfer of tokens',async ()=>{
        let signature= web3.eth.accounts.sign(BatchtransferHash, userPrivateKey).signature
       // (bytes memory signature,address _to, uint256 _id, uint256 _value,bytes memory _data,uint256 _nonce)
        //console.log(await MetaERC.nonces(userAddress))
        let add=await MetaERC.getSigner(BatchtransferHash,signature)
        assert.equal(add,userAddress,'address recovered accurately')
        let nonce=await MetaERC.nonces(add)
        await MetaERC.metaSafeTransferBatchFrom(signature,user2, [1,2], [100,700],'0x0',1)
        let newBal2=await MetaERC.balanceOf(user2,2)
        let newBal1=await MetaERC.balanceOf(user2,1)
        assert.equal(newBal2.toNumber(),700,'tokens sent')
        assert.equal(newBal1.toNumber(),200,'tokens sent')
        nonce=await MetaERC.nonces(add)
        assert.equal(nonce.toNumber(),2,'nonce updated')
      })
      it('should make a meta approval',async ()=>{
        let signature= web3.eth.accounts.sign(approveHash, userPrivateKey).signature
        await MetaERC.metaApprove(signature,user2, 1, 0,200, 2)
        let allowance=await MetaERC.allowance(userAddress,user2,1)
        console.log(allowance.toNumber())
        assert.equal(allowance.toNumber(),200,'allowance was approved')
      })

})