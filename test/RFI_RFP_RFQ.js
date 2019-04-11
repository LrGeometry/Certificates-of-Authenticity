

let RFI=artifacts.require('RFIToken.sol')
let RFQ=artifacts.require('RFQToken.sol')
let RFP=artifacts.require('RFPToken.sol')



contract('RFQ/RFP/RF',   function(accounts){
/** string CompanyName;
      string Logo;
      string PointofContact;
      address ETHAddress;
      uint TimeStamp;
      uint GeoLocation;
      string Data;
 */
RFIstruct={CompanyName:'ADIDAS',Logo:'Sfsd',PointofContact:'somewher',ETHAddress:'0x9E57b57C41D73E01fD2A7cfEeD9428C9BDEfa91E',TimeStamp:123234,GeoLocation:2374823,Data:'some data',EquivalentSubstitution:'some stuff' }
/**string CompanyName; 
    string AddressParcel;
    string Requirement;
    uint Deadline; 
    string AcceptanceCriteria;
    uint ModeofTransport;
    string ContactEmail;
    uint  Budget; */

RFPstruct={CompanyName:'Nike',AddressParcel:'the parcel address',Requirement:'some requirement',Deadline:23423432,AcceptanceCriteria:'this should be accepted',
ModeofTransport:2,ContactEmail:'something@gmail.com',Budget:10000,EquivalentSubstitution:'some stuff' }
/** uint DeliveryTerms;
     uint CustomClearance;
     string UNDPprefered;
     bool LatestExpectedDeliveryData;
     bool DeliverySchedule;
     uint ModeOfTransport; 
     uint AfterSalesService;
     uint Deadline;
     uint DocumentationLanguage;
     uint PeriodOfValidity;
     bool PartialQuotes;
     uint PaymentTerms;
     uint Awardees;
     uint ConctractType;
     bool CancelationPolicy;
     uint ConditionsOfRelease;
     string Contract; */
RFQstruct={DeliveryTerms:2,CustomClearance:3,UNDPprefered:'something',LatestExpectedDeliveryData:true,
DeliverySchedule:true,ModeOfTransport:2,AfterSalesService:3,Deadline:12312,DocumentationLanguage:5,PeriodOfValidity:20,PartialQuotes:true,
PaymentTerms:4,Awardees:5,ConctractType:2,CancelationPolicy:true, ConditionsOfRelease:3,Contract:'this is a contract',EquivalentSubstitution:'some stuff'}
//console.log(RFP)
let RFIinstance
let RFPinstance
let RFQinstance
RFI.deployed().then((res)=>{
    RFIinstance=res
})
RFQ.deployed().then((res)=>{
    RFQinstance=res
})
RFP.deployed().then((res)=>{
    RFPinstance=res
})
it('mints an RFI token',async function(){
   
    await RFIinstance.mintRFI(accounts[1],RFIstruct)
    //console.log('minted')
})
it('mints an RFPtoken',async function(){
   //console.log(RFPstruct)
    await RFPinstance.mintRFP(accounts[1],RFPstruct)
    //console.log('minted')
})
it('mints an RFQtoken',async function(){
   
    await RFQinstance.mintRFQ(accounts[1],RFQstruct)
    //console.log('minted')
})
it('returns rfi metadata correctly',async function(){
   
   let rfi=await RFIinstance.getRFI(1,{from:accounts[1]})
   //console.log(rfi)
   //console.log(Object.keys(RFIstruct))
    Object.keys(RFIstruct).forEach((key)=>{
    //console.log(key)
    //console.log(rfi[key],'ret key')
    //console.log(RFIstruct[key],'struct key')
       assert.equal(RFIstruct[key],rfi[key],'meta data returns correctly')
   } )
    
})
it('returns rfp metadata correctly',async function(){
   
    let rfp=await RFPinstance.getRFP(1,{from:accounts[1]})
   //console.log(rfp)
    Object.keys(RFPstruct).forEach((key)=>{
        //console.log(key)
       // console.log(rfp[key],'ret key')
       // console.log(RFPstruct[key],'struct key')
           assert.equal(RFPstruct[key],rfp[key],'meta data returns correctly')
       } )
     
 })
 it('returns rfq metadata correctly',async function(){
   
    let rfq=await RFQinstance.getRFQ(1,{from:accounts[1]})
   
    Object.keys(RFQstruct).forEach((key)=>{
        //console.log(key)
        //console.log(rfq[key],'ret key')
       // console.log(RFQstruct[key],'struct key')
           assert.equal(RFQstruct[key],rfq[key],'meta data returns correctly')
       } )
     
 })

it('changes RFQ ES data',async function(){
    await RFQinstance.changeEquivalentSubstitution(1,'some changed data(*(()',{from:accounts[1]})
    let rfq=await RFQinstance.getRFQ(1,{from:accounts[1]})
    assert.equal('some changed data(*(()',rfq.EquivalentSubstitution,'meta data returns correctly')

})
it('changes RFP ES data',async function(){
    await RFPinstance.changeEquivalentSubstitution(1,'some changed data(*(()',{from:accounts[1]})
    let rfp=await RFPinstance.getRFP(1,{from:accounts[1]})
    assert.equal('some changed data(*(()',rfp.EquivalentSubstitution,'meta data returns correctly')

})
it('changes RFI ES data',async function(){
    await RFIinstance.changeEquivalentSubstitution(1,'some changed data(*(()',{from:accounts[1]})
    let rfi=await RFIinstance.getRFI(1,{from:accounts[1]})
    assert.equal('some changed data(*(()',rfi.EquivalentSubstitution,'meta data returns correctly')

})


});