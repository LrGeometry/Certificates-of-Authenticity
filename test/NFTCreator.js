const NFT = artifacts.require('NFTCreator');
const Token= artifacts.require('HERC1155')



before(async () => {
    user1 = accounts[0];
    user2 = accounts[2];
    user3 = accounts[3];
    user4 = accounts[4];
    mainContract = await NFT.deployed();
    tokenContract= await Token.deployed()
    
});

it("tests the NFT creator",(accounts)=>{










})