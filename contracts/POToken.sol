pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './Managable.sol';
import './RFQToken.sol';
contract POToken is Managable {

  struct Item{
    string name;
    bytes32 code;
    uint   QTY;
    uint price;
    uint discount;
    uint total;
  }

  struct PurchaseOrder{
    uint DeliveryDate;
    string Requester;
    string Approver;
    string Department;
    string Notes;

  }
  mapping(uint=>PurchaseOrder) private PurchaseOrders;

  mapping(uint=>bool) completionStatus;

  mapping(uint=>Item[]) private Items;

  uint createdTokens=0;
  RFQToken RFQ;
  constructor(address a) Managable( "PurchaseOrder","PO") public {
    RFQ=RFQToken(a);
  }

  function MintPO(address to, string[] memory _names,bytes32[] memory _codes,uint[] memory _QTY,uint[] memory _price,uint[] memory 
    _discount,uint[] memory _total,uint  _DeliveryDate,string[] memory PurchaseOrderParams,uint _RFQ )  public  returns (bool) {
  require(RFQ.ownerOf(_RFQ)==msg.sender);

  if (RFQ.getCancelationPolicy(_RFQ)==true){
    if(now>RFQ.getTimeStamp(_RFQ)+20*86400)
      revert();
   }  

        _mint(to, createdTokens+1);
       
        completionStatus[createdTokens+1]=false;
        PurchaseOrders[createdTokens+1]=PurchaseOrder(_DeliveryDate,PurchaseOrderParams[0],PurchaseOrderParams[1],PurchaseOrderParams[2],PurchaseOrderParams[3]);
        Item memory TempItem;
        for(uint i=0;i<_names.length;i++){
            TempItem=Item(_names[i],_codes[i],_QTY[i],_price[i],_discount[i],_total[i]);
            Items[createdTokens+1].push(TempItem);
        }
         createdTokens+=1;
        return true;
    }

    function getOrderInfo(uint order) public view returns(PurchaseOrder memory){

     return(PurchaseOrders[order]);
    }
   
    function getTotalItems(uint order) public view returns(Item[] memory){
      return Items[order];
    }

    function alterNote(uint order,string memory s) public{
      require(ownerOf(order)==msg.sender);
      PurchaseOrder storage PO=PurchaseOrders[order];
      PO.Notes=s;
    }
}