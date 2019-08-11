/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;

import "./SafeMath.sol";
import "./Address.sol";
import "./IERC1155TokenReceiver.sol";
import "./IERC1155.sol";
import "./ERC165.sol";
import './../openzeppelin/Ownable.sol';
// A sample implementation of core ERC1155 function.
contract ERC1155 is IERC1155, ERC165,Ownable
{
    using SafeMath for uint256;
    using Address for address;
   

    bool private _paused;
    bytes4 constant public ERC1155_RECEIVED       = 0xf23a6e61;
    bytes4 constant public ERC1155_BATCH_RECEIVED = 0xbc197c81;
    
    // id => (owner => balance)
    mapping (uint256 => mapping(address => uint256)) internal balances;

    mapping(address => mapping(address => mapping(uint256 => uint256))) allowances;
    // owner => (operator => approved)
    mapping (address => mapping(address => bool)) internal operatorApproval;

    mapping(uint=>string) internal MutableTokenData;

    mapping(uint=>string) internal TokenData
    ;
    mapping(uint256=>string) public _Symbol;

    mapping(uint256=>string) public _Name;

    mapping(uint256=>address) internal NFTOwner;

    mapping(uint256=>bool) internal isNFT;

    mapping(uint256=>uint256) public TotalSupply;
    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(address=>mapping(uint256 => uint256)) private _ownedTokensIndex;

    event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
   
    event Paused(address account);
    event Unpaused(address account);
 
/////////////////////////////////////////// ERC165 //////////////////////////////////////////////

    /*
        bytes4(keccak256('supportsInterface(bytes4)'));
    */
    bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;

    /*
        bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
        bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
        bytes4(keccak256("balanceOf(address,uint256)")) ^
        bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
        bytes4(keccak256("setApprovalForAll(address,bool)")) ^
        bytes4(keccak256("isApprovedForAll(address,address)"));
    */
    bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;

    function supportsInterface(bytes4 _interfaceId)
    public
    view
    returns (bool) {
         if (_interfaceId == INTERFACE_SIGNATURE_ERC165 ||
             _interfaceId == INTERFACE_SIGNATURE_ERC1155) {
            return true;
         }

         return false;
    }

   

     function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) internal {
        require(_value>0*10**18,"cannot tranfer 0 tokens");
        require(_to != address(0x0), "_to must be non-zero.");
       // require(_from == msg.sender || operatorApproval[_from][msg.sender] == true, "Need operator approval for 3rd party transfers.");

        // SafeMath will throw with insuficient funds _from
        // or if _id is not valid (balance will be 0)
        balances[_id][_from] = balances[_id][_from].sub(_value);
        balances[_id][_to]   = _value.add(balances[_id][_to]);
        if(isNFT[_id]==true){
            NFTOwner[_id]=_to;
        }
        if(_id>1){
            emit TransferSingle(msg.sender, _from, _to, _id, _value);
            

            if (_to.isContract()) {
                require(IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _value, _data) == ERC1155_RECEIVED, "Receiver contract did not accept the transfer.");
            }
        }
    }
   

    /**
        @notice Get the balance of an account's Tokens.
        @param _owner  The address of the token holder
        @param _id     ID of the Token
        @return        The _owner's balance of the Token type requested
     */
    function balanceOf(address _owner, uint256 _id) public view returns (uint256) {
        // The balance of any account can be calculated from the Transfer events history.
        // However, since we need to keep the balances to validate transfer request,
        // there is no extra cost to also privide a querry function.
        return balances[_id][_owner];
    }


    /**
        @notice Get the balance of multiple account/token pairs
        @param _owners The addresses of the token holders
        @param _ids    ID of the Tokens
        @return        The _owner's balance of the Token types requested
     */
    function balanceOfBatch(address[] memory _owners, uint256[] memory _ids) public view returns (uint256[] memory) {

        require(_owners.length == _ids.length);

        uint256[] memory balances_ = new uint256[](_owners.length);

        for (uint256 i = 0; i < _owners.length; ++i) {
            balances_[i] = balances[_ids[i]][_owners[i]];
        }

        return balances_;
    }
  

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data)  whenNotPaused public  {
            if (msg.sender != _from) {
                if(operatorApproval[_from][msg.sender] == false){
                    require( allowances[_from][msg.sender][_id]>= _value,"inadequate allowance");
                    allowances[_from][msg.sender][_id] = allowances[_from][msg.sender][_id].sub(_value);
                }
            }
            
            
            require(balances[_id][_from]>=_value,'inadequate token balance for transfer');
            if(_id>1){
                if(balanceOf(_from,_id).sub(_value)==0){
                    _removeTokenFromOwnerEnumeration( _from, _id);
                }
                if(balanceOf(_to,_id)==0){
                    _addTokenToOwnerEnumeration(_to, _id); 
                }
            }
            _safeTransferFrom(_from, _to, _id, _value, _data);
        }

  
    function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) whenNotPaused public /*payable*/ {
       
        if (msg.sender != _from) {
            if(operatorApproval[_from][msg.sender] == false){
                for (uint256 i = 0; i < _ids.length; ++i) {
                   // require(value > 0*10**18,"cannot transfer 0 tokens");
                    require( allowances[_from][msg.sender][_ids[i]]>=_values[i],"inadequate allowance");
                    allowances[_from][msg.sender][_ids[i]] = allowances[_from][msg.sender][_ids[i]].sub(_values[i]);
                    
                }
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
            require(value > 0*10**18,"cannot transfer 0 tokens");
            // SafeMath will throw with insuficient funds _from
            // or if _id is not valid (balance will be 0)
            require(balances[id][_from]>=value,'inadequate token balance for transfer');

            if(id>1){

                if(balances[id][_from].sub(value)==0 ){
                    _removeTokenFromOwnerEnumeration( _from,id);
                    }
                if(balances[id][_to] ==0){
                    _addTokenToOwnerEnumeration(_to,id); 
                    }
            }    
            balances[id][_from] = balances[id][_from].sub(value);
            balances[id][_to]   = value.add(balances[id][_to]);

            if(isNFT[id]==true){
                NFTOwner[id]=_to;
            }
        }

        // MUST emit event
        emit TransferBatch(msg.sender, _from, _to, _ids, _values);

        // Now that the balances are updated,
        // call onERC1155BatchReceived if the destination is a contract
        if (_to.isContract()) {
            require(IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _values, _data) == ERC1155_BATCH_RECEIVED, "Receiver contract did not accept the transfer.");
        }
    }
   
 
   /* function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) public {

        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] = _value;

        emit Approval(msg.sender, _spender, _id, _currentValue, _value);
    }
    */
    function allowance(address _owner, address _spender, uint256 _id)  whenNotPaused public view returns (uint256){
        return allowances[_owner][_spender][_id];
    }

     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) whenNotPaused public {

        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] = _value;
        emit Approval(msg.sender, _spender, _id, _currentValue, _value);
    
    }
    function increaseApproval(address _spender, uint256 _id, uint256 _currentValue, uint256 amount) whenNotPaused public{
        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] =  allowances[msg.sender][_spender][_id].add(amount);
       
        emit Approval(msg.sender, _spender, _id,_currentValue, _currentValue.add(amount)) ;
    }
    function decreaseApproval(address _spender, uint256 _id, uint256 _currentValue, uint256 amount) whenNotPaused public{
        require(allowances[msg.sender][_spender][_id] == _currentValue);
        if(amount>_currentValue){
            allowances[msg.sender][_spender][_id] =0;
        }else{
            allowances[msg.sender][_spender][_id] =  allowances[msg.sender][_spender][_id].sub(amount);
        }
        emit Approval(msg.sender, _spender, _id,_currentValue, _currentValue.sub(amount)) ;
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

function _addTokenToOwnerEnumeration(address to, uint256 tokenId) internal {
        _ownedTokensIndex[to][tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
  /**
     * @dev Internal function to burn all of a specific token
     * Reverts if the token does not exist
     
     * @param _owner owner of the token to burn
     * @param _tokenId uint256 ID of the token being burned
     */
    function _burnall(address _owner, uint256 _tokenId) internal {
      

        _removeTokenFromOwnerEnumeration(_owner, _tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[_owner][_tokenId] = 0;
        uint amountBurned=balances[_tokenId][_owner];
        balances[_tokenId][_owner]=0;
        TotalSupply[_tokenId]=TotalSupply[_tokenId].sub(amountBurned);
        if(TotalSupply[_tokenId]==0){
            MutableTokenData[_tokenId]="";
            TokenData[_tokenId]="";
        }
       
    }
     /**
     * @dev Internal function to burn a specific token amont
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead
     * @param _owner owner of the token to burn
     * @param _tokenId uint256 ID of the token being burned
     */
     function _burnAmount(address _owner, uint256 _tokenId,uint _amount) internal {
       
        if(balanceOf(_owner,_tokenId).sub(_amount)==0){
        _removeTokenFromOwnerEnumeration(_owner, _tokenId);
        _ownedTokensIndex[_owner][_tokenId]=0;
        }
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        balances[_tokenId][_owner]= balances[_tokenId][_owner].sub(_amount);
        TotalSupply[_tokenId]=TotalSupply[_tokenId].sub(_amount);
        if(TotalSupply[_tokenId]==0){
            MutableTokenData[_tokenId]="";
            TokenData[_tokenId]="";
        }
       
    }

    function burn(uint256 _tokenId) whenNotPaused public{
        require(balanceOf(msg.sender,_tokenId)>=1);
        _burnall(msg.sender, _tokenId);
    }
        /**
        @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
        @dev MUST emit the ApprovalForAll event on success.
        @param _operator  Address to add to the set of authorized operators
        @param _approved  True if the operator is approved, false to revoke approval
    */
  function setApprovalForAll(address _operator, bool _approved) whenNotPaused public {
        operatorApproval[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /**
        @notice Queries the approval status of an operator for a given owner.
        @param _owner     The owner of the Tokens
        @param _operator  Address of authorized operator
        @return           True if the operator is approved, false if not
    */
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApproval[_owner][_operator];
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused,"the contract is paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused,"the contract is paused");
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
       
}
