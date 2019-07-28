/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;




import  './ERC/ERC1155Mintable.sol';


contract Managable is ERC1155Mintable {


  mapping(address=>mapping(uint=>bool)) public Client;
    
  mapping(address=>mapping(uint=>bool)) public Manager;


 

  modifier isTokenOwner(uint order){    
    require(balanceOf(msg.sender,order)>=1);
    _;
  }
   modifier isClient(uint order){
    require(Client[msg.sender][order]==true);
    _;
  }
   modifier isManager(uint order){
    require(Manager[msg.sender][order]==true);
    _;
  }
  modifier Viewable(uint order){
    require(Manager[msg.sender][order]==true||Client[msg.sender][order]==true||(balanceOf(msg.sender,order)>=1));
    _;
  }
  
  
  function AssignAsClient(uint order,address client) public isTokenOwner(order){
    require(Client[client][order]==false);
   Client[client][order]=true;
    }  

  function AssignAsManager(uint order,address manager) public isTokenOwner(order){
    require(Manager[manager][order]==false);
    Manager[manager][order]=true;
    } 
    
  function delistManager(uint order,address manager) public isTokenOwner(order){
    require(Manager[manager][order]==true);
    Manager[manager][order]=false;
    } 
  function delistClient(uint order,address client) public isTokenOwner(order){
    require(Client[client][order]==true);
    Client[client][order]=false;
    } 


}