pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract Managable is ERC721Full, ERC721Mintable{

     constructor(string memory symbol,string memory name) public ERC721Full(symbol, name)  {
    
  } 
mapping(address=>mapping(uint=>bool)) public Client;
  
mapping(address=>mapping(uint=>bool)) public Manager;



  modifier isTokenOwner(uint order){
    
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
  modifier Viewable(uint order){
    require(Manager[msg.sender][order]==true||Client[msg.sender][order]==true||ownerOf(order)==msg.sender);
    _;
  }

  
  function AssignAsClient(uint order,address client) public isTokenOwner(order){
    require(Client[client][order]==false);
   Client[client][order]=true;
    }  

  function AssignAsManager(uint order,address manager) public isTokenOwner(order){
       require(Manager[manager][order]==false)   ;
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