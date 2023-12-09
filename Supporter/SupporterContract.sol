// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WeTubeToken.sol";

/// @title SupporterContract - Contract for supporters to interact with WeTube tokens
contract SupporterContract is Ownable {
    WeTubeToken public tokenContract;

    /// @dev Events to track token activities
    event TokenPurchased(address indexed supporter, uint256 indexed tokenId);
    event TokenTransferred(address indexed from, address indexed to, uint256 indexed tokenId);
    event TokenSpent(address indexed supporter, uint256 indexed tokenId);

    /// @dev Constructor to set the WeTubeToken contract address
    constructor(address _tokenContract) {
        tokenContract = WeTubeToken(_tokenContract);
    }

    /// @dev Purchase tokens by sending Ether
    function buyToken() external payable {
        require(msg.value > 0, "Invalid pledge amount");

        // Mint a new token and assign it to the supporter
        uint256 tokenId = mintToken(msg.sender);

        emit TokenPurchased(msg.sender, tokenId);
    }

    /// @dev Transfer tokens to another supporter
    function transferToken(address to, uint256 tokenId) external {
        require(to != address(0), "Invalid recipient address");
        require(tokenContract.ownerOf(tokenId) == msg.sender, "You don't own this token");

        // Transfer token from the supporter to the recipient
        tokenContract.safeTransferFrom(msg.sender, to, tokenId);

        emit TokenTransferred(msg.sender, to, tokenId);
    }

    /// @dev Spend tokens to watch a movie
    function spendToken(uint256 tokenId) external {
        require(tokenContract.ownerOf(tokenId) == msg.sender, "You don't own this token");

        // Burn the token (simplified example, in a real scenario, you might want to handle the movie streaming logic)
        tokenContract.safeTransferFrom(msg.sender, address(0), tokenId);

        emit TokenSpent(msg.sender, tokenId);
    }

    /// @dev Mint a new token and assign it to the supporter
    function mintToken(address to) internal returns (uint256) {
        uint256 tokenId = tokenContract.totalSupply() + 1;
        tokenContract.mint(to, tokenId);

        return tokenId;
    }
}
