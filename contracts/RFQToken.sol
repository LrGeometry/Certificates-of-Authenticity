pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';

contract RFQToken is Managable {

  /**Delivery Terms
Customs clearence
Exact Address
UNDP Preffered Freight Forwarder
Last Expected Delivery Date and Time
Delivery Schedule 
Mode of Transport
After Sales Service Required
Deadline for Quotation ( end date of bidding) 
Documentation Language
Period of Validity of Quotes
Patial Quotes
Payment Terms
Amount of Awardees
Type of Contract to be signed
Special Conditions (cancelation policy)
Conditions of Release 
Contact perso */

  struct RequestForQuotation{
     uint DeliveryTerms;
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
     string Contract;
     string EquivalentSubstitution;

  }
  mapping(uint=>RequestForQuotation) private RequestsForQuotation;
  mapping(uint=>uint) private TimeStamp;
  uint createdTokens=0;

  modifier isTokenOwner( uint order){
    require(ownerOf(order)==msg.sender);
    _;
  }

  constructor() Managable("RequestForQuotation" , "RFQ") public {
    
  }

 function mintRFQ(address to,RequestForQuotation memory R) onlyMinter() public  returns (bool){
  createdTokens+=1;
  RequestsForQuotation[createdTokens]=R;
  _mint(to,createdTokens);
  TimeStamp[createdTokens]=now;
  return true;
 }
function getRFQ(uint rfq) Viewable(rfq) public view returns(RequestForQuotation memory){
  return  RequestsForQuotation[rfq];
 }

function getCancelationPolicy(uint rfq)  public view returns(bool){
  return RequestsForQuotation[rfq].CancelationPolicy;
}
function getTimeStamp(uint rfq) public view returns(uint){
  return TimeStamp[rfq];
}
function changeEquivalentSubstitution(uint rfq, string memory newData) public isTokenOwner(rfq){
  RequestsForQuotation[rfq].EquivalentSubstitution=newData;
}
}
