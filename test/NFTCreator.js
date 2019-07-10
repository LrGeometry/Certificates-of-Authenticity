const NFT = artifacts.require('NFTCreator');
const Token= artifacts.require('HERC115520')




contract("tests the NFT creator",(accounts)=>{
    before(async () => {
        user1 = accounts[0];
        user2 = accounts[1];
        user3 = accounts[2];
        user4 = accounts[3];
        NFTContract = await NFT.deployed();
        tokenContract= await Token.deployed()
        
    });
    

    it('Create initial items and adds them to list', async () => {
        
        
        let list=await  tokenContract.getAllOwnedTokens(user1)
        assert.equal(list[0].toNumber(),1,"token 1 is in list")
        console.log(await tokenContract.balanceOf(user1))
       await tokenContract.addMinter(NFTContract.address,{from:user1})
       
        await tokenContract.safeTransferFrom(user1,user3,1,1000,'0x0',{from:user1})
        
        
        })  
    it('creates different NFT Types',async()=>{
    let name="Purchase Order"
    let symbol="PO"
    let name1="Bill of Lading"
    let symbol1="BL Token"
    let name2="Bill of Lading"
    let symbol2="BL Token"
    await NFTContract.AddNFTTemplate(name,symbol,0,0)
    await NFTContract.AddNFTTemplate(name1,symbol1,0,1000)
    })
    it('Should give NFTcontract the allowance', () =>  tokenContract.approve(
        NFTContract.address,1000,
         {
          from: user3,
        },
      ));

  
    it('allows users to mint different NFT Types',async()=>{
      let POData="this is PODATA"
      
     await  NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
     await  NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
     await   NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
     await   NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
     ( await  tokenContract.getAllOwnedTokens(user2)+"all owned tokens")
     //console.log(await NFTContract.getAllTokensofType(1,{from:user2}))
  
  })
  it('allows users to mint different NFT Types',async()=>{
       
    let BLData=""
    NFTContract.mintNFT(2,BLData,"some mutable data",{from:user3})
    console.log(await  tokenContract.getAllOwnedTokens(user3)+"owned")
    console.log(await tokenContract.nonce())
})
    it('allows users to withdraw attached tokens for different NFT Types',async()=>{
        await tokenContract.approve(
            NFTContract.address,6,0,
            1, {
              from: user3,
            },
          )
          console.log(await tokenContract.TotalSupply(6));
        await NFTContract.withdrawAttached(6,{from:user3})
    })






})