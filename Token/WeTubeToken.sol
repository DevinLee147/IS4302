// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WeTubeNFT is ERC721Enumerable, Ownable {
    uint256 public nextTokenId = 1;
    uint256 public tokenPrice;

    event TokenPurchased(address indexed supporter, uint256 indexed tokenId);

    // Constructor initializes the ERC721 contract and sets the token price
    constructor(string memory name, string memory symbol, uint256 _tokenPrice) ERC721(name, symbol) {
        tokenPrice = _tokenPrice;
    }

    // Mint new NFTs and assign them to a specified address
    function mint(address to) external onlyOwner {
        // Ensure the token limit is not exceeded
        require(nextTokenId <= 10000, "Token limit reached");

        // Mint a new NFT and assign it to the specified address
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    // Purchase NFTs by sending the required amount of Ether
    function purchaseToken() external payable {
        // Ensure the correct amount of Ether is sent
        require(msg.value == tokenPrice, "Invalid pledge amount");

        // Mint a new NFT and assign it to the supporter
        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;

        // Send Ether to the platform owner
        payable(owner()).transfer(msg.value);

        // Emit an event to record the NFT purchase
        emit TokenPurchased(msg.sender, nextTokenId - 1);
    }
}
