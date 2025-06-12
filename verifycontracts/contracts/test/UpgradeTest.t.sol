//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Proof} from "../src/Proof.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DummyUpgrade} from "../src/DummyUpgrade.sol";

/**
 * Core -
 * Hemi - 30329
 * Sonic - 30332
 */
contract UpgradeTest is Test {
    DummyUpgrade dummyUpgrade;

    uint256 holeskyFork;

    address proxyAddress = 0xBC0eD4871060e61d23193Fd693805696C59Ef6F1;

    function setUp() external {
        holeskyFork = vm.createSelectFork(
            "https://eth-holesky.g.alchemy.com/v2/29b6W9IbhFqdunO5kwC7nUP507eJAlZI"
        );
        vm.startPrank(0x096DD3EBFab85c85309477DDf3A18FC31ecBa33a);
        upgrade();
        vm.stopPrank();
    }

    function upgrade() public {
        vm.selectFork(holeskyFork);

        // new implementation contract
        dummyUpgrade = new DummyUpgrade();

        Proof proof = Proof(proxyAddress);
        proof.upgradeToAndCall(address(dummyUpgrade), "");
        
        console.log("Upgrade complete");
        console.log("New implementation address: ", address(dummyUpgrade));
        console.log("Proxy address: ", proxyAddress);
    }

    function test_upgrade() public {
        vm.selectFork(holeskyFork);
        dummyUpgrade = DummyUpgrade(0xBC0eD4871060e61d23193Fd693805696C59Ef6F1);
        console.log("Newer version of contract", dummyUpgrade.version());
        assertEq(dummyUpgrade.version(), 1);
    }
}
