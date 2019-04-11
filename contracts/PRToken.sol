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
  uint createdTokens=0;

  modifier isTokenOwner( uint order){
    require(ownerOf(order)==msg.sender);
    _;
  }
   modifier isClient(uint order){
    require(Client[msg.sender][order]==true);
    _;
  }
   modifier isManger(uint order){
    require(Manager[msg.sender][order]==true);
    _;
  }
  mapping(address=>mapping(uint=>bool)) public Client;
  
  mapping(address=>mapping(uint=>bool)) public Manager;

  mapping(uint=>PurchaseRequest) private PurchaseRequests;

  mapping(uint=>Item[]) private Items;

  constructor() Managable( "PurchaseRequest","PR") public {
  }

  function mint(address to,uint[] memory stockNumbers, string[] memory ItemDescriptions, uint[] memory  itemQTYS,uint[] memory itemUnitPrices,
    uint[] memory  itemExtendedCosts,string[] memory  PRprops,uint[] memory PRintprops ) onlyMinter() public  returns (bool) {
        
        _mint(to, createdTokens+1);
         Item memory TempItem;
          PurchaseRequests[createdTokens+1]=PurchaseRequest(PRintprops[0],PRprops[0],PRprops[1],
          PRprops[2],PRprops[3],PRprops[4],PRprops[5],PRintprops[1],PRintprops[2],PRprops[6]);

        for(uint i=0;i<itemQTYS.length;i++){

           TempItem=Item( stockNumbers[i],ItemDescriptions[i],itemQTYS[i],itemUnitPrices[i],itemExtendedCosts[i]);

            Items[createdTokens+1].push(TempItem);
        }
        
         createdTokens+=1;
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