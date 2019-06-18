/* solhint-disable no-empty-blocks */

pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;

import "./openzeppelin/ERC721Full.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


/**
 * @title provenance of Ownership
 * @dev This is our main contract
 */
contract TOS is ERC721Full, Ownable {
    /**
     * @dev This contract must be linked to a token
     * @param newTokenAddress The address of the linked token
     */
    constructor(address newTokenAddress) public ERC721Full(
        "Terminal OS",
        "TOS"
    ) {
        tokenAddress = newTokenAddress;
    }

    address public tokenAddress;

    uint256 public constant CONTRACT_CREATION_PRICE = 0 * 10 ** 18;
    uint256 public constant CONTRACT_UPDATE_PRICE = 0 * 10 ** 18;

    struct provenance {
       
        uint256 BarId;
        string  Manufacturer;
        uint GrossWeight;         
        string  Assay;
        uint256 Serialnumber;
        string Supplier;
        string Vault;
        uint CertifierID;
    }
    mapping(uint=>provenance) provenances;
    //provenance[] internal provenances;

    function createprovenance(
        provenance memory newprovenance,
        string memory uri
    ) public {
        _createprovenance(msg.sender, newprovenance, uri);
    }
   
    function updateprovenance(
        uint[] memory intParams,
        string[] memory stringParams
    ) public {
        _updateprovenance(
            msg.sender,
            intParams,
             stringParams
        );
    }

    function updateprovenanceData(
        uint256 provenanceId,
        string memory data
    ) public {
        _updateprovenanceData(
            msg.sender,
            provenanceId,
            data
        );
    }

    /**
     * @dev Gets a provenance and the related information, can only be called by the provenance owner
     * @param provenanceId The id of a provenance
     * @return The required provenance
     */
    function getprovenance(
        uint256 provenanceId
    ) public view returns (
        provenance memory
    ) {
        return provenances[provenanceId];
    }

    /**
     * @dev Creates a new provenance and links it to the sender
     * @param newprovenance The new provenance to create
     * @param provenanceOwner The address that will receive the new provenance
     */
    function _createprovenance(
        address provenanceOwner,
        provenance memory newprovenance,
        string memory uri
    ) internal {
        IERC20 token = IERC20(tokenAddress);

        require(
            token.allowance(provenanceOwner, address(this)) >= CONTRACT_CREATION_PRICE,
            "Contract is not allowed to manipulate sender funds"
        );

        require(
            token.transferFrom(provenanceOwner, address(this), CONTRACT_CREATION_PRICE),
            "Transfer failed"
        );
/**    uint256 BarId;
        string  Manufacturer;
        uint GrossWeight;         
        string  Assay;
        uint256 Serialnumber;
        string Supplier;
        string Vault
        uint CertifierID;
         */
        
        provenances[newprovenance.BarId]=newprovenance;
       

        _mint(provenanceOwner, newprovenance.BarId);
        _setTokenURI(newprovenance.BarId, uri);
    }

    /**
     
     */
    function _updateprovenance(

        address provenanceOwner,
        uint[] memory intParams,
        string[] memory stringParams
       
        
    ) internal {
        IERC20 token = IERC20(tokenAddress);

        require(
            token.allowance(provenanceOwner, address(this)) >= CONTRACT_UPDATE_PRICE,
            "Contract is not allowed to manipulate sender funds"
        );

        require(
            token.transferFrom(provenanceOwner, address(this), CONTRACT_UPDATE_PRICE),
            "Transfer failed"
        );

        require(ownerOf(intParams[0]) == provenanceOwner, "provenances can only be updated by their owners");
       
        provenances[intParams[0]].hercid=intParams[1];
        provenances[intParams[0]].barId=intParams[2];
        
        provenances[intParams[0]].serialnumber=intParams[3];
        provenances[intParams[0]].price = intParams[4];
        provenances[intParams[0]].weight=intParams[5];
        
        provenances[intParams[0]].assay=stringParams[0];
        provenances[intParams[0]].ipfshash=stringParams[1];
        provenances[intParams[0]].manufacturer=stringParams[2];
        provenances[intParams[0]].factomEntryHash = stringParams[3];
        provenances[intParams[0]].data =stringParams[4];
    }

    function _updateprovenanceData(
        address provenanceOwner,
        uint256 provenanceId,
        string memory data
    ) internal {
        require(ownerOf(provenanceId) == provenanceOwner, "provenances can only be updated by their owners");

        provenances[provenanceId].data = data;
    }
}
