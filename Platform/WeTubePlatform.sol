// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MovieProject.sol";

contract WeTubePlatform {
    // Event emitted when a new project is created
    event ProjectCreated(address indexed creator, address indexed project, uint256 indexed projectId);

    // Mapping from project ID to the corresponding MovieProject contract
    mapping(uint256 => address) private projects;

    // Counter to track the number of created projects
    uint256 private projectCounter;

    // Modifier to ensure that only the platform owner can call certain functions
    modifier onlyPlatformOwner() {
        require(msg.sender == platformOwner, "Only the platform owner can call this function");
        _;
    }

    // Address of the platform owner
    address public platformOwner;

    // Constructor to set the platform owner
    constructor() {
        platformOwner = msg.sender;
    }

    // Function to allow creators to create a new MovieProject
    function createProject(
        string memory projectName,
        string memory projectSymbol,
        uint256 fundingGoal,
        uint256 fundingThreshold,
        uint256 tokenPrice,
        uint256 tokenSupply
    ) external {
        // Create a new MovieProject contract
        MovieProject newProject = new MovieProject(
            projectName,
            projectSymbol,
            fundingGoal,
            fundingThreshold,
            tokenPrice,
            tokenSupply
        );

        // Increment the project counter
        projectCounter++;

        // Map the project ID to the new MovieProject contract address
        projects[projectCounter] = address(newProject);

        // Emit an event to indicate the creation of a new project
        emit ProjectCreated(msg.sender, address(newProject), projectCounter);
    }

    // Function to set the project completion status, can only be called by the platform owner
    function setProjectCompleted(uint256 projectId) external onlyPlatformOwner {
        MovieProject project = MovieProject(projects[projectId]);

        // Check if the project has reached its funding goal
        require(project.getCurrentFundsRaised() >= project.getFundingGoal(), "Project has not reached its funding goal");

        // Set the project completion status
        project.setProjectCompleted(true);
    }

    // Function to get the address of a specific project by ID
    function getProjectAddress(uint256 projectId) external view returns (address) {
        return projects[projectId];
    }
}
