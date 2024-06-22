// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {RuneToken} from "../src/RuneToken.sol";

contract DeployRuneToken is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        uint256 initialSupply = 1000 * 10**18;
        address siteOwner = 0xf53a204f13408Ad8B0ed1c5292F78A1cb42BFF97; // replace with actual siteOwner address

        RuneToken runeToken = new RuneToken(initialSupply, siteOwner);

        vm.stopBroadcast();
    }
}
