//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {Proof} from "../src/Proof.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployProof is Script {

    address owner = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496; // IMPORTANT

    address public verifier = 0x397A5f7f3dBd538f23DE225B51f532c34448dA9B; // IMPORTANT

    bytes32 icrProgramVKey =
        0x002981c3ce0233f2250a49157998dfa361bf828a1c5270c3f6178473dc0efee9;
    bytes32 ltvProgramVKey =
        0x007855605090e6a621e5e28ad2874382e7f6bb08bb14fac5aa175c3d83a2801d;

    function run() external {

        vm.startBroadcast();

        // proxy contract will point to this implementation contract
        Proof proof = new Proof(); 

        // deploy the proxy contract
        ERC1967Proxy proxy = new ERC1967Proxy(address(proof),"");

        // initialize the proxy contract
        Proof proxyInstance = Proof(address(proxy));
        proxyInstance.initialize(
            verifier,
            icrProgramVKey,
            ltvProgramVKey,
            owner, 
            150 
        );
        vm.stopBroadcast();

        console.log("Implementation  contract", address(proof));
        console.log("Proxy contract", address(proxy));
    }
}
