pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';

contract BLToken is Managable {


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
   
  mapping(uint=>Bill_Of_Lading) private Bill_Of_Ladings;

  mapping(uint=>Item[]) private Items;
  mapping(address=>mapping(uint=>uint)) private CarrierSigned;
  mapping(address=>mapping(uint=>uint)) private ShipperSigned;

  constructor() Managable("Bill of Lading","BOL") public {
  }

  function mint(address to,uint[] memory intLadingParams,string[] memory stringLadingParams,uint[] memory ItemCodes,
    uint[] memory Quantities,uint[] memory Weights,string[] memory Details ) onlyMinter() public  returns (bool) {
        
        _mint(to, createdTokens+1);
         Item memory TempItem;
          Bill_Of_Ladings[createdTokens+1]=Bill_Of_Lading(intLadingParams[0],intLadingParams[1],intLadingParams[2],now,
          stringLadingParams[0],stringLadingParams[1],stringLadingParams[2],stringLadingParams[3]);

        for(uint i=0;i<Quantities.length;i++){

           TempItem=Item(ItemCodes[i],Quantities[i],Weights[i],Details[i]);

            Items[createdTokens+1].push(TempItem);
        }
        
         createdTokens+=1;
        return true;
    }
  function getTotalItems(uint order) public view Viewable(order) returns(Item[] memory){
    return Items[order];
  }  
   function getBillOfLadingInfo(uint order) public view Viewable(order) returns(Bill_Of_Lading memory){
    
     return(Bill_Of_Ladings[order]);
  }

  function signAsCarrier(uint order,uint date) public {
    CarrierSigned[msg.sender][order]=date;
  }
   function signAsShipper(uint order,uint date) public {
    ShipperSigned[msg.sender][order]=date;
  }
  function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        require(CarrierSigned[from][tokenId]>now);
        require(ShipperSigned[to][tokenId]>now);
        _transferFrom(from, to, tokenId);
    }
}