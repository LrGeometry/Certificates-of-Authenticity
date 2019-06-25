pragma solidity ^0.5.0;

import "./HERC1155.sol";
import "./Receiver.sol";
import "./openzeppelin/Ownable.sol";

contract NFTCreator is Receiver,Ownable{




struct NFT{
    string name;
    string symbol;
    uint mintlimit;
    uint attachedTokens;
}
HERC1155 Token;

uint primaryToken;

uint totalNFTs;

mapping(uint=>uint) attachedTokens;

mapping(uint=>NFT) NFTTypes;

constructor(address _token,uint _primaryToken) public{
    primaryToken=_primaryToken;
    Token =HERC1155(_token);
}

function AddNewNFT(string memory _name,string memory _symbol,uint _mintlimit,uint _attachedtokens) public onlyOwner() {
    totalNFTs++;
    NFTTypes[totalNFTs]=NFT(_name,_symbol,_mintlimit,_attachedtokens);

}

function mintNFT(uint _type,string memory data,string memory mutabledata) public{
    require(_type<=totalNFTs);
    NFT memory tokentype=NFTTypes[_type];

    if(tokentype.attachedTokens>0){
     require(
            Token.allowance(msg.sender, address(this),primaryToken) >=tokentype.attachedTokens,
            "Contract is not allowed to manipulate sender funds"
        );

       
            Token.safeTransferFrom(msg.sender, address(this),primaryToken,tokentype.attachedTokens,'0x0');
    } 
     uint ID =Token.createfor(1,data,mutabledata,msg.sender,tokentype.name,tokentype.symbol,tokentype.mintlimit);     
     attachedTokens[ID]= tokentype.attachedTokens;
}

function withdrawAttached(uint nft) public{
    require(Token.balanceOf(msg.sender,nft)==1);

     Token.safeTransferFrom(msg.sender,address(this),nft,1,'0x0');
     Token.safeTransferFrom( address(this),msg.sender,primaryToken,attachedTokens[nft],'0x0');
     Token.burn(nft);
}

  function setShouldReject(bool _value) public onlyOwner() {
        shouldReject = _value;
  }




}