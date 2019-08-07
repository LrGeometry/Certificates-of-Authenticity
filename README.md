NFT Creator Contract
This contract calls the HERC115520 contract to mint NFT tokens based on specific templates.

NFTs are defined by a name, symbol, mint limit,and token price in the HERC115520 token called _attachedtokens


CreateTemplate(string memory _name,string memory _symbol,uint _mintlimit,uint _attachedtokens) creates a new template for minting

Each template will be given a new uint ID based on the total number of previously created templates. Given 10 previously created templates the next created template id will be 11. 
The Data parameters associated with each Template can be returned by calling  NFTTemplates(uint id) which takes the given Template id
The total number of templates can be obtained by calling the totalNFTs() function

new tokens of a given template are created with custom immutable data and mutable data through

mintNFT(uint _type,string memory data,string memory mutabledata) which specifies the template through the _type parameter


HERC115520 Token Contract
This contract extends all the basic funcitonality of ERC1155 token stardard
https://github.com/ethereum/eips/issues/1155
https://blog.enjincoin.io/erc-1155-the-final-token-standard-on-ethereum-a83fce9f5714

The ERC20 interface is implemented for HERC token of ID 1 which is minted automatically upon contract deployment.
All ERC20 functions operate on this Token.

A token is considered fungible if more than one of the same ID can be created. This is determined when a token is minted.
The following mappings contain uniques properties for each batch of tokens based on uint id number.


mapping(uint=>string) internal MutableTokenData; Unique string of data which can altered by the token owner. Only applies to NFTS.

mapping(uint=>string) internal TokenData; Unique string of immutable data assigned to a token at minting
    
mapping(uint256=>string) public _Symbol; Unique string Identifier assigned to a token at minting

mapping(uint256=>string) public _Name;  Unique string Identifier assigned to a token at minting

mapping(uint256=>address) internal NFTOwner; Provides the Current owner of an NFT Token.

mapping(uint256=>bool) internal isNFT; Returns True if a token id  has a total supply and a MintableTokens value of 0;

mapping(uint256=>uint256) public TotalSupply; Total number of Tokens of a given ID

mapping(uint256=>uint256) MintableTokens; Remaining tokens that can be minted of a particular ID

mapping (uint256 => address) public creators; Initial Minter of a token. Has the ability to mint an extra  number of tokens specified in the initial token creation.


New Tokens are created using the createfor function which can only be called by authorized minters.Initially only the NFTCreator contract will be able to call this function. 
It uses the following parameters:
_initialSupply:Uint that Defines the initially created token supply of thei given ID
_uri: string that sets the immutable token data
_mutabledata: string that sets the initial value of the mutable token data
to: address the token is minted for. Will be assigned as token owner and creator
name: string setting the name of the token
symbol: string setting the symbol of the token
mintlimit: uint defining how many more tokens can be minted by the token creator 



function createfor(uint256 _initialSupply, string memory _uri,string memory _mutabledata,address to,string memory name,string memory symbol,uint mintlimit) onlyMinter() 

When  _initialSupply==1 and mintlimit==0 tokens are set as nfts and mutable data is enabled. Mutable data can be changed by the owner using
 editMutableData(uint _id,string memory s) which takes the id of the token being updated and  string s for the updated data

Token Enumeration functionality is also extended from the ERC721 standard as implemented by openzepplin 
https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/token/ERC721/ERC721Enumerable.sol
https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md

The ids of all owned tokens for a  given address can be obtained by getAllOwnedTokens(address owner) which returns them as an array. The exact balance of each id can be obtained by calling the ERC1155 balance function on each.

 
