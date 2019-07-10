/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;
import './ERC/ERC1155Mintable.sol';
import './ERC/SafeMath.sol';
import './openzeppelin/Ownable.sol';
import './openzeppelin/MinterRole.sol';
import './ProxyReceiver/ProxyReceiver.sol';
import './Managable.sol';
import './openzeppelin/Ownable.sol';
contract HERC1155 is Ownable,MinterRole,Managable{

   using SafeMath for uint256;
  // mapping(uint=>string) private MutableTokenData;
   //mapping(uint=>string) private TokenData;
   mapping(uint=>bool) whitelistedToken;
   bool HercTokenMinted;
   string _name="Hercules";
   string _symbol="HERC";
   uint _TotalSupply=234259085000000000000000000;
   uint8 _decimals=18;
   /* constructor()   public  {
        nonce=nonce+1;
        creators[1] = msg.sender;
        balances[1][msg.sender] = _TotalSupply;
        totalSupply[1]=_TotalSupply;
        Name[1]=_name;
        Symbol[1]=_symbol;
        _addTokenToOwnerEnumeration(msg.sender, 1); 
        // Transfer event with mint semantic
        emit TransferSingle(msg.sender, address(0x0), msg.sender, 1 ,_TotalSupply);
        HercTokenMinted=true;
    } 
   /**  function create(uint256 _initialSupply, string memory _uri,string memory name,string memory symbol) onlyMinter() public returns(uint256 _id) {

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
    */
    
    function createfor(uint256 _initialSupply, string memory _uri,string memory _mutabledata,address to,string memory name,string memory symbol,uint mintlimit) onlyMinter() public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = to;
        balances[_id][to] = _initialSupply;
        TotalSupply[_id]=_initialSupply;
        _Name[_id]=name;
        _Symbol[_id]=symbol;
        MintableTokens[_id]=mintlimit;
        TokenData[_id]=_uri;
        if( (_initialSupply==1)&&( mintlimit==0)){
            isNFT[_id]==true;
            NFTOwner[_id]=to;
        }
        _addTokenToOwnerEnumeration(to, _id); 
        // Transfer event with mint semantic
        emit TransferSingle(to, address(0x0), to, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);

    }
  
    function viewMutableData(uint _id) public view returns(string memory){
        require(balanceOf(msg.sender,_id)==1);
        return  MutableTokenData[_id];
    }
      function viewTokenData(uint _id) public view returns(string memory){
        require(balanceOf(msg.sender,_id)==1);
        return  TokenData[_id];
    }
    function editMutableData(uint _id,string memory s) public {
        require((balanceOf(msg.sender, _id)==1)&&(isNFT[_id]==true));
        MutableTokenData[_id]=s;   
    }
  

}       