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
    

    it('transfer and safe transfer both do the same thing', async () => {
        
        
        let list=await  tokenContract.getAllOwnedTokens(user1)
        assert.equal(list[0].toNumber(),1,"token 1 is in list")
        console.log(await tokenContract.balanceOf(user1))
       await tokenContract.addMinter(NFTContract.address,{from:user1})
       
        await tokenContract.safeTransferFrom(user1,user3,1,1000,'0x0',{from:user1})
        await tokenContract.transfer(user3,1000,{from:user1})
        let userBalance=(await tokenContract.balanceOf(user3)).toNumber()
        assert.equal(userBalance,2000,"tokens transferred properly")
        })  
    
    it('can approve tokens properly using the erc20 method',async()=>{
       await tokenContract.approve(user4,1000,{from:user3})
       await tokenContract.transferFrom(user3,user2,1000,{from:user4})
    })
    




})