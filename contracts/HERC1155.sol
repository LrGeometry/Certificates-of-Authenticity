/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
import './ERC/ERC1155Mintable.sol';
import './ERC/SafeMath.sol';
import './openzeppelin/Ownable.sol';
import './openzeppelin/MinterRole.sol';



contract HERC1155 is ERC1155Mintable, MinterRole{

   using SafeMath for uint256;
    mapping(address => mapping(address => mapping(uint256 => uint256))) allowances;

    event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
   
   
    address deployer;
     // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(address=>mapping(uint256 => uint256)) private _ownedTokensIndex;





    constructor() public{


    } 
    function create(uint256 _initialSupply, string memory _uri,string memory name,string memory symbol) onlyMinter() public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = msg.sender;
        balances[_id][msg.sender] = _initialSupply;
        Name[_id]=name;
        Symbol[_id]=symbol;
        _addTokenToOwnerEnumeration(msg.sender, _id); 
        // Transfer event with mint semantic
        emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);
    }
    function createfor(uint256 _initialSupply, string memory _uri,address to,string memory name,string memory symbol) onlyMinter() public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = to;
        balances[_id][to] = _initialSupply;
        Name[_id]=name;
        Symbol[_id]=symbol;
        _addTokenToOwnerEnumeration(to, _id); 
        // Transfer event with mint semantic
        emit TransferSingle(to, address(0x0), to, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);
    }
  
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) public  {
            if (msg.sender != _from) {
                require( allowances[_from][msg.sender][_id]>= _value,"inadequate allowance");
                allowances[_from][msg.sender][_id] = allowances[_from][msg.sender][_id].sub(_value);
            }
            
            

             if(balanceOf(_from,_id).sub(_value)==0){
                _removeTokenFromOwnerEnumeration( _from, _id);
              }
            if(balanceOf(_to,_id)==0){
                 _addTokenToOwnerEnumeration(_to, _id); 
              }
            _safeTransferFrom(_from, _to, _id, _value, _data);
        }

  
    function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) public /*payable*/ {
        if (msg.sender != _from) {
            for (uint256 i = 0; i < _ids.length; ++i) {
                require( allowances[_from][msg.sender][_ids[i]]>=_values[i],"inadequate allowance");
                allowances[_from][msg.sender][_ids[i]] = allowances[_from][msg.sender][_ids[i]].sub(_values[i]);
                
            }
        }
        _safeBatchTransferFrom(_from, _to, _ids, _values, _data);
    }
     /**
        @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call).
        @dev MUST emit TransferBatch event on success.
        Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
        MUST Throw if `_to` is the zero address.
        MUST Throw if any of the `_ids` is not a valid token ID.
        MUST Throw on any other error.
        When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return value is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`.
        @param _from    Source address
        @param _to      Target address
        @param _ids     IDs of each token type
        @param _values  Transfer amounts per token type
        @param _data    Additional data with no specified format, sent in call to `_to`
    */

     
    function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) internal {

        // MUST Throw on errors
        require(_to != address(0x0), "destination address must be non-zero.");
        require(_ids.length == _values.length, "_ids and _values array lenght must match.");
       // require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");

        for (uint256 i = 0; i < _ids.length; ++i) {
            uint256 id = _ids[i];
            uint256 value = _values[i];

            // SafeMath will throw with insuficient funds _from
            // or if _id is not valid (balance will be 0)

             if(balances[id][_from].sub(value)==0){
                 _removeTokenFromOwnerEnumeration( _from,_ids[i]);
                 }
             if(balances[id][_to] ==0){
                   _addTokenToOwnerEnumeration(_to,_ids[i]); 
                }
            balances[id][_from] = balances[id][_from].sub(value);
            balances[id][_to]   = value.add(balances[id][_to]);
        }

        // MUST emit event
        emit TransferBatch(msg.sender, _from, _to, _ids, _values);

        // Now that the balances are updated,
        // call onERC1155BatchReceived if the destination is a contract
        if (_to.isContract()) {
            require(IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _values, _data) == ERC1155_BATCH_RECEIVED, "Receiver contract did not accept the transfer.");
        }
    }
   
 
    function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) public {

        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] = _value;

        emit Approval(msg.sender, _spender, _id, _currentValue, _value);
    }

   
    function allowance(address _owner, address _spender, uint256 _id) public view returns (uint256){
        return allowances[_owner][_spender][_id];
    }
/**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[from][tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[from][lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokens[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
        // lasTokenId, or just over the end of the array if the token was the last one).
    }


  function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < _ownedTokens[owner].length);
        return _ownedTokens[owner][index];
    }
  function getAllOwnedTokens(address owner) public view returns (uint256[] memory ){
         return _ownedTokens[owner];
     }

function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[to][tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
   /**
     * @dev Internal function to burn all of a specific token
     * Reverts if the token does not exist
     
     * @param _owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burnall(address _owner, uint256 tokenId) internal {
      

        _removeTokenFromOwnerEnumeration(_owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[_owner][tokenId] = 0;
        balances[tokenId][_owner]=0;
       
    }
     /**
     * @dev Internal function to burn a specific token amont
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead
     * @param _owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
     function _burnAmount(address _owner, uint256 tokenId,uint amount) internal {
       
        if(balanceOf(_owner,tokenId).sub(amount)==0){
        _removeTokenFromOwnerEnumeration(_owner, tokenId);
        _ownedTokensIndex[_owner][tokenId]=0;
        }
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        balances[tokenId][_owner]= balances[tokenId][_owner].sub(amount);

       
    }

  
}       