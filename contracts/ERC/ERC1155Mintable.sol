/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;

import "./ERC1155.sol";

/**
    @dev Mintable form of ERC1155
    Shows how easy it is to mint new items.
*/
contract ERC1155Mintable is ERC1155 {

    bytes4 constant private INTERFACE_SIGNATURE_URI = 0x0e89341c;
    
    // id => creators
    mapping (uint256 => address) public creators;
    
    // A nonce to ensure we have a unique id each time we mint.
    uint256 public nonce;
    //mapping(uint256=>uint256) mintingLimit;
    mapping(uint256=>uint256) MintableTokens;
    modifier creatorOnly(uint256 _id) {
        require(creators[_id] == msg.sender);
        _;
    }
    

    function supportsInterface(bytes4 _interfaceId)
    public
    view
    returns (bool) {
        if (_interfaceId == INTERFACE_SIGNATURE_URI) {
            return true;
        } else {
            return super.supportsInterface(_interfaceId);
        }
    }

    // Creates a new token type and assings _initialSupply to minter
   
    // Batch mint tokens. Assign directly to _to[].
    function mint(uint256 _id, address[] memory _to, uint256[] memory _quantities) public creatorOnly(_id) {
        uint total=sumAsm(_quantities);

        TotalSupply[_id]+=total;

        require(total<=MintableTokens[_id]);

        MintableTokens[_id]=MintableTokens[_id].sub(total);
        
        for (uint256 i = 0; i < _to.length; ++i) {

            address to = _to[i];
            uint256 quantity = _quantities[i];

            // Grant the items to the caller
            balances[_id][to] = quantity.add(balances[_id][to]);

            // Emit the Transfer/Mint event.
            // the 0x0 source address implies a mint
            // It will also provide the circulating supply info.
            emit TransferSingle(msg.sender, address(0x0), to, _id, quantity);

            if (to.isContract()) {
                require(IERC1155TokenReceiver(to).onERC1155Received(msg.sender, msg.sender, _id, quantity, '') == ERC1155_RECEIVED, "Receiver contract did not accept the transfer.");
            }
        }
    }
      function sumAsm(uint[] memory _data) public pure returns (uint sum) {
        for (uint i = 0; i < _data.length; ++i) {
            assembly {
                sum := add(sum, mload(add(add(_data, 0x20), mul(i, 0x20))))
            }
        }


        
    }}
