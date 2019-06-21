 function create(uint256 _initialSupply, string memory _uri,string memory name,string memory symbol) public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = msg.sender;
        balances[_id][msg.sender] = _initialSupply;
        Name[_id]=name;
        Symbol[_id]=symbol;
        // Transfer event with mint semantic
        emit TransferSingle(msg.sender, address(0x0), msg.sender, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);
    }
    function createfor(uint256 _initialSupply, string memory _uri,address to,string memory name,string memory symbol) public returns(uint256 _id) {

        _id = ++nonce;
        creators[_id] = msg.sender;
        balances[_id][to] = _initialSupply;
        Name[_id]=name;
        Symbol[_id]=symbol;
        // Transfer event with mint semantic
        emit TransferSingle(to, address(0x0), to, _id, _initialSupply);

        if (bytes(_uri).length > 0)
            emit URI(_uri, _id);
    }
     /**
        @notice Transfers value amount of an _id from the _from address to the _to addresses specified. Each parameter array should be the same length, with each index correlating.
        @dev MUST emit Transfer event on success.
        Caller must have sufficient allowance by _from for the _id/_value pair, or isApprovedForAll must be true.
        Throws if `_to` is the zero address.
        Throws if `_id` is not a valid token ID.
        When transfer is complete, this function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC1155Received` on `_to` and throws if the return value is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`.
        @param _from    source addresses
        @param _to      target addresses
        @param _id      ID of the Token
        @param _value   transfer amounts
        @param _data    Additional data with no specified format, sent in call to `_to`
    */
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes memory _data) public  {
            if (msg.sender != _from) {
                allowances[_from][msg.sender][_id] = allowances[_from][msg.sender][_id].sub(_value);
            }
            
            

           // if(balanceOf(_from,_id).sub(_value)==0){
              //  _removeTokenFromOwnerEnumeration( _from, _id);
           // }
          //  if(balanceOf(_to,_id)==0){
               // _addTokenToOwnerEnumeration(_to, _id); 
           // }
            _safeTransferFrom(_from, _to, _id, _value, _data);
        }

    /**
        @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call)
        @dev MUST emit Transfer event per id on success.
        Caller must have a sufficient allowance by _from for each of the id/value pairs.
        Throws on any error rather than return a false flag to minimize user errors.
        @param _from    Source address
        @param _to      Target address
        @param _ids     Types of Tokens
        @param _values  Transfer amounts per token type
        @param _data    Additional data with no specified format, sent in call to `_to`
    */
    function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _values, bytes memory _data) public /*payable*/ {
        if (msg.sender != _from) {
            for (uint256 i = 0; i < _ids.length; ++i) {
                allowances[_from][msg.sender][_ids[i]] = allowances[_from][msg.sender][_ids[i]].sub(_values[i]);
               // if(balanceOf(_from,_ids[i]).sub(_values[i])==0){
                    //_removeTokenFromOwnerEnumeration( _from,_ids[i]);
               // }
               // if(balanceOf(_to,_ids[i])==0){
                   // _addTokenToOwnerEnumeration(_to,_ids[i]); 
               // }
            }
        }
        _safeBatchTransferFrom(_from, _to, _ids, _values, _data);
    }

     /**
        @notice Allow other accounts/contracts to spend tokens on behalf of msg.sender
        @dev MUST emit Approval event on success.
        To minimize the risk of the approve/transferFrom attack vector (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), this function will throw if the current approved allowance does not equal the expected _currentValue, unless _value is 0.
        @param _spender      Address to approve
        @param _id           ID of the Token
        @param _currentValue Expected current value of approved allowance.
        @param _value        Allowance amount
    */
    function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) public {

        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] = _value;

        emit Approval(msg.sender, _spender, _id, _currentValue, _value);
    }

    /**
        @notice Queries the spending limit approved for an account
        @param _id       ID of the Token
        @param _owner    The owner allowing the spending
        @param _spender  The address allowed to spend.
        @return          The _spender's allowed spending balance of the Token requested
     */
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
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
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
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
   /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead
     * @param _owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burnall(address _owner, uint256 tokenId) internal {
      

        _removeTokenFromOwnerEnumeration(_owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId] = 0;

       
    }
     /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead
     * @param _owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
     function _burnAmount(address _owner, uint256 tokenId,uint amount) internal {
       
        if(balanceOf(_owner,tokenId).sub(amount)==0){
        _removeTokenFromOwnerEnumeration(_owner, tokenId);
        }
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId]=_ownedTokensIndex[tokenId].sub(amount);

       
    }
