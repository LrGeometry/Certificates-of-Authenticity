/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';

contract PRToken is Managable {

struct Item{
    uint stockNumber;
    string description;
    uint   QTY;
    uint unitPrice;
    uint extendedCost;
    
  }

  struct PurchaseRequest{
    uint Date;
    string Requester;
    string Department;
    string ChargeTo;
    string Vendor;
    string VendorAddress;
    string VendorContact;
    uint phone;
    uint DateNeeded;
    string shipVia;
  }


 
   modifier isClient(uint order){
    require(Client[msg.sender][order]==true);
    _;
  }
   modifier isManger(uint order){
    require(Manager[msg.sender][order]==true);
    _;
  }
  
  mapping(uint=>PurchaseRequest) private PurchaseRequests;

  mapping(uint=>Item[]) private Items;
  mapping(uint=>bool) isPR;
  constructor(address a) Managable(a) public {
  }

  function mint(address to,uint[] memory stockNumbers, string[] memory ItemDescriptions, uint[] memory  itemQTYS,uint[] memory itemUnitPrices,
    uint[] memory  itemExtendedCosts,string[] memory  PRprops,uint[] memory PRintprops ) onlyMinter() public  returns (bool) {
        
        uint nonce=Token.createfor(1,"this is a PRToken",to, "PurchaseRequest","PR");
         Item memory TempItem;
          PurchaseRequests[nonce]=PurchaseRequest(PRintprops[0],PRprops[0],PRprops[1],
          PRprops[2],PRprops[3],PRprops[4],PRprops[5],PRintprops[1],PRintprops[2],PRprops[6]);

        for(uint i=0;i<itemQTYS.length;i++){

           TempItem=Item( stockNumbers[i],ItemDescriptions[i],itemQTYS[i],itemUnitPrices[i],itemExtendedCosts[i]);

            Items[nonce].push(TempItem);
        }
        
         
        return true;
    }
 function getTotalItems(uint order) public view Viewable(order) returns(Item[] memory){
      return Items[order];
    }

 function getPurchaseRequestInfo(uint order) public view Viewable(order) returns(PurchaseRequest memory){
    
     return(PurchaseRequests[order]);
  }


  /**function getPRinfo(uint order) returns(uint ,string memory,string memory,string memory,
      string memory,string memory,string memory,uint,uint,string memory){
   return()
  }**/  
}