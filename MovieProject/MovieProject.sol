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

    uint256 public totalSpentTokens;

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
        totalSpentTokens = 0;
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

    // Function to change token price, can only be called by the creator
    function changeTokenPrice(uint256 newPrice) external onlyCreator projectNotCompleted {
        tokenPrice = newPrice;
    }

    // Function to change token supply, can only be called by the creator
    function changeTokenSupply(uint256 newSupply) external onlyCreator projectNotCompleted {
        tokenSupply = newSupply;
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

    // Function for supporter to spend tokens and watch the movie
    function spendToken(address supporter, uint256 amount) external {
        // external oracle logic for streaming the movie

        // Deduct the spent tokens from the supporter's balance
        _burn(supporter, amount);

        // Increment the total spent tokens counter
        totalSpentTokens += amount;
    }

    // Function to dispense pledges when threshold is reached
    function dispensePledge() external onlyCreator {
        require(totalSpentTokens >= fundingThreshold, "Threshold not reached");

        // Emit the event to notify the dispense of pledges
        emit PledgesDispensed(totalSpentTokens);

        // Reset the spent tokens counter
        totalSpentTokens = 0;
    }

    function confirmUpload() external onlyCreator(){
        // Implement the movie uploading process

        projectCompleted = ture;
    }

}
