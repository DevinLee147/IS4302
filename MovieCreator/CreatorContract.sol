// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WeTubePlatform.sol";

contract CreatorContract {
    WeTubePlatform public platform;

    // Event emitted when a creator creates a new project
    event ProjectCreated(address indexed creator, address indexed project, uint256 indexed projectId);

    constructor(address _platform) {
        platform = WeTubePlatform(_platform);
    }

    // Function for a creator to create a new movie project
    function createProject(
        string memory projectName,
        string memory projectSymbol,
        uint256 fundingGoal,
        uint256 fundingThreshold,
        uint256 tokenPrice,
        uint256 tokenSupply
    ) external {
        // Call the createProject function on the WeTubePlatform contract
        platform.createProject(
            projectName,
            projectSymbol,
            fundingGoal,
            fundingThreshold,
            tokenPrice,
            tokenSupply
        );

        // Emit an event to indicate the creation of a new project
        emit ProjectCreated(msg.sender, address(this), platform.getProjectCounter());
    }
}
