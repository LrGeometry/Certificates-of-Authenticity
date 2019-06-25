/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
/* solhint-disable no-empty-blocks */

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./TOS.sol";


/**
 * @title provenance of Ownership Meta Transactions
 * @dev This contract handles our meta-transactions
 */
contract MetaTOS is TOS {
    constructor(
        address newTokenAddress,uint id
    ) public TOS(
        newTokenAddress,id
    ) {
    }

    mapping (address => uint256) public nonces;

    function metaCreateprovenance(
        bytes memory signature,
        provenance memory newprovenance,
        string memory uri,
        uint256 nonce
    ) public {
        bytes32 hash = metaCreateprovenanceHash(
            newprovenance,
            uri,
            nonce
        );

        address signer = getSigner(hash, signature);

        //require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _createprovenance(signer, newprovenance, uri);
    }

    function metaUpdateprovenance(
        bytes memory signature,
        uint[] memory intParams,
        string[] memory stringParams,
        uint256 nonce
    ) public {
        bytes32 hash = metaUpdateprovenanceHash(
            intParams,stringParams,nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _updateprovenance(signer,intParams,stringParams);
    }

    function metaUpdateprovenanceData(
        bytes memory signature,
        uint256 certificateId,
        string memory data,
        uint256 nonce
    ) public {
        bytes32 hash = metaUpdateprovenanceDataHash(
            certificateId,
            data,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _updateprovenanceData(
            signer,
            certificateId,
            data
        );
    }

  /* function metaTransfer(bytes memory signature, address to, uint256 tokenId, uint256 nonce) public {
        bytes32 hash = metaTransferHash(to, tokenId, nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _transferFrom(signer, to, tokenId);
    }

    function metaSetApprovalForAll(bytes memory signature, address spender, bool approved, uint256 nonce) public {
        bytes32 hash = metaSetApprovalForAllHash(spender, approved, nonce);
        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        require(spender != signer);

        _operatorApprovals[signer][spender] = approved;
        emit ApprovalForAll(signer, spender, approved);
    }

    function metaTransferHash(address to, uint256 tokenId, uint256 nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaTransfer", to, tokenId, nonce));
    }

    function metaSetApprovalForAllHash(address spender, bool approved, uint256 nonce) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaSetApprovalForAll", spender, approved, nonce));
    }
    */   
    function metaCreateprovenanceHash(
        provenance memory newprovenance,
        string memory uri,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaCreateprovenance",
            newprovenance.hercid,
            newprovenance.provenanceId,
            newprovenance.barId,
            newprovenance.serialnumber,
            newprovenance.price,
            newprovenance.timestamp,
            newprovenance.weight,
            newprovenance.assay,
            newprovenance.manufacturer,
            newprovenance.factomEntryHash,
            newprovenance.data,
            uri,
            nonce
        ));
    }

    function metaUpdateprovenanceHash(
        uint[] memory intParams,
        string[] memory stringParams,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaUpdateprovenance",
            intParams[0],
            intParams[1],
            intParams[2],
            intParams[3],
            intParams[4],
            intParams[5],
            stringParams[0],
            stringParams[1],
            stringParams[2],
            stringParams[3],
            stringParams[4],
            nonce
        ));
    }

    function metaUpdateprovenanceDataHash(
        uint256 provenanceId,
        string memory data,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaUpdateprovenanceData",
             provenanceId,
            data,
            nonce
        ));
    }

    /**
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
