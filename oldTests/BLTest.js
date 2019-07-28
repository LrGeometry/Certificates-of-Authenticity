const BL = artifacts.require('BLToken.sol');


contract('BLTest',function(accounts){

let BLToken
 BL.deployed().then((result)=>{
    BLToken=result
})
let ItemCodes=[100,200]
let qtys=[1000,3000]
let weights=[200,600]
let details=['a pretty cool thing','a prettier cooler thing']
/**
 *  struct Bill_Of_Lading{
  uint Lading;
  uint Order;

  uint PO;
  uint date;  
  string Carrier;
  string Shipper;
  string Consignee;
  string Instructions;
  }
  */
let StringParams=['Alice','Bob','Stevenson','do this shit incorrectly']
let IntParams=[110119,3202345672,22222]

let StringParams2=['Alice','Bob','Steve','do this shit correctly']
let IntParams2=[110219,32023,110419]
let to =accounts[2]
it('deploys two BLtokens', async function(){  

/**(address to,uint[] memory intLadingParams,string[] memory stringLadingParams,uint[] memory ItemCodes,
    uint[] memory Quantities,uint[] memory Weights,string[] memory Details 
    struct Item{
  uint ItemCode;
  uint Quantity;
  uint;
  string Details;t Weigh
  } */


await BLToken.mint(to,IntParams,StringParams,ItemCodes,qtys,weights,details)
await BLToken.mint(to,IntParams2,StringParams2,ItemCodes,qtys,weights,details)
})
it('Lading has correct data', async function(){  
let lading=await BLToken.getBillOfLadingInfo(1,{from:to})



assert.equal(lading.Carrier,StringParams[0],'correct ship via')
assert.equal(lading.Shipper,StringParams[1],'corect department')
assert.equal(lading.Consignee,StringParams[2],'correct ChargeTo')
assert.equal(lading.Instructions,StringParams[3],'correct Vendor')
assert.equal(lading.Lading,IntParams[0],'correct date')
assert.equal(lading.Order,IntParams[1],'correct phone number')
assert.equal(lading.PO,IntParams[2],'correct date needed')
//assert.equal(lading.date,IntParams[3],'correct date needed')
})
it('Items have correct metadata', async function(){  
    let Items=await BLToken.getTotalItems(1,{from:to})
    assert.equal(Items[0].ItemCode,ItemCodes[0],'correct code')
    assert.equal(Items[0].Quantity,qtys[0],'corect qty')
    assert.equal(Items[0].Weight,weights[0],'correct weights')
    assert.equal(Items[0].Details,details[0],'correct Vendor')
})
it('second Ladign  has correct data', async function(){  
    let lading=await BLToken.getBillOfLadingInfo(2,{from:to})



    assert.equal(lading.Carrier,StringParams2[0],'correct ship via')
    assert.equal(lading.Shipper,StringParams2[1],'corect department')
    assert.equal(lading.Consignee,StringParams2[2],'correct ChargeTo')
    assert.equal(lading.Instructions,StringParams2[3],'correct Vendor')
    assert.equal(lading.Lading,IntParams2[0],'correct date')
    assert.equal(lading.Order,IntParams2[1],'correct phone number')
    assert.equal(lading.PO,IntParams2[2],'correct date needed')
   // assert.equal(lading.date,IntParams2[3],'correct date needed')
})
it('Tokens can be transfered', async function(){  
    
    })

});
     