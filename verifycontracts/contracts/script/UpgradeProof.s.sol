//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {DummyUpgrade} from "../src/DummyUpgrade.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Proof} from "../src/Proof.sol";
contract UpgradeProof is Script {

    /**
     * @dev This contract is used to upgrade the Proof contract to a new implementation.
     * Havent added the initialization here. 
     */

    DummyUpgrade dummyUpgrade;

    address proxyAddress = 0xBC0eD4871060e61d23193Fd693805696C59Ef6F1; // IMPORTANT
    function run() external {

        vm.startBroadcast();

        // new implementation contract
        dummyUpgrade = new DummyUpgrade();

        Proof proof = Proof(proxyAddress);
        
        proof.upgradeToAndCall(address(dummyUpgrade),"");
        vm.stopBroadcast();

        console.log("Upgrade complete");
        console.log("New implementation address: ", address(dummyUpgrade));
        console.log("Proxy address: ", proxyAddress);
        
    }
}
