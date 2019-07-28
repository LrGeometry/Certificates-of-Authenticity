


const PR = artifacts.require('PRToken.sol');


contract('PRTest',function(accounts){
/**
 * Purchase Request Data
 *   uint Date;
    string Requester;
    string Department;
    string ChargeTo;
    string Vendor;
    string VendorAddress;
    string VendorContact;
    uint phone;
    uint DateNeeded;
    string shipVia;
 * 
 */
/**
 * ITEM
 *  uint stockNumber;
    string description;
    uint   QTY;
    uint unitPrice;
    uint extendedCost;
 */
let PRToken
 PR.deployed().then((result)=>{
    PRToken=result
})
let descriptions=['gold','silver']
let stockNumber=[1,2]
let qty=[100,200]
let unitprices=[4,6]
let extendedprice=[4000,6000]
let Date=2983742897

let PurchaseRequestStringParams=['Steve','accounting','Stevenson','Selling Stuff LLC','234 bird st, Portland OR','something@gmail.com','UPS']
let PurchaseRequestIntParams=[110119,3202345672,110219]

let PurchaseRequestStringParams2=['Stevo','finance','Stevenoson','Buyting Stuff LLC','432 bird st, Denver CO','nothing@gmail.com','USPS']
let PurchaseRequestIntParams2=[110219,3202345682,110419]
let to =accounts[2]
it('deploys two PRtokens', async function(){  
//console.log(PRToken)


//address to,stockNumber, string[] memory ItemDescriptions, uint[] memory  itemQTYS,uint[] memory itemUnitPrices,
//uint[] memory  itemExtendedCosts,string[] memory  PRprops,uint[] memory PRintprops
await PRToken.mint(to,stockNumber,descriptions,qty,unitprices, extendedprice,PurchaseRequestStringParams,PurchaseRequestIntParams)
await PRToken.mint(to,stockNumber,descriptions,qty,unitprices, extendedprice,PurchaseRequestStringParams2,PurchaseRequestIntParams2)
})
it('purchase request has correct data', async function(){  
let Req=await PRToken.getPurchaseRequestInfo(1,{from:to})


//console.log(Req)
//console.log(Item)
//console.log(Item1)
assert.equal(Req.Date,PurchaseRequestIntParams[0],'correct date')
assert.equal(Req.Department,PurchaseRequestStringParams[1],'corect department')
assert.equal(Req.ChargeTo,PurchaseRequestStringParams[2],'correct ChargeTo')
assert.equal(Req.Vendor,PurchaseRequestStringParams[3],'correct Vendor')
assert.equal(Req.VendorAddress,PurchaseRequestStringParams[4],'correct VendorAddress')
assert.equal(Req.VendorContact,PurchaseRequestStringParams[5],'correct VendorContact')
assert.equal(Req.phone,PurchaseRequestIntParams[1],'correct phone number')
assert.equal(Req.DateNeeded,PurchaseRequestIntParams[2],'correct date needed')
assert.equal(Req.shipVia,PurchaseRequestStringParams[6],'correct ship via')
})
it('Items have correct metadata', async function(){  
let Item=await PRToken.getTotalItems(1,{from:to})
let Item1=Item[0]
console.log(Item1)
let Item2=Item[1]
console.log(Item2)
assert.equal(Item1[0],stockNumber[0],'correct stock number')
assert.equal(Item1[1],descriptions[0],'correct description')
assert.equal(Item1[2],qty[0],'correct stock number')
assert.equal(Item1[3],unitprices[0],'correct stock number')
assert.equal(Item1[4],extendedprice[0],'correct stock number')

assert.equal(Item2[0],stockNumber[1],'correct stock number')
assert.equal(Item2[1],descriptions[1],'correct description')
assert.equal(Item2[2],qty[1],'correct stock number')
assert.equal(Item2[3],unitprices[1],'correct stock number')
assert.equal(Item2[4],extendedprice[1],'correct stock number')
})
it('second purchase request has correct data', async function(){  
let Req=await PRToken.getPurchaseRequestInfo(2,{from:to})
assert.equal(Req.Date,PurchaseRequestIntParams2[0],'correct date')
assert.equal(Req.Department,PurchaseRequestStringParams2[1],'corect department')
assert.equal(Req.ChargeTo,PurchaseRequestStringParams2[2],'correct ChargeTo')
assert.equal(Req.Vendor,PurchaseRequestStringParams2[3],'correct Vendor')
assert.equal(Req.VendorAddress,PurchaseRequestStringParams2[4],'correct VendorAddress')
assert.equal(Req.VendorContact,PurchaseRequestStringParams2[5],'correct VendorContact')
assert.equal(Req.phone,PurchaseRequestIntParams2[1],'correct phone number')
assert.equal(Req.DateNeeded,PurchaseRequestIntParams2[2],'correct date needed')
assert.equal(Req.shipVia,PurchaseRequestStringParams2[6],'correct ship via')
})
it('Items have correct metadata', async function(){  
    let Items=await PRToken.getTotalItems(1,{from:to})
    let Item2=Items[1]
    let Item1=Items[0]
    assert.equal(Item1[0],stockNumber[0],'correct stock number')
    assert.equal(Item1[1],descriptions[0],'correct description')
    assert.equal(Item1[2],qty[0],'correct stock number')
    assert.equal(Item1[3],unitprices[0],'correct stock number')
    assert.equal(Item1[4],extendedprice[0],'correct stock number')
    
    assert.equal(Item2[0],stockNumber[1],'correct stock number')
    assert.equal(Item2[1],descriptions[1],'correct description')
    assert.equal(Item2[2],qty[1],'correct stock number')
    assert.equal(Item2[3],unitprices[1],'correct stock number')
    assert.equal(Item2[4],extendedprice[1],'correct stock number')
    })

});
     