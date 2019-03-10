/* solhint-disable no-empty-blocks */

pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;

import "./COO.sol";


/**
 * @title Certificate of Ownership Meta Transactions
 * @dev This contract handles our meta-transactions
 */
contract MetaCOO is COO {
    constructor(
        address newTokenAddress
    ) public COO(
        newTokenAddress
    ) {
    }

    mapping (address => uint256) public nonces;

    function metaCreateCertificate(
        bytes memory signature,
        Certificate memory newCertificate,
        string memory uri,
        uint256 nonce
    ) public {
        bytes32 hash = metaCreateCertificateHash(
            newCertificate,
            uri,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _createCertificate(signer, newCertificate, uri);
    }

    function metaUpdateCertificate(
        bytes memory signature,
        uint256 certificateId,
        string memory name,
        string memory label,
        uint256 price,
        string memory factomEntryHash,
        string memory anotherEncryptionKey,
        string memory data,
        uint256 nonce
    ) public {
        bytes32 hash = metaUpdateCertificateHash(
            certificateId,
            name,
            label,
            price,
            factomEntryHash,
            anotherEncryptionKey,
            data,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _updateCertificate(
            signer,
            certificateId,
            name,
            label,
            price,
            factomEntryHash,
            anotherEncryptionKey,
            data
        );
    }

    function metaUpdateCertificateData(
        bytes memory signature,
        uint256 certificateId,
        string memory data,
        uint256 nonce
    ) public {
        bytes32 hash = metaUpdateCertificateDataHash(
            certificateId,
            data,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _updateCertificateData(
            signer,
            certificateId,
            data
        );
    }

    function metaTransfer(bytes memory signature, address to, uint256 tokenId, uint256 nonce) public {
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

    function metaCreateCertificateHash(
        Certificate memory newCertificate,
        string memory uri,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaCreateCertificate",
            newCertificate.assetId,
            newCertificate.name,
            newCertificate.label,
            newCertificate.price,
            newCertificate.timestamp,
            newCertificate.factomEntryHash,
            newCertificate.anotherEncryptionKey,
            newCertificate.data,
            uri,
            nonce
        ));
    }

    function metaUpdateCertificateHash(
        uint256 certificateId,
        string memory name,
        string memory label,
        uint256 price,
        string memory factomEntryHash,
        string memory anotherEncryptionKey,
        string memory data,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaUpdateCertificate",
            certificateId,
            name,
            label,
            price,
            factomEntryHash,
            anotherEncryptionKey,
            data,
            nonce
        ));
    }

    function metaUpdateCertificateDataHash(
        uint256 certificateId,
        string memory data,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaUpdateCertificateData",
            certificateId,
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
