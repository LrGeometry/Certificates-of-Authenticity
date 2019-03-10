/* solhint-disable not-rely-on-time */

pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;

import "./Marketplace.sol";


/**
 * @title MetaMarketplace contract
 * @dev This contract handles the meta transactions for our marketplace
 */
contract MetaMarketplace is Marketplace {
    /**
     * @dev This contract needs to be linked to a token and an NFT contract
     * @param initialTokenContractAddress The address of the token
     * @param initialCooContractAddress The address of the NFT contract
     */
    constructor(
        address initialTokenContractAddress,
        address initialCooContractAddress
    ) public Marketplace(
        initialTokenContractAddress,
        initialCooContractAddress
    ) {
        tokenContractAddress = initialTokenContractAddress;
        cooContractAddress = initialCooContractAddress;
    }

    mapping (address => uint256) public nonces;

    function metaCreateSale(
        bytes memory signature,
        uint256 certificateId,
        uint256 price,
        uint256 expiresAt,
        uint256 nonce
    ) public {
        bytes32 hash = metaCreateSaleHash(
            certificateId,
            price,
            expiresAt,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _createSale(
            signer,
            certificateId,
            price,
            expiresAt
        );
    }

    function metaCancelSale(
        bytes memory signature,
        uint256 saleId,
        uint256 nonce
    ) public {
        bytes32 hash = metaCancelSaleHash(
            saleId,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _cancelSale(
            signer,
            saleId
        );
    }

    function metaExecuteSale(
        bytes memory signature,
        uint256 saleId,
        uint256 nonce
    ) public {
        bytes32 hash = metaExecuteSaleHash(
            saleId,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _executeSale(
            signer,
            saleId
        );
    }

    function metaCreateAuction(
        bytes memory signature,
        uint256 certificateId,
        uint256 startingPrice,
        uint256 expiresAt,
        uint256 nonce
    ) public {
        bytes32 hash = metaCreateAuctionHash(
            certificateId,
            startingPrice,
            expiresAt,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _createAuction(
            signer,
            certificateId,
            startingPrice,
            expiresAt
        );
    }

    function metaCancelAuction(
        bytes memory signature,
        uint256 auctionId,
        uint256 nonce
    ) public {
        bytes32 hash = metaCancelAuctionHash(
            auctionId,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _cancelAuction(
            signer,
            auctionId
        );
    }

    function metaExecuteAuction(
        bytes memory signature,
        uint256 auctionId,
        uint256 amount,
        uint256 nonce
    ) public {
        bytes32 hash = metaExecuteAuctionHash(
            auctionId,
            amount,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _executeAuction(
            signer,
            auctionId,
            amount
        );
    }

    function metaCompleteAuction(
        bytes memory signature,
        uint256 auctionId,
        uint256 nonce
    ) public {
        bytes32 hash = metaCompleteAuctionHash(
            auctionId,
            nonce
        );

        address signer = getSigner(hash, signature);

        require(signer != address(0), "Cannot get signer");
        require(nonce == nonces[signer], "Nonce is invalid");

        nonces[signer] += 1;

        _completeAuction(
            signer,
            auctionId
        );
    }

    function metaCreateSaleHash(
        uint256 certificateId,
        uint256 price,
        uint256 expiresAt,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaCreateSale",
            certificateId,
            price,
            expiresAt,
            nonce
        ));
    }

    function metaCancelSaleHash(
        uint256 certificateId,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaCancelSale",
            certificateId,
            nonce
        ));
    }

    function metaExecuteSaleHash(
        uint256 saleId,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaExecuteSale",
            saleId,
            nonce
        ));
    }

    function metaCreateAuctionHash(
        uint256 certificateId,
        uint256 startingPrice,
        uint256 expiresAt,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            "metaCreateAuction",
            certificateId,
            startingPrice,
            expiresAt,
            nonce
        ));
    }

    function metaCancelAuctionHash(
        uint256 auctionId,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            auctionId,
            nonce
        ));
    }

    function metaExecuteAuctionHash(
        uint256 auctionId,
        uint256 amount,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            auctionId,
            amount,
            nonce
        ));
    }

    function metaCompleteAuctionHash(
        uint256 auctionId,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(
            address(this),
            auctionId,
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
