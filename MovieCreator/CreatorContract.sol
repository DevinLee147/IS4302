// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CreatorContract - ERC721 token contract for project creators
contract CreatorContract is ERC721, Ownable {
    uint256 public nextProjectId = 1;
    uint256 public fundingGoal;
    mapping(uint256 => uint256) public projectFunds;

    /// @dev Events to track project and funding activities
    event ProjectCreated(address indexed creator, uint256 indexed projectId, string projectTitle);
    event FundsReceived(address indexed supporter, uint256 indexed projectId, uint256 amount);

    /// @dev Constructor to initialize the ERC721 token and set the funding goal
    constructor(string memory name, string memory symbol, uint256 _fundingGoal) ERC721(name, symbol) {
        fundingGoal = _fundingGoal;
    }

    /// @dev Create a new project
    function createProject(string memory projectTitle) external {
        require(nextProjectId <= 10000, "Project limit reached");

        _safeMint(msg.sender, nextProjectId);

        emit ProjectCreated(msg.sender, nextProjectId, projectTitle);

        nextProjectId++;
    }

    /// @dev Receive funds for a project
    function receiveFunds(uint256 projectId) external payable {
        require(ownerOf(projectId) != address(0), "Invalid project");
        require(msg.value > 0, "Invalid pledge amount");

        projectFunds[projectId] += msg.value;

        emit FundsReceived(msg.sender, projectId, msg.value);
    }

    /// @dev Check if a project has reached its funding goal
    function hasReachedGoal(uint256 projectId) external view returns (bool) {
        return projectFunds[projectId] >= fundingGoal;
    }
}
