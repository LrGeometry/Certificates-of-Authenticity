pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';

contract BLToken is ERC721Full, ERC721Mintable {


  struct Bill_Of_Lading{
  uint Lading;
  uint Order;

  uint PO;
  uint date;  
  string Carrier;
  string Shipper;
  string Consignee;
  string Instructions;
  }
  struct Item{
  uint ItemCode;
  uint Quantity;
  uint Weight;
  string Details;
  }
  uint createdTokens=0;
   
  mapping(uint=>Bill_Of_Lading) public Bill_Of_Ladings;

  mapping(uint=>Item[]) public Items;
  mapping(uint=>mapping(uint=>bool)) CarrierSigned;
  mapping(uint=>mapping(uint=>bool)) ShipperSigned;

  constructor() Managable("BL", "Bill of Lading") public {
  }

  function mint(address to,uint[] memory intLadingParams,string[] memory stringLadingParams,uint[] memory ItemCodes,
    uint[] memory Quantities,uint[] memory Weights,string[] memory Details ) onlyMinter() public  returns (bool) {
        
        _mint(to, createdTokens+1);
         Item memory TempItem;
          PurchaseRequests[createdTokens+1]=PurchaseRequest(intLadingParams[0],intLadingParams[1],intLadingParams[2],now,
          stringLadingParams[0],stringLadingParams[1],stringLadingParams[2],stringLadingParams[3]);

        for(uint i=0;i<Quantities.length;i++){

           TempItem=Item(ItemCodes[i],Quantities[i],Weights[i],Details[i]);

            Items[createdTokens+1].push(TempItem);
        }
        
         createdTokens+=1;
        return true;
    }
  function getTotalItems(uint order) public view Viewable(order) returns(Item[]){
    return Items[order]
  }  
   function getBill_Of_LadingInfo(uint order) public view Viewable(order) returns(Bill_Of_Lading memory){
    
     return(Bill_Of_Lading[order]);
  } 
  function signAsCarrier(uint order,uint date) public {
    CarrierSigned[order][date]=true;
  }
   function signAsShippter(uint order,uint date) public {
    ShipperSigned[order][date]=true;
  }
}