// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WeTubePlatform.sol";
import "./MovieProject.sol";

contract SupporterContract {
    WeTubePlatform public platform;

    constructor(address _platform) {
        platform = WeTubePlatform(_platform);
    }

    // Function for a supporter to contribute to a specific movie project and get the project's NFT
    function contributeToProject(uint256 projectId, uint256 amount) external payable {
        // Get the address of the MovieProject contract associated with the projectId
        address projectAddress = platform.getProjectAddress(projectId);

        // Get the token price from the MovieProject contract
        uint256 tokenPrice = MovieProject(projectAddress).getTokenPrice();

        // Ensure the supporter has sent enough Ether
        require(msg.value >= amount * tokenPrice, "Insufficient Ether sent");

        // Contribute to the project and receive the project's NFT
        MovieProject(projectAddress).contribute(msg.sender, amount);

        // Emit an event to indicate the contribution and NFT minting
        emit ContributionAndMint(msg.sender, projectAddress, projectId, amount);
    }

    // Event emitted when a supporter contributes to a project and gets the project's NFT
    event ContributionAndMint(address indexed supporter, address indexed project, uint256 indexed projectId, uint256 amount);
}
