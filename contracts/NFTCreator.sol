pragma solidity ^0.5.0;

import "./HERC115520.sol";
import "./Receiver.sol";
import "./openzeppelin/Ownable.sol";

contract NFTCreator is Receiver,Ownable{




struct NFT{

    string name;
    string symbol;
    uint mintlimit;
    uint attachedTokens;
}

HERC1155 TokenContract;

uint primaryTokenId;

uint public totalNFTs;

mapping(uint=>uint) public attachedTokens;

mapping(uint=>NFT) public NFTTemplates;

mapping(uint=>uint) public tokenType;

constructor(address payable _token,uint _primaryTokenId) public{
    primaryTokenId =_primaryTokenId;
    TokenContract = HERC115520(_token);
    shouldReject = false;
}

function CreateTemplate(string memory _name,string memory _symbol,uint _mintlimit,uint _attachedtokens) public onlyOwner() {
    totalNFTs++;
    NFTTemplates[totalNFTs] = NFT(_name,_symbol,_mintlimit,_attachedtokens);

}

function mintNFT(uint _type,string memory data,string memory mutabledata) public {
    require(_type <= totalNFTs);
    NFT memory tokentype = NFTTemplates[_type];

    if(tokentype.attachedTokens>0){
     require(
            TokenContract.allowance(msg.sender, address(this),primaryTokenId) >=tokentype.attachedTokens,
            "Contract is not allowed to manipulate sender funds"
        );

       
            TokenContract.safeTransferFrom(msg.sender, address(this),primaryTokenId,tokentype.attachedTokens,'');
    } 
     uint ID =TokenContract.createfor(1,data,mutabledata,msg.sender,tokentype.name,tokentype.symbol,tokentype.mintlimit);   
     require(ID>1);  
     attachedTokens[ID]= tokentype.attachedTokens;
     tokenType[ID]=_type;
}

function withdrawlAttached(uint nft) public{
    require(TokenContract.balanceOf(msg.sender,nft)==1);

     TokenContract.safeTransferFrom(msg.sender,address(this),nft,1,'0x0');
     TokenContract.safeTransferFrom( address(this),msg.sender,primaryTokenId,attachedTokens[nft],'0x0');
     TokenContract.burn(nft);
}

  function setShouldReject(bool _value) public onlyOwner() {
        shouldReject = _value;
  }




}