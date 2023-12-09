// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./WeTubeToken.sol";

/// @title WeTubePlatform - Main contract for WeTube platform
contract WeTubePlatform is Ownable {
    WeTubeToken public tokenContract;

    /// @dev Represents a crowdfunding project
    struct Project {
        address creator;
        uint256 fundingGoal;
        uint256 fundsRaised;
        bool completed;
    }

    mapping(uint256 => Project) public projects;

    /// @dev Events to track project and token activities
    event ProjectCreated(uint256 indexed projectId, address indexed creator, uint256 fundingGoal);
    event TokenPurchased(address indexed supporter, uint256 indexed tokenId);
    event ProjectCompleted(uint256 indexed projectId);

    /// @dev Constructor to set the WeTubeToken contract address
    constructor(address _tokenContract) {
        tokenContract = WeTubeToken(_tokenContract);
    }

    /// @dev Create a new crowdfunding project
    function createProject(uint256 fundingGoal) external {
        uint256 projectId = projects.length;

        projects[projectId] = Project({
            creator: msg.sender,
            fundingGoal: fundingGoal,
            fundsRaised: 0,
            completed: false
        });

        emit ProjectCreated(projectId, msg.sender, fundingGoal);
    }

    /// @dev Purchase tokens and support a project
    function purchaseTokens(uint256 projectId, uint256 amount) external payable {
        require(projectId < projects.length, "Invalid project");
        require(msg.value == amount, "Invalid pledge amount");

        uint256 tokenId = mintToken(msg.sender);

        projects[projectId].fundsRaised += amount;

        emit TokenPurchased(msg.sender, tokenId);
    }

    /// @dev Complete a crowdfunding project and release funds
    function completeProject(uint256 projectId) external onlyOwner {
        require(projectId < projects.length, "Invalid project");
        require(!projects[projectId].completed, "Project already completed");

        projects[projectId].completed = true;

        address creator = projects[projectId].creator;
        uint256 fundsRaised = projects[projectId].fundsRaised;
        payable(creator).transfer(fundsRaised);

        emit ProjectCompleted(projectId);
    }

    /// @dev Mint a new token and assign it to the supporter
    function mintToken(address to) internal returns (uint256) {
        uint256 tokenId = tokenContract.totalSupply() + 1;
        tokenContract.mint(to, tokenId);

        return tokenId;
    }
}
