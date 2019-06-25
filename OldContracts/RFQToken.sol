/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
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
  mapping(uint=>bool) public isRFQ;

 

  constructor(address _token) Managable(_token) public {
    
  }

 function mintRFQ(address to,RequestForQuotation memory R) onlyMinter() public  returns (bool){
   uint nonce= Token.createfor(1,"this is a RFQToken",to,"RequestForQuotation","RFQ");
    RequestsForQuotation[nonce]=R;
   isRFQ[nonce]=true;
    TimeStamp[nonce]=now;
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
  require(isRFQ[rfq]==true);
  RequestsForQuotation[rfq].EquivalentSubstitution=newData;
}

}
