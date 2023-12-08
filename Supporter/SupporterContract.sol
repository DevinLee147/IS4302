// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./WeTubeToken.sol";

contract SupporterContract {
    address public owner;
    address public platform;
    WeTubeToken public tokenContract;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyPlatform() {
        require(msg.sender == platform, "Not the platform");
        _;
    }

    constructor(address _platform, address _tokenContract) {
        owner = msg.sender;
        platform = _platform;
        tokenContract = WeTubeToken(_tokenContract);
    }

    function buyToken(uint amount) external payable {
        require(amount > 0 && msg.value == amount * tokenContract.tokenPrice(), "Invalid pledge amount");
        require(tokenContract.balanceOf(address(this)) >= amount, "Insufficient tokens available");

        // Associate the purchased tokens with the supporter
        tokenContract.transfer(msg.sender, amount);
    }

    function transferToken(address to, uint amount) external {
        require(amount > 0, "Invalid transfer amount");
        require(tokenContract.balanceOf(msg.sender) >= amount, "Insufficient balance");

        tokenContract.transferFrom(msg.sender, to, amount);
    }

    function spendToken() external {
        require(tokenContract.balanceOf(msg.sender) > 0, "No tokens to spend");

        // Implement logic for spending tokens to stream the movie

        // Transfer the spent token from supporter to the platform
        tokenContract.transfer(platform, 1);

        // Emit an event or perform other actions based on the movie streaming.
        // emit MovieStreamed(projectAddress, msg.sender, now);
    }

}
