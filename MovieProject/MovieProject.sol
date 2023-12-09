// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WeTubeNFT.sol";

contract MovieProject is WeTubeNFT {
    address public creator;
    uint256 public fundingGoal;
    uint256 public fundingThreshold;
    uint256 public tokenPrice;
    uint256 public tokenSupply;
    uint256 public tokensSold;
    bool public projectCompleted;

    mapping(address => uint256) public contributions;
    mapping(address => bool) public earlySupporters;

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can call this function");
        _;
    }

    modifier projectNotCompleted() {
        require(!projectCompleted, "The project has already been completed");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _fundingGoal,
        uint256 _fundingThreshold,
        uint256 _tokenPrice,
        uint256 _tokenSupply
    ) WeTubeNFT(_name, _symbol) {
        creator = msg.sender;
        fundingGoal = _fundingGoal;
        fundingThreshold = _fundingThreshold;
        tokenPrice = _tokenPrice;
        tokenSupply = _tokenSupply;
        tokensSold = 0;
        projectCompleted = false;
    }

    // Function for the creator to mint NFTs
    function mint(address to, uint256 amount) external onlyCreator {
        _mint(to, amount);
    }

    // Function to get the token price
    function getTokenPrice() external view returns (uint256) {
        return tokenPrice;
    }

    // Function for supporters to contribute and mint NFTs
    function contribute(uint256 _amount) external payable projectNotCompleted {
        require(_amount > 0, "Contribution amount must be greater than 0");
        require(msg.value >= _amount * tokenPrice, "Insufficient Ether for contribution");

        mint(msg.sender, _amount);  // Mint NFTs for the supporter

        contributions[msg.sender] += _amount;

        if (!earlySupporters[msg.sender]) {
            earlySupporters[msg.sender] = true;
        }

        tokensSold += _amount;
    }

    // Function to get the current funds raised
    function getCurrentFundsRaised() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to get the funding goal
    function getFundingGoal() external view returns (uint256) {
        return fundingGoal;
    }

    // Function to set the project completion status, can only be called by the platform
    function setProjectCompleted(bool _completed) external onlyPlatform {
        projectCompleted = _completed;
    }


    // Function to withdraw funds, can only be called by the creator after project completion
    function withdraw() external onlyCreator {
        require(projectCompleted, "Project not yet completed");
        require(tokensSold >= fundingGoal, "Funding goal not met");

        address payable recipient = payable(msg.sender);
        address payable senderAddress = payable(address(this));
        (bool success, ) = recipient.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

}
