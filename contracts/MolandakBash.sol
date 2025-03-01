// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MolandakBash {
    struct Player {
        uint256 bashCount;
        uint256 lastResetTime;
    }

    mapping(address => Player) public players;
    uint256 public constant REGISTRATION_FEE = 0.001 ether; // 0.001 MON
    uint256 public constant ROUND_DURATION = 60 seconds; // 1-minute rounds
    address public owner;

    event MolandakBashed(address indexed player, uint256 bashCount);
    event Registered(address indexed player);

    constructor() {
        owner = msg.sender;
    }

    function register() external payable {
        require(msg.value >= REGISTRATION_FEE, "Insufficient fee");
        require(players[msg.sender].bashCount == 0, "Already registered");
        players[msg.sender].lastResetTime = block.timestamp;
        emit Registered(msg.sender);
    }

    function bashMolandak() external {
        require(players[msg.sender].lastResetTime > 0, "Not registered");
        if (block.timestamp >= players[msg.sender].lastResetTime + ROUND_DURATION) {
            players[msg.sender].bashCount = 0;
            players[msg.sender].lastResetTime = block.timestamp;
        }
        players[msg.sender].bashCount += 1;
        emit MolandakBashed(msg.sender, players[msg.sender].bashCount);
    }

    function getBashCount(address player) external view returns (uint256) {
        return players[player].bashCount;
    }

    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
