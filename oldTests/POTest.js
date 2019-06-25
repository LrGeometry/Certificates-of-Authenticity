const PO = artifacts.require('POToken.sol');
let RFQ=artifacts.require('RFQToken.sol')

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
 function sleep(ms){
        return new Promise(resolve=>{
            setTimeout(resolve,ms)
            console.log("sleeping")
        })
    }
let POToken
let RFQToken
 PO.deployed().then((result)=>{
   POToken=result
 })
RFQ.deployed().then((result)=>{
    RFQToken=result
  })
console.log(POToken)  
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
RFQstruct={DeliveryTerms:2,CustomClearance:3,UNDPprefered:'something',LatestExpectedDeliveryData:true,
DeliverySchedule:true,ModeOfTransport:2,AfterSalesService:3,Deadline:12312,DocumentationLanguage:5,PeriodOfValidity:20,PartialQuotes:true,
PaymentTerms:4,Awardees:5,ConctractType:2,CancelationPolicy:true, ConditionsOfRelease:3,Contract:'this is a contract',EquivalentSubstitution:'some stuff'}
it('mints an RFQtoken',async function(){
   
    await RFQToken.mintRFQ(accounts[1],RFQstruct)
    //console.log('minted')
})
it('deploys two POtokens with correct metadata', async function(){  
    
    console.log(accounts[1])
    await POToken.MintPO(to,names,ids,qty,price,discount,total,DD,PurchaseParams,1,{from:accounts[1]})
  // await sleep(8000)
    //await POToken.MintPO(accounts[3],names1,ids1,qty,price,discount,total,DD,PurchaseParams2,2,{from:accounts[1]})
   
    })
 /*it('can transfer a token', async function(){
  'safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)'
   await POToken.safeTransferFrom(accounts[2],accounts[3],1,1,'0x0',{from:accounts[2]})
   console.log(await POToken.balanceOf(accounts[3],1))
 })
 */   
});