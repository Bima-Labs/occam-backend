//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Proof} from "../src/Proof.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/**
 * Core -
 * Hemi - 30329
 * Sonic - 30332
 */
contract LayerZeroTestSendRecieve is Test {
    uint256 holeskyFork;
    Proof proxyInstrance;

    function setUp() external {
        proxyInstrance = Proof(0xBC0eD4871060e61d23193Fd693805696C59Ef6F1);

        holeskyFork = vm.createSelectFork(
            "https://eth-holesky.g.alchemy.com/v2/29b6W9IbhFqdunO5kwC7nUP507eJAlZI"
        );
    }

    function test_initialization() public {
        vm.selectFork(holeskyFork);
        console.log("key:");
        console.logBytes32(proxyInstrance.icrProgramVKey());
    }

    function test_IcrProof() public {
        vm.selectFork(holeskyFork);
        bytes memory _publicValues = hex"000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000193d7";

        bytes memory _proofBytes = hex"11b6a09d08b1eefa66c4b956edfd5f960db807122aeb54ea3bbc143090e65a574a576eea0c539afb01d44d638fe6f3b89819b20317dd0cfd563cfa50b4b162f05054c45e2e5d2de02ebeca80876dfb468b1f9ef4dd6cb48c1fa5c52f2ce776842913572a082124e9b452a6b94229beeb8e81afc2c656435486da1d8fb31c89dbb0618d602e071c53d9fde831d0a02590fa4f970ebb20abd57ff7718eb64c304cfd8a82431c1adc69ceb12c747288ed770a91dacec1b188e07c1443fea9113b67a0e27589248db9a690a1e6f73815560ba94fede0e4862cfbe3429d05d5651bb84071fc572b3eb1ba35708441916efd2496c3b8916c7a1a518941cd13d7f1a3335cf5701c";

        bool result = proxyInstrance.verifyIcrProof(_publicValues, _proofBytes);
        assert(result == true);
    }

    function test_LtvProof() public {
        vm.selectFork(holeskyFork);
        bytes memory _publicValues = hex"000000000000000000000000000000000000000000000000000000000000004e";
        bytes memory _proofBytes = hex"11b6a09d0c2fa85ed3ac8e41594bb0d3d841ce39debedec3ad8ec4b12d2793351d85d1d30a37b42d4bc6058e303cba7f9a8ebd6f2ef243906787ed1f5f4cad34658efb8d2b588734912480aa5c79cc1376c302ddf53690b1d8750543e38cdd5900480b871646b0229e96eb2b1b1845a67ddcb0184ae4ae238778982a61727ad6c79e930419dea4d7b3ceba26c6c58b2c6da4c8a2b72ec2a188119ffbaae00f31bb9c24e52b27b45d14c45816012c44bc4953ba051c3f7446d592119934bfbb02b7fb90dd109e22d42a5e02da8c8bf66146858bb7a35ab4b139294d8b004652710d4b4ea5064554404266c6867c8f71b4efb3f44397ac4f5547a87907d4e355d909855781";
        uint32 result = proxyInstrance.verifyLtvProof(_publicValues, _proofBytes);
        console.log("result", result);
    }
}
