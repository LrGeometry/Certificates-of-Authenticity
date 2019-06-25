
/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
/* solhint-disable no-empty-blocks */
pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./openzeppelin/Ownable.sol";
import "./HERC1155.sol";
import "./Receiver.sol";


/**
 * @title provenance of Ownership
 * @dev This is our main contract
 */
contract TOS is Receiver,Ownable{
    /**
     * @dev This contract must be linked to a token
     * @param TokenAddress The address of the linked token
     */
    constructor(address TokenAddress,uint _tokenID) public  {
        Token = HERC1155(TokenAddress);
        tokenID= _tokenID;
        shouldReject=false;

    }
    uint tokenID;
    address public tokenAddress;
    HERC1155 Token;
    uint256 public constant CONTRACT_CREATION_PRICE = 10;
    uint256 public constant CONTRACT_UPDATE_PRICE =10;
    
    struct provenance {
        uint256 hercid;
        uint256 provenanceId;
        uint256 barId;
        uint256 serialnumber;

        uint256 price;
        uint256 timestamp;
        uint256 weight;
        string  assay;
        string ipfshash;
        string  manufacturer;
        string factomEntryHash;
       
        string data;
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
    

        require(
            Token.allowance(provenanceOwner, address(this),tokenID) >= CONTRACT_CREATION_PRICE,
            "Contract is not allowed to manipulate sender funds"
        );

          Token.safeTransferFrom(provenanceOwner, address(this),tokenID,CONTRACT_CREATION_PRICE,'0x0');
            

 
        provenance memory p=provenance({
                hercid: newprovenance.hercid,
                provenanceId:newprovenance.provenanceId,
                barId: newprovenance.barId,
                serialnumber: newprovenance.serialnumber,
                price: newprovenance.price,                         
                timestamp:now,
                weight:newprovenance.weight,

                assay:newprovenance.assay,
                ipfshash:newprovenance.ipfshash,
                manufacturer:newprovenance.manufacturer,
                factomEntryHash: newprovenance.factomEntryHash,               
                data: newprovenance.data
            });
        provenances[newprovenance.provenanceId]=p;
       
            Token.createfor(1, uri ,provenanceOwner,"Terminal OS","TOS") ;
        //_mint(provenanceOwner, newprovenance.provenanceId);
        //_setTokenURI(newprovenance.provenanceId, uri);
    }

    /**
     
     */
    function _updateprovenance(

        address provenanceOwner,
        uint[] memory intParams,
        string[] memory stringParams
       
        
    ) internal {
      

        require(
            Token.allowance(provenanceOwner, address(this),tokenID) >= CONTRACT_UPDATE_PRICE,
            "Contract is not allowed to manipulate sender funds"
        );

       
            Token.safeTransferFrom(provenanceOwner, address(this),tokenID,CONTRACT_UPDATE_PRICE,'0x0');
      

        require(Token.balanceOf(provenanceOwner,intParams[0]) >=1, "provenances can only be updated by their owners");
       
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
        require(Token.balanceOf(provenanceOwner,provenanceId) >=1 , "provenances can only be updated by their owners");

        provenances[provenanceId].data = data;
    }
 
}