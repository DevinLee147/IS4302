// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract WeTubeNFT is ERC721Enumerable {
    // Mapping from MovieProject address to a boolean indicating whether it is associated with this NFT contract
    mapping(address => bool) public isMovieProject;

    // Constructor to set the name and symbol
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // Modifier to ensure that only associated MovieProjects can call certain functions
    modifier onlyMovieProject() {
        require(isMovieProject[msg.sender], "Only associated MovieProjects can call this function");
        _;
    }

    // Function to mint NFTs, can only be called by associated MovieProjects
    function mint(address to, uint256 amount) external onlyMovieProject {
        _mint(to, amount);
    }

    // Function to associate a MovieProject with this NFT contract, can only be called by the contract owner
    function associateMovieProject(address movieProject) external onlyOwner {
        isMovieProject[movieProject] = true;
    }

    // Function to remove association with a MovieProject, can only be called by the contract owner
    function disassociateMovieProject(address movieProject) external onlyOwner {
        isMovieProject[movieProject] = false;
    }
}
