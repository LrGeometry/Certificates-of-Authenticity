pragma solidity ^0.5.0;
import './HERC1155.sol';
import './openzeppelin/IERC721.sol';

contract HERC1155721 is HERC1155,IERC721{

constructor() public {
        nonce=nonce+1;
        creators[1] = msg.sender;
        balances[1][msg.sender] = _TotalSupply;
        TotalSupply[1]=_TotalSupply;
        _Name[1]=_name;
        _Symbol[1]=_symbol;
        _addTokenToOwnerEnumeration(msg.sender, 1); 
        // Transfer event with mint semantic
        emit TransferSingle(msg.sender, address(0x0), msg.sender, 1 ,_TotalSupply);
        HercTokenMinted=true;
        emit Transfer(address(0), msg.sender,1);
}
        

  function balanceOf(address owner) public view returns (uint256 balance){
          
          return super.balanceOf(owner,1);

   }
    function ownerOf(uint256 tokenId) public view returns (address owner){
            return NFTOwner[tokenId];
    }

   
    function getApproved(uint256 tokenId) public view returns (address operator){
            return address(0);
    }

    

    function transferFrom(address from, address to, uint256 tokenId) public{
            super.safeTransferFrom(from, to,  tokenId, 1, "");
               emit Transfer(from,   to,  tokenId);
            

    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public{
            super.safeTransferFrom(from, to,  tokenId, 1, "");
               emit Transfer(from,   to,  tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public{
            super.safeTransferFrom(from, to,  tokenId, 1, data);
              emit Transfer(from,   to,  tokenId);
    }
   function setApprovalForAll(address _operator, bool _approved) public {
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
    function approve(address to, uint256 tokenId) public{
        require(isNFT[tokenId]==true);
        require(allowances[msg.sender][to][tokenId]==0);
        allowances[msg.sender][to][tokenId] =1;

        emit Approval(msg.sender,to, tokenId, 0, 1);
     }
   function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) public {

        require(allowances[msg.sender][_spender][_id] == _currentValue);
        allowances[msg.sender][_spender][_id] = _value;

        emit Approval(msg.sender, _spender, _id, _currentValue, _value);
    }
}