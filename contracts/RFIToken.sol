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

  uint createdTokens=0;

  modifier isTokenOwner( uint order){
    require(ownerOf(order)==msg.sender);
    _;
  }

  constructor() Managable("RequestForInformation" , "RFI") public {
    
  }

 function mintRFI(address to,RequestForInformation memory R) onlyMinter() public  returns (bool){
     createdTokens+=1;
     RequestsForInformation[createdTokens]=R;
     _mint(to,createdTokens);
 }
function getRFI(uint id) Viewable(id) public view returns(RequestForInformation memory){
  return RequestsForInformation[id];
}
 function alterData(string memory data,uint Request) isTokenOwner( Request) public {
  RequestForInformation storage R =RequestsForInformation[Request];
  R.Data=data;
 }
  function changeEquivalentSubstitution(uint rfi, string memory newData) public isTokenOwner(rfi){
  RequestsForInformation[rfi].EquivalentSubstitution=newData;
}
}