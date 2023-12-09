// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {WeTubeNFT} from "./WeTubeToken.sol";

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

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _fundingGoal,
        uint256 _fundingThreshold,
        uint256 _tokenPrice,
        uint256 _tokenSupply
    ) WeTubeNFT(_name, _symbol, _tokenPrice) {
        creator = msg.sender;
        fundingGoal = _fundingGoal;
        fundingThreshold = _fundingThreshold;
        tokenSupply = _tokenSupply;
        tokensSold = 0;
        projectCompleted = false;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can call this function");
        _;
    }

    modifier projectNotCompleted() {
        require(!projectCompleted, "The project has already been completed");
        _;
    }

    function contribute(uint256 _amount) external payable projectNotCompleted {
        require(_amount > 0, "Contribution amount must be greater than 0");
        require(msg.value == _amount * tokenPrice, "Invalid contribution amount");

        _mint(msg.sender, _amount);
        contributions[msg.sender] += _amount;

        if (!earlySupporters[msg.sender]) {
            earlySupporters[msg.sender] = true;
        }

        tokensSold += _amount;
    }

    function completeProject() external onlyCreator projectNotCompleted {
        require(tokensSold >= fundingThreshold, "Funding threshold not met");
        require(address(this).balance >= fundingGoal, "Funding goal not met");
        projectCompleted = true;
    }

    function withdraw() external onlyCreator{
        address payable recipient = payable(msg.sender); // Convert msg.sender to a payable address
        address payable senderAddress = payable(address(this)); // Convert this address to a payable address
        (bool success, ) = recipient.call{value: address(this).balance}(""); 
        require(success, "Transfer failed");
    }

}
