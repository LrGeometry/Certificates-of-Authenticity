//const NFT = artifacts.require('NFTCreator');
const Token= artifacts.require('HERC115520')
const FT=artifacts.require('Futurist')



contract("tests the NFT creator",(accounts)=>{
    before(async () => {
        user1 = accounts[0];
        user2 = accounts[1];
        user3 = accounts[2];
        user4 = accounts[3];
        FTContract = await FT.deployed();
        tokenContract= await Token.deployed()
       // FTcontract=await FT.deployed();
        
    });
    

    it('transfer and safe transfer both do the same thing', async () => {
        
        
        //let list=await  tokenContract.getAllOwnedTokens(user1)
        //assert.equal(list[0].toNumber(),1,"token 1 is in list")
        //console.log(await tokenContract.balanceOf(user1))
      // await tokenContract.addMinter(NFTContract.address,{from:user1})
       
      
    
       let tx1= await tokenContract.transfer(user3,1000,{from:user1})
       let tx2= await tokenContract.transfer(user3,1000,{from:user1})
       let tx3= await tokenContract.transfer(user3,1000,{from:user1})
       let tx4 =await tokenContract.safeTransferFrom(user1,user3,1,1000,"0x",{from:user1})
       
       console.log(tx1.receipt.gasUsed)
       console.log(tx2.receipt.gasUsed)
       console.log(tx3.receipt.gasUsed)
       console.log(tx4.receipt.gasUsed)
       
        let userBalance=(await tokenContract.balanceOf(user3)).toNumber()
        assert.equal(userBalance,4000,"tokens transferred properly")

        })  
    
    it('can approve tokens properly using the erc20 method',async()=>{
       await tokenContract.approve(user4,1000,{from:user3})
       console.log(await tokenContract.allowance(user3,user4))
       assert.equal(await tokenContract.allowance(user3,user4),1000,'token allowance equal to 1000')
       await tokenContract.transferFrom(user3,user2,1000,{from:user4})
       console.log(await tokenContract.allowance(user3,user3))
       assert.equal(await tokenContract.allowance(user3,user4),0,'token allowance equal to 0')
    })
    it('can tranfer to a contract without the erc1155 interface',async()=>{
        let tx1= await tokenContract.transfer(FT.address,1000,{from:user1})
        
        assert.equal(await tokenContract.balanceOf(FT.address),1000,'sent contract now has 1000 tokens')
     })
     it('can pause the contract',async()=>{
        await tokenContract.pause()
        console.log(await tokenContract.paused())
     })
 


})