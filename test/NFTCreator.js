//import { AssertionError } from "assert";

const NFT = artifacts.require('NFTCreator');
const Token= artifacts.require('HERC115520')

//import expectThrow from './helpers/expectThrow.js'


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
        
        
        //let list=await  tokenContract.getAllOwnedTokens(user1)
        //assert.equal(list[0].toNumber(),1,"token 1 is in list")
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
    await NFTContract.CreateTemplate(name,symbol,1000,0)
    await NFTContract.CreateTemplate(name1,symbol1,1000,1000)
    let template=await NFTContract.NFTTemplates(2)
    console.log(template.name)
    console.log(template.symbol)
    console.log(template.attachedTokens)
    console.log(template.mintlimit)
    console.log(await NFTContract.NFTTemplates(1))
    //console.log(await NFTContract.NFTTemplates(0))
    })
    it('Should give NFTcontract the allowance', () =>  tokenContract.increaseApproval(
        NFTContract.address,1,0,1000,
         {
          from: user3,
        },
      ));

    it('allows user3 to mint type and make copies',async()=>{
       
       let BLData="data and stuff"
       await NFTContract.mintNFT(2,BLData,"some mutable data",{from:user3})
       console.log(await  tokenContract.getAllOwnedTokens(user3)+"owned")
       console.log(await  tokenContract.balanceOf(user3,2))
       console.log(await tokenContract.creators(2) )
       //console.log(user3)
       console.log(await tokenContract.MintableTokens(2) + "old mint balance")
       await tokenContract.mint(2, [user2,user1,user4], [100,600,300],{from:user3})

       console.log(await tokenContract.MintableTokens(2)+" new mint amount")
       let u3b=await  tokenContract.balanceOf(user2,2)
       let u1b=await  tokenContract.balanceOf(user1,2)
       let u4b=await  tokenContract.balanceOf(user4,2)
       console.log(await tokenContract.getAllOwnedTokens(user2))
       console.log(u3b)
       console.log(u1b)
       console.log(u4b)
    })
  
    it('allows users to mint type 1',async()=>{
      let POData="this is PODATA"
      
      await  NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
      await  NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
      await  NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
      await  NFTContract.mintNFT(1,POData,"some mutable data",{from:user2})
      console.log(await  tokenContract.getAllOwnedTokens(user2))
      
      console.log('all owned tokens')
      //  console.log(await NFTContract.getAllTokensofType(1,{from:user2}))
      //await tokenContract.mint(uint256 _id, address[] memory _to, uint256[] memory _quantities)
  
  })
  
      it('allows users to withdraw attached tokens for different NFT Types',async()=>{
        await tokenContract.increaseApproval(
            NFTContract.address,2,0,
            10, {
              from: user3,
            },
          )
          console.log(await tokenContract.balanceOf(user3,2));
        await NFTContract.withdrawAttached(2,{from:user3})
        console.log(await tokenContract.allowance(user3,NFTContract.address,2))
        await tokenContract.decreaseApproval(
          NFTContract.address,2,9,
          4, {
            from: user3,
          },
        )
        console.log(await tokenContract.allowance(user3,NFTContract.address,2))
        assert.equal(await tokenContract.allowance(user3,NFTContract.address,2),5,"approval decreased to 5")
        await tokenContract.decreaseApproval(
          NFTContract.address,2,9,
          6, {
            from: user3,
          },
        )
        assert.equal(await tokenContract.allowance(user3,NFTContract.address,2),0,"approval decreased to 5")
    })






})