/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
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
  mapping(uint=>bool)  public isPO;
  
  RFQToken RFQ;
  constructor(address a,address b) Managable(b) public {
    RFQ=RFQToken(a);
  }

 modifier hasRFQ(uint id){
  require((RFQ.getTimeStamp(id)>0) &&(Token.balanceOf(msg.sender,id)>0));
  _;
 }
  function MintPO(address to, string[] memory _names,bytes32[] memory _codes,uint[] memory _QTY,uint[] memory _price,uint[] memory 
    _discount,uint[] memory _total,uint  _DeliveryDate,string[] memory PurchaseOrderParams,uint _RFQ )  hasRFQ(_RFQ) public  returns (bool) {
  //require(RFQ.balanceOf(msg.sender,_RFQ)>=1);

  if (RFQ.getCancelationPolicy(_RFQ))
    if(now>RFQ.getTimeStamp(_RFQ)+20*86400)
      revert();
    

      uint nonce= Token.createfor(1,"this is a POToken",to,"Purchase Order","PO");
         
        completionStatus[nonce]=false;
        PurchaseOrders[nonce]=PurchaseOrder(_DeliveryDate,PurchaseOrderParams[0],PurchaseOrderParams[1],PurchaseOrderParams[2],PurchaseOrderParams[3]);
        Item memory TempItem;
        for(uint i=0;i<_names.length;i++){
            TempItem=Item(_names[i],_codes[i],_QTY[i],_price[i],_discount[i],_total[i]);
            Items[nonce].push(TempItem);
        }
         
        return true;
    }

    function getOrderInfo(uint order) public view returns(PurchaseOrder memory){

     return(PurchaseOrders[order]);
    }
   
    function getTotalItems(uint order) public view returns(Item[] memory){
      return Items[order];
    }

    function alterNote(uint order,string memory s) public{
      require(Token.balanceOf(msg.sender,order)>=1);
      PurchaseOrder storage PO=PurchaseOrders[order];
      PO.Notes=s;
    }
}