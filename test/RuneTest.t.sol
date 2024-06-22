// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {RuneToken} from "../src/RuneToken.sol";

contract RuneTokenTest is Test {
    RuneToken public runeToken;
    address public owner = address(0x123);
    address public siteOwner = address(0x456);
    uint256 public initialSupply = 1000 * 10**18;

    function setUp() public {
        // Deploy the contract as the site owner
        runeToken = new RuneToken(initialSupply, siteOwner);
        // Transfer ownership to the intended owner
        vm.prank(siteOwner);
        runeToken.transferOwnership(owner);
    }

    function testInitialSupply() public view {
        assertEq(runeToken.totalSupply(), initialSupply);
        assertEq(runeToken.balanceOf(siteOwner), initialSupply);
    }

    function testCreateWhitelistRound() public {
        vm.prank(owner);
        runeToken.createWhitelistRound(1 ether);

        (bool active, uint256 fee) = runeToken.getWhitelistRoundDetails(1);
        assertTrue(active);
        assertEq(fee, 1 ether);
    }

    function testAddToWhitelist() public {
        vm.prank(owner);
        runeToken.createWhitelistRound(1 ether);

        address[] memory addresses = new address[](2);
        addresses[0] = address(0x789);
        addresses[1] = address(0xABC);

        vm.prank(owner);
        runeToken.addToWhitelist(1, addresses);

        assertTrue(runeToken.isAddressWhitelisted(1, addresses[0]));
        assertTrue(runeToken.isAddressWhitelisted(1, addresses[1]));
    }

    function testClaim() public {
        vm.prank(owner);
        runeToken.createWhitelistRound(1 ether);

        address[] memory addresses = new address[](1);
        addresses[0] = address(0x789);

        vm.prank(owner);
        runeToken.addToWhitelist(1, addresses);

        uint256 claimAmount = 10 * 10**18;
        vm.deal(addresses[0], 2 ether);

        vm.prank(addresses[0]);
        runeToken.claim{value: 1 ether}(1, claimAmount);

        assertEq(runeToken.balanceOf(addresses[0]), claimAmount);
        assertEq(runeToken.balanceOf(siteOwner), initialSupply - claimAmount);
    }
}
