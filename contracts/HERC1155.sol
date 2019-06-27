/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;
import './ERC/ERC1155Mintable.sol';
import './ERC/SafeMath.sol';
import './openzeppelin/Ownable.sol';
import './openzeppelin/MinterRole.sol';
import './ProxyReceiver/ProxyReceiver.sol';


contract HERC1155 is MinterRole,ERC1155Mintable, Ownable{

   using SafeMath for uint256;
  // mapping(uint=>string) private MutableTokenData;
   //mapping(uint=>string) private TokenData;
   mapping(uint=>bool) whitelistedToken;
   


    constructor() public{


    } 
    function create(uint256 _initialSupply, string memory _uri,string memory name,string memory symbol) onlyMinter() public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = msg.sender;
        balances[_id][msg.sender] = _initialSupply;
        totalSupply[_id]=_initialSupply;
        Name[_id]=name;
        Symbol[_id]=symbol;
        _addTokenToOwnerEnumeration(msg.sender, _id); 
        // Transfer event with mint semantic
        emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);
    }
    
    function createfor(uint256 _initialSupply, string memory _uri,string memory _mutabledata,address to,string memory name,string memory symbol,uint mintlimit) onlyMinter() public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = to;
        balances[_id][to] = _initialSupply;
        totalSupply[_id]=_initialSupply;
        Name[_id]=name;
        Symbol[_id]=symbol;
        MintableTokens[_id]=mintlimit;
        TokenData[_id]=_uri;
        
        _addTokenToOwnerEnumeration(to, _id); 
        // Transfer event with mint semantic
        emit TransferSingle(to, address(0x0), to, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);

    }
  
    function viewMutableData(uint _id) public view returns(string memory){
        return  MutableTokenData[_id];
    }
      function viewTokenData(uint _id) public view returns(string memory){
        return  TokenData[_id];
    }
    function editMutableData(uint _id,string memory s) public {
        require((balanceOf(msg.sender, _id)==1)&&(totalSupply[_id]==1));
        MutableTokenData[_id]=s;   
    }
  

}       