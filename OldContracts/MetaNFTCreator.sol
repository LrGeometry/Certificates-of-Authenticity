pragma solidity ^0.5.0;

import'./NFTCreator.sol';

contract MetaNFTCreator is NFTCreator{
    
 mapping(address=>uint) public nonces;

function metaMintNFT(string signature ,uint _type,string memory data,string memory mutabledata,uint _nonce) public{
        bytes32 hash = metaMintHash(_type,data,mutabledata,_nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(_nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;
        require(_type<=totalNFTs);
        NFT memory tokentype=NFTTypes[_type];
        if(tokentype.attachedTokens>0){
        require(
                Token.allowance(signer, address(this),primaryToken) >=tokentype.attachedTokens,
                "Contract is not allowed to manipulate sender funds"
            );

        
                Token.safeTransferFrom(signer, address(this),primaryToken,tokentype.attachedTokens,'0x0');
        } 
        uint ID =Token.createfor(1,data,mutabledata,signer,tokentype.name,tokentype.symbol,tokentype.mintlimit);     
        attachedTokens[ID]= tokentype.attachedTokens;
        tokenType[ID]=_type;


}


function metaMintHash(uint _type,string memory data,string memory mutabledata,uint _nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaMintHash",_type,data,mutabledata,_nonce));
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