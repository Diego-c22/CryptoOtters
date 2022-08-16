// SPDX-License-Identifier: Mit

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./ERC721-upgradeable/ERC721AUpgradeable.sol";

/** @author Diego Cortes **/
/** @title Omniverse */
contract CryptoOtters is ERC721AUpgradeable, OwnableUpgradeable {
    /**
     * @dev Initialize upgradeable storage (constructor).
     * @custom:restriction This function only can be executed one time.
     */
    function initialize() public initializerERC721A initializer {
        __ERC721A_init({
            name_: "CryptoOtters",
            symbol_: "CXO",
            pricePublicSale_: 0.052 ether,
            pricePreSale_: 0.39 ether,
            amountForPreSale_: 1500,
            amountForPublicSale_: 8500,
            amountForFreeSale_: 10000,
            maxBatchSizePublicSale_: 3,
            maxBatchSizePreSale_: 3
        });
        __Ownable_init();
    }

    /**
     * @dev Mint NFT taking as reference presale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function preSaleMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._preSaleActive,
            "Presale is not active"
        );
        require(
            ERC721AStorage.layout()._amountForPreSale >=
                (ERC721AStorage.layout()._preSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );
        require(
            ERC721AStorage.layout()._tokensBoughtPreSale[msg.sender] +
                quantity <=
                ERC721AStorage.layout()._maxBatchSizePreSale,
            "Transfer exceeds max amount."
        );
        uint256 amount = quantity * ERC721AStorage.layout()._pricePreSale;
        require(msg.value == amount, "Price not covered.");
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._preSaleCurrentIndex += quantity;
            ERC721AStorage.layout()._tokensBoughtPreSale[
                msg.sender
            ] += quantity;
        }
    }

    /**
     * @dev Mint NFT taking as reference public sale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function publicSaleMint(uint256 quantity) external payable {
        require(
            ERC721AStorage.layout()._publicSaleActive,
            "Public sale is not active"
        );
        require(
            ERC721AStorage.layout()._amountForPublicSale >=
                (ERC721AStorage.layout()._publicSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );
        require(
            ERC721AStorage.layout()._tokensBoughtPublicSale[msg.sender] +
                quantity <=
                ERC721AStorage.layout()._maxBatchSizePublicSale,
            "Transfer exceeds max amount."
        );
        uint256 amount = quantity * ERC721AStorage.layout()._pricePublicSale;
        require(msg.value == amount, "Price not covered.");
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._publicSaleCurrentIndex += quantity;
            ERC721AStorage.layout()._tokensBoughtPublicSale[
                msg.sender
            ] += quantity;
        }
    }

    /**
     * @dev Mint NFT taking as reference public sale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function ownerMint(uint256 quantity) external onlyOwner {
        require(
            ERC721AStorage.layout()._amountForFreeSale >=
                (ERC721AStorage.layout()._freeSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._freeSaleCurrentIndex += quantity;
        }
    }

    /**
     * @dev active or deactivate public sale.
     * @param status Use true to activate or false to deactivate.
     * @custom:restriction Only owner can execute this function
     */
    function activePublicSale(bool status) external onlyOwner {
        ERC721AStorage.layout()._publicSaleActive = status;
    }

    /**
     * @dev active or deactivate pre-sale.
     * @param status Use true to activate or false to deactivate.
     * @custom:restriction Only owner can execute this function
     */
    function activePreSale(bool status) external onlyOwner {
        ERC721AStorage.layout()._preSaleActive = status;
    }

    /**
     * @dev Set base URI.
     * @param baseURI_ A string used as base to generate nfts.
     * @custom:restriction Only owner can execute this function
     */
    function setBaseURI(string memory baseURI_) external onlyOwner {
        ERC721AStorage.layout()._baseUri = baseURI_;
    }

    /**
     * @dev Set hidden base URI.
     * @param baseURI_ A string used as url when base url is hidden to generate nfts.
     * @custom:restriction Only owner can execute this function
     */
    function setHiddenBaseURI(string memory baseURI_) external onlyOwner {
        ERC721AStorage.layout()._hiddenBaseUri = baseURI_;
    }

    /**
     * @dev Change quantity of tokens for public sale.
     * @param quantity Quantity of tokens for public sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPublicSaleQuantity(uint256 quantity) external onlyOwner {
        require(quantity >= 0, "Quantity must be greater than 0");
        ERC721AStorage.layout()._amountForPublicSale = quantity;
    }

    /**
     * @dev Change quantity of tokens for pre sale.
     * @param quantity Quantity of tokens for pre sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPreSaleQuantity(uint256 quantity) external onlyOwner {
        require(quantity >= 0, "Quantity must be greater than 0");
        ERC721AStorage.layout()._amountForPreSale = quantity;
    }

    /**
     * @dev Change quantity of tokens for free sale.
     * @param quantity Quantity of tokens for free sale.
     * @custom:restriction Only owner can execute this function
     */
    function setFreeSaleQuantity(uint256 quantity) external onlyOwner {
        require(quantity >= 0, "Quantity must be greater than 0");
        ERC721AStorage.layout()._amountForFreeSale = quantity;
    }

    /**
     * @dev Change price for tokens of public sale.
     * @param price Price for tokens of public sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPublicSalePrice(uint256 price) external onlyOwner {
        require(price >= 0, "Price must be greater than 0");
        ERC721AStorage.layout()._pricePublicSale = price;
    }

    /**
     * @dev Change price for tokens of pre sale.
     * @param price Price for tokens of pre sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPreSalePrice(uint256 price) external onlyOwner {
        require(price >= 0, "Price must be greater than 0");
        ERC721AStorage.layout()._pricePreSale = price;
    }

    /**
     * @dev Change limit per wallet for tokens of pre sale.
     * @param limit quantity of tokens allowed per wallet in pre sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPreSaleLimit(uint256 limit) external onlyOwner {
        require(limit > 0, "Limit must be greater than 0");
        ERC721AStorage.layout()._maxBatchSizePreSale = limit;
    }

    /**
     * @dev Change limit per wallet for tokens of public sale.
     * @param limit quantity of tokens allowed per wallet in public sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPublicSaleLimit(uint256 limit) external onlyOwner {
        require(limit > 0, "Limit must be greater than 0");
        ERC721AStorage.layout()._maxBatchSizePublicSale = limit;
    }

    /**
     * @dev Get all the balance of the contract (profits).
     * @custom:restriction Only owner can execute this function
     */
    function getProfits() external onlyOwner {
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Failed to send Ether");
    }

    /**
     * @dev Hidde or show baseURI.
     * @param status Use true to show or false to hidde.
     * @custom:restriction Only owner can execute this function
     */
    function revelBaseURI(bool status) external onlyOwner {
        ERC721AStorage.layout()._reveled = status;
    }

    /**
     * @notice Called with the sale price to determine how much royalty
     *          is owed and to whom.
     * @param _tokenId - the NFT asset queried for royalty information
     * @param _salePrice - the sale price of the NFT asset specified by _tokenId
     * @return receiver - address of who should be sent the royalty payment
     * @return royaltyAmount - the royalty payment amount for _salePrice
     */
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        uint256 amount = ((_salePrice * 10) / 100);
        return (owner(), amount);
    }

    function getTokensOfAddress(address address_)
        external
        view
        returns (string[] memory)
    {
        return _getTokensOfAddress(address_);
    }

    function preSalePrice() external view returns (uint256) {
        return ERC721AStorage.layout()._pricePreSale;
    }

    function publicSalePrice() external view returns (uint256) {
        return ERC721AStorage.layout()._pricePublicSale;
    }

    function amountForPublicSale() external view returns (uint256) {
        return ERC721AStorage.layout()._amountForPublicSale;
    }

    function amountForPreSale() external view returns (uint256) {
        return ERC721AStorage.layout()._amountForPreSale;
    }

    function uriSuffix() external view returns (string memory) {
        return ERC721AStorage.layout()._uriSuffix;
    }

    function setUriSuffix(string memory uriSuffix_)
        external
        onlyOwner
        returns (string memory)
    {
        return ERC721AStorage.layout()._uriSuffix = uriSuffix_;
    }

    function baseURI() external view returns (string memory) {
        return ERC721AStorage.layout()._baseUri;
    }
}