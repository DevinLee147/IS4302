// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title WeTubeToken - ERC721 token contract for WeTube platform
contract WeTubeToken is ERC721, Ownable {
    /// @dev Constructor to initialize the ERC721 token
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    /// @dev Mint new tokens and assign them to the owner
    function mint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }
}
