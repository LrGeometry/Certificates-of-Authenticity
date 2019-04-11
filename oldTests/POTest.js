
const PO = artifacts.require('POToken.sol');


contract('POTest',function(accounts){
//address to, string[] memory _names,bytes32[] memory _codes,uint[] memory _QTY,uint[] memory _price,uint[] memory _discount,uint[] memory _total,
  //      uint  _DeliveryDate,string[] memory PurchaseOrderParams

 /**
  * PurchaseOrder
  * uint DeliveryDate;
    string Requester;
    string Approver;
    string Department;
    string Notes; */ 
let POToken
 PO.deployed().then((result)=>{
   POToken=result
 })
let names=['this is the first item','item2']
let ids=['0x23234234','0x87234234']
let names1=['item']
let ids1=['0x23234234']
let qty=[100,200]
let price=[4,6]
let discount=[1,1]
let total=[3,5]
let DD=2983742897
let PurchaseParams=['steve','john','stuff','something that is a very long note for this order today and yesterday tooo']
let PurchaseParams2=['stevo','johnny','otherstuff','something that is a very longer note for this order today and yesterday tooo']
let to =accounts[2]
it('deploys two POtokens with correct metadata', async function(){  

await POToken.MintPO(to,names,ids,qty,price,discount,total,DD,PurchaseParams,{from:accounts[0]})
await POToken.MintPO(accounts[3],names1,ids1,qty,price,discount,total,DD,PurchaseParams2,{from:accounts[0]})
//console.log(await POToken.getTotalItems(1))
let Items=await POToken.getTotalItems(1)
let OrderInfo=await POToken.getOrderInfo(1)
console.log(OrderInfo[0])
console.log(Items[0].name)
console.log(Items[1].name)
})

 it('Items have the  correct metadata', async function(){  
let Items=await POToken.getTotalItems(1)
let Item2=Items[1]
let Item1=Items[0]
assert.equal(Item2.name,'item2','correctname')
assert.equal(Item2.code,'0x8723423400000000000000000000000000000000000000000000000000000000','correct code')
assert.equal(Item2.QTY,200,'quantity is correct')
assert.equal(Item2.price,6,'price is correct')
assert.equal(Item2.discount,1,'discount is correct')
assert.equal(Item2.total,5,'total is correct')

assert.equal(Item1.name,'this is the first item','correctname')                    
assert.equal(Item1.code,'0x2323423400000000000000000000000000000000000000000000000000000000','correct code for item2')
assert.equal(Item1.QTY,100,'quantity is correct')
assert.equal(Item1.price,4,'price is correct')
assert.equal(Item1.discount,1,'discount is correct')
assert.equal(Item1.total,3,'total is correct')
})
it(' Purchase orders have the correct metadata', async function(){  
let OrderInfo=await POToken.getOrderInfo(1)
//console.log(OrderInfo)
assert.equal(OrderInfo[0],DD,'correct date')
assert.equal(OrderInfo[1],'steve','correct requester')
assert.equal(OrderInfo[2],'john','correct approver')
assert.equal(OrderInfo[3],'stuff','correct department')
assert.equal(OrderInfo[4],'something that is a very long note for this order today and yesterday tooo','correct Notes')
OrderInfo=await POToken.getOrderInfo(2)
//console.log(OrderInfo)
assert.equal(OrderInfo[0],DD,'correct date')
assert.equal(OrderInfo[1],'stevo','correct requester')
assert.equal(OrderInfo[2],'johnny','correct approver')
assert.equal(OrderInfo[3],'otherstuff','correct department')
assert.equal(OrderInfo[4],'something that is a very longer note for this order today and yesterday tooo','correct Notes')
})
it(' Purchase order notes can be changed', async function(){ 
await POToken.alterNote(1,'new string**********',{from:accounts[2]})
let OrderInfo=await POToken.getOrderInfo(1)
//console.log(await POToken.getOrderInfo(1))
assert.equal(OrderInfo[4],'new string**********','new note is set')
})

});
     