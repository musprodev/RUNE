// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract RuneToken is ERC20, Ownable {
    // Structure to represent a whitelist round
    struct WhitelistRound {
        bool active;  // Indicates if the round is active
        uint256 fee;  // Fee for claiming in this round
        mapping(address => bool) addresses;  // Mapping of whitelisted addresses
    }

    address public siteOwner;  // Address of the site owner
    uint256 public claimableSupply;  // Total supply available for claiming
    uint256 public totalRounds;  // Counter for the total number of whitelist rounds
    mapping(uint256 => WhitelistRound) public whitelistRounds;  // Mapping of whitelist rounds

    // Events for logging important actions
    event Whitelisted(uint256 round, address indexed account);
    event RemovedFromWhitelist(uint256 round, address indexed account);
    event Claimed(uint256 round, address indexed claimant, uint256 amount);
    event ServiceFeeSet(uint256 round, uint256 newFee);
    event FeesDistributed(address siteOwner, uint256 siteOwnerFee, address founder, uint256 founderFee);

    // Constructor to initialize the contract with total supply and site owner address
    constructor(uint256 _totalSupply, address _siteOwner) ERC20("RuneToken", "RUNE") Ownable(_siteOwner) {
        _mint(_siteOwner, _totalSupply);
        claimableSupply = _totalSupply;
        siteOwner = _siteOwner;
        totalRounds = 0;
    }

    // Modifier to restrict access to whitelisted addresses in a specific round
    modifier onlyWhitelisted(uint256 round) {
        require(whitelistRounds[round].addresses[msg.sender], "Not whitelisted");
        _;
    }

    // Function to create a new whitelist round with a specified fee
    function createWhitelistRound(uint256 fee) external onlyOwner {
        totalRounds = totalRounds + 1;
        whitelistRounds[totalRounds].active = true;
        whitelistRounds[totalRounds].fee = fee;
    }

    // Function to add addresses to the whitelist of a specific round
    function addToWhitelist(uint256 round, address[] calldata _addresses) external onlyOwner {
        require(whitelistRounds[round].active, "Whitelist round not active");
        for (uint i = 0; i < _addresses.length; i++) {
            whitelistRounds[round].addresses[_addresses[i]] = true;
            emit Whitelisted(round, _addresses[i]);
        }
    }

    // Function to remove an address from the whitelist of a specific round
    function removeFromWhitelist(uint256 round, address _address) external onlyOwner {
        require(whitelistRounds[round].active, "Whitelist round not active");
        whitelistRounds[round].addresses[_address] = false;
        emit RemovedFromWhitelist(round, _address);
    }

    // Function to set the service fee for a specific whitelist round
    function setServiceFee(uint256 round, uint256 fee) external onlyOwner {
        require(whitelistRounds[round].active, "Whitelist round not active");
        whitelistRounds[round].fee = fee;
        emit ServiceFeeSet(round, fee);
    }

    // Function for whitelisted users to claim their tokens
    function claim(uint256 round, uint256 claimAmount) external payable onlyWhitelisted(round) {
        require(whitelistRounds[round].active, "Whitelist round not active");
        require(claimAmount <= balanceOf(siteOwner), "Insufficient token balance");

        uint256 fee = whitelistRounds[round].fee;
        require(msg.value >= fee, "Insufficient fee");

        // Distribute the service fee
        uint256 siteOwnerFee = fee * 10 / 100;
        uint256 founderFee = fee - siteOwnerFee;
        payable(siteOwner).transfer(siteOwnerFee);
        payable(owner()).transfer(founderFee);
        emit FeesDistributed(siteOwner, siteOwnerFee, owner(), founderFee);

        // Transfer tokens to the claimer
        _transfer(siteOwner, msg.sender, claimAmount);
        whitelistRounds[round].addresses[msg.sender] = false;

        emit Claimed(round, msg.sender, claimAmount);
    }

    // Helper function to get details of a whitelist round
    function getWhitelistRoundDetails(uint256 round) external view returns (bool, uint256) {
        return (whitelistRounds[round].active, whitelistRounds[round].fee);
    }

    // Helper function to check if an address is whitelisted in a specific round
    function isAddressWhitelisted(uint256 round, address addr) external view returns (bool) {
        return whitelistRounds[round].addresses[addr];
    }
}
