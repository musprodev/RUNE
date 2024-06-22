// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {RuneToken} from "../src/RuneToken.sol";

contract DeployRune is Script {
    function run() external {
        uint256 initialSupply = 1_000_000 * 1e18;  // Adjust as needed
        address siteOwner = 0xf53a204f13408Ad8B0ed1c5292F78A1cb42BFF97; // Replace with the actual site owner address

        vm.startBroadcast();

        new RuneToken(initialSupply, siteOwner);

        vm.stopBroadcast();
    }
}