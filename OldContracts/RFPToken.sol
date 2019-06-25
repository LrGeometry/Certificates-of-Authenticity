pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';

contract RFPToken is Managable {

  /**This should metadata such as ; 
Company Name, Logo, Point of Contact, 0xaddress, Time Stamp, GeoLocation, & FreeForm Text Box for Requester and Responder */

  struct RequestForProposal{
    string CompanyName; 
    string AddressParcel;
    string Requirement;
    uint Deadline; 
    string AcceptanceCriteria;
    uint ModeofTransport;
    string ContactEmail;
    uint  Budget;
    string EquivalentSubstitution;
  }
  mapping(uint=> RequestForProposal) private  RequestsForProposal;
  mapping(uint=>bool) public isRFP;
 

  

  constructor(address _token) Managable(_token) public {
    
  }

 function mintRFP(address to, RequestForProposal memory R) onlyMinter() public  returns (bool){
   
     uint nonce=Token.createfor(1,"this is a RFPToken",to,"RequestForProposal","RFP");
      RequestsForProposal[nonce]=R;
      isRFP[nonce]=true;
 }
function getRFP(uint rfp) Viewable(rfp) public view returns(RequestForProposal memory){
  return  RequestsForProposal[rfp];
 }
function changeEquivalentSubstitution(uint rfp, string memory newData) public isTokenOwner(rfp){
  require(isRFP[rfp]==true);
  RequestsForProposal[rfp].EquivalentSubstitution=newData;
}
}