/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';

contract RFIToken is Managable {

  /**This should metadata such as ; 
Company Name, Logo, Point of Contact, 0xaddress, Time Stamp, GeoLocation, & FreeForm Text Box for Requester and Responder */

  struct RequestForInformation{
      string CompanyName;
      string Logo;
      string PointofContact;
      address ETHAddress;
      uint TimeStamp;
      uint GeoLocation;
      string Data;
      string EquivalentSubstitution;

  }
  mapping(uint=>RequestForInformation) private RequestsForInformation;
  mapping(uint=>bool) public isRFI;
 



  constructor(address _token) Managable(_token) public {
    
  }

 function mintRFI(address to,RequestForInformation memory R) onlyMinter() public  returns (bool){
    uint nonce = Token.createfor(1,"this is a PRToken",to,"RequestForInformation","RFI");
     RequestsForInformation[nonce]=R;
     isRFI[nonce]=true;
    
 }
function getRFI(uint id) Viewable(id) public view returns(RequestForInformation memory){
  return RequestsForInformation[id];
}
 function alterData(string memory data,uint Request) isTokenOwner( Request) public {
   require(isRFI[Request]==true);
  RequestForInformation storage R =RequestsForInformation[Request];
  R.Data=data;
 }
  function changeEquivalentSubstitution(uint rfi, string memory newData) public isTokenOwner(rfi){
  require(isRFI[rfi]==true);
  RequestsForInformation[rfi].EquivalentSubstitution=newData;
}
}