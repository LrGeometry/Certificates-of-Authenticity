/* solhint-disable no-empty-blocks */

pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;

import "./openzeppelin/ERC721Full.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


/**
 * @title Certificate of Ownership
 * @dev This is our main contract
 */
contract COO is ERC721Full, Ownable {
    /**
     * @dev This contract must be linked to a token
     * @param newTokenAddress The address of the linked token
     */
    constructor(address newTokenAddress) public ERC721Full(
        "Certificate Of Ownership",
        "COO"
    ) {
        tokenAddress = newTokenAddress;
    }

    address public tokenAddress;

    uint256 public constant CONTRACT_CREATION_PRICE = 0 * 10 ** 18;
    uint256 public constant CONTRACT_UPDATE_PRICE = 0 * 10 ** 18;

    struct Certificate {
        uint256 assetId;
        string name;
        string label;
        uint256 price;
        uint256 timestamp;
        string factomEntryHash;
        string anotherEncryptionKey;
        string data;
    }

    Certificate[] internal certificates;

    function createCertificate(
        Certificate memory newCertificate,
        string memory uri
    ) public {
        _createCertificate(msg.sender, newCertificate, uri);
    }

    function updateCertificate(
        uint256 certificateId,
        string memory name,
        string memory label,
        uint256 price,
        string memory factomEntryHash,
        string memory anotherEncryptionKey,
        string memory data
    ) public {
        _updateCertificate(
            msg.sender,
            certificateId,
            name,
            label,
            price,
            factomEntryHash,
            anotherEncryptionKey,
            data
        );
    }

    function updateCertificateData(
        uint256 certificateId,
        string memory data
    ) public {
        _updateCertificateData(
            msg.sender,
            certificateId,
            data
        );
    }

    /**
     * @dev Gets a certificate and the related information, can only be called by the certificate owner
     * @param certificateId The id of a certificate
     * @return The required certificate
     */
    function getCertificate(
        uint256 certificateId
    ) public view returns (
        Certificate memory
    ) {
        return certificates[certificateId];
    }

    /**
     * @dev Creates a new certificate and links it to the sender
     * @param newCertificate The new certificate to create
     * @param certificateOwner The address that will receive the new certificate
     */
    function _createCertificate(
        address certificateOwner,
        Certificate memory newCertificate,
        string memory uri
    ) internal {
        IERC20 token = IERC20(tokenAddress);

        require(
            token.allowance(certificateOwner, address(this)) >= CONTRACT_CREATION_PRICE,
            "Contract is not allowed to manipulate sender funds"
        );

        require(
            token.transferFrom(certificateOwner, address(this), CONTRACT_CREATION_PRICE),
            "Transfer failed"
        );

        uint256 certificateId = certificates.push(
            Certificate({
                assetId: newCertificate.assetId,
                name: newCertificate.name,
                label: newCertificate.label,
                price: newCertificate.price,
                timestamp: newCertificate.timestamp,
                factomEntryHash: newCertificate.factomEntryHash,
                anotherEncryptionKey: newCertificate.anotherEncryptionKey,
                data: newCertificate.data
            })
        ) - 1;

        _mint(certificateOwner, certificateId);
        _setTokenURI(certificateId, uri);
    }

    /**
     * @dev Updates the information of a certificate, can only be called by the certificate owner
     * @param certificateOwner The address of the owner of the certificate
     * @param certificateId The id of the certificate to update
     * @param name The new name of the asset
     * @param label The new label of the asset
     * @param price The new price of the asset
     * @param factomEntryHash The new factom entry hash of the asset
     * @param anotherEncryptionKey Another new encryption key
     * @param data The hash linked to the file containing the data
     */
    function _updateCertificate(
        address certificateOwner,
        uint256 certificateId,
        string memory name,
        string memory label,
        uint256 price,
        string memory factomEntryHash,
        string memory anotherEncryptionKey,
        string memory data
    ) internal {
        IERC20 token = IERC20(tokenAddress);

        require(
            token.allowance(certificateOwner, address(this)) >= CONTRACT_UPDATE_PRICE,
            "Contract is not allowed to manipulate sender funds"
        );

        require(
            token.transferFrom(certificateOwner, address(this), CONTRACT_UPDATE_PRICE),
            "Transfer failed"
        );

        require(ownerOf(certificateId) == certificateOwner, "Certificates can only be updated by their owners");

        certificates[certificateId].name = name;
        certificates[certificateId].label = label;
        certificates[certificateId].price = price;
        certificates[certificateId].factomEntryHash = factomEntryHash;
        certificates[certificateId].anotherEncryptionKey = anotherEncryptionKey;
        certificates[certificateId].data = data;
    }

    function _updateCertificateData(
        address certificateOwner,
        uint256 certificateId,
        string memory data
    ) internal {
        require(ownerOf(certificateId) == certificateOwner, "Certificates can only be updated by their owners");

        certificates[certificateId].data = data;
    }
}
