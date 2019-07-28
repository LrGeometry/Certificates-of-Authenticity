pragma solidity ^0.5.0;
import './HERC115520.sol';
/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
contract MetaHERC1155 is HERC115520{
    
    mapping(address=>uint) public nonces;


    function metaSafeTransferSingleFrom(bytes memory signature,address _to, uint256 _id, uint256 _value,bytes memory _data,uint256 _nonce) public{
        bytes32 hash = metaTransferSingleHash(_to, _id,_value, _nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(_nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _safeTransferFrom( signer,  _to, _id,  _value,  _data);
    }



    function metaSafeTransferBatchFrom( bytes memory signature,address _to, uint256[] memory _ids,
     uint256[] memory  _values, bytes memory _data,uint256 _nonce)
    public{
        bytes32 hash = metaTransferBatchHash(_to, _ids,_values, _nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(_nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;
        _safeBatchTransferFrom(signer,  _to,  _ids,   _values,_data);
    }

   function metaApprove(bytes memory signature,address _spender, uint256 _id, uint256 _currentValue, uint256 _value,uint _nonce)
    public{
        bytes32 hash = metaApproveHash(_spender, _id,_currentValue, _value,_nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(_nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;
        require(allowances[signer][_spender][_id] == _currentValue);
        allowances[signer][_spender][_id] = _value;

        emit Approval(signer, _spender, _id, _currentValue, _value);
        //approve(signer,  _spender,  _ids,   _valuea,_data);
   }
   function metaUpdateData(bytes memory signature,uint _token,string memory _newdata,uint _nonce) public{
        bytes32 hash = metaUpdateHash(_token ,_newdata,_nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(_nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

       require((balanceOf(signer, _token)==1)&&(isNFT[_token]==true));
        MutableTokenData[_token]=_newdata;   

    }

    function metaTransferSingleHash(address to, uint256 tokenId, uint256 value, uint256 _nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaTransferSingleFrom", to, tokenId,value ,_nonce));
    }

    function metaTransferBatchHash(address to, uint256[] memory tokenIds, uint256[] memory values, uint256 _nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this),"metaTransferSingleFrom", to, tokenIds,values, _nonce));
    }

    function metaApproveHash(address _spender, uint256 _id, uint256 _currentValue, uint256 _value,uint _nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaApproveHash",_spender,_id,_currentValue,_value,nonce));
    }

    function metaUpdateHash(uint _token,string memory _newdata,uint _nonce)  public returns (bytes32){
        return keccak256(abi.encodePacked(address(this), "metaUpdateHash",_token,_newdata,_nonce));
    }    
    /*
     * @dev Gets the signer of an hash using the signature
     * @param hash The hash to check
     * @param signature The signature to use
     * @return The address of the signer or 0x0 address is something went wrong
     */
       function getSigner(bytes32 hash, bytes memory signature) public pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (signature.length != 65) {
            return address(0);
        }

        /* solhint-disable-next-line no-inline-assembly */
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        if (v != 27 && v != 28) {
            return address(0);
        } else {
            return ecrecover(keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            ), v, r, s);
        }
    }


}