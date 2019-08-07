const FUTURIST= artifacts.require('Futurist')

contract("tests the NFT creator",(accounts)=>{
    before(async () => {
        user1 = accounts[0];
        user2 = accounts[1];
        user3 = accounts[2];
        user4 = accounts[3];
        
        FT=await FUTURIST.deployed();
        
    });

    it('changes admin and removes msg.sender as admin',async()=>{
      await FT.addAdmin(user2,{from:user1})
      await FT.renounceAdmin({from:user1})
      assert.equal(await FT.isAdmin(user2),true,'user2 is an admin')
      assert.equal(await FT.isAdmin(user1),false,'user1 is not an admin')
    })
    it('can adjust points from an admin account',async()=>{
        await FT.addPoints(10,27,{from:user2})
        assert.equal(await FT.FuturistPoints(27),10,'points were added properly')
        await FT.addPoints(10,27,{from:user2})
        assert.equal(await FT.FuturistPoints(27),20,'points were added properly again')
    })

})