// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISP1Verifier} from "@sp1-contracts/ISP1Verifier.sol";
import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

struct PublicValuesIcr {
    uint32 icr;
    uint32 collateral_amount;
}

struct publicValuesLtv {
    uint32 real_time_ltv;
}
// deploy impolemntation contract --  
contract Proof is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    
    /// @notice The address of the SP1 verifier contract.
    /// @dev This can either be a specific SP1Verifier for a specific version, or the
    ///      SP1VerifierGateway which can be used to verify proofs for any version of SP1.
    ///      For the list of supported verifiers on each chain, see:
    ///      https://github.com/succinctlabs/sp1-contracts/tree/main/contracts/deployments
    address public verifier;
    uint32 public minIcr;

    /// @notice The verification key
    bytes32 public icrProgramVKey;
    bytes32 public ltvProgramVKey;

    

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address _verifier,
        bytes32 _icrProgramVKey,
        bytes32 _ltvProgramVKey,
        address _owner,
        uint32 _minIcr
    ) public initializer {
        verifier = _verifier;
        icrProgramVKey = _icrProgramVKey;
        ltvProgramVKey = _ltvProgramVKey;
        minIcr = _minIcr;
        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
    }

    /**
     * modifier
     */

    /// @notice The entrypoint for verifying the proof of a ICR.
    /// @param _proofBytes The encoded proof.
    /// @param _publicValues The encoded public values.
    function verifyIcrProof(
        bytes calldata _publicValues,
        bytes calldata _proofBytes
    ) public view returns (bool) {
        ISP1Verifier(verifier).verifyProof(
            icrProgramVKey,
            _publicValues,
            _proofBytes
        );
        PublicValuesIcr memory publicValues = abi.decode(
            _publicValues,
            (PublicValuesIcr)
        );

        if (publicValues.icr < minIcr) {
            return true;
        } else {
            return false;
        }
    }

    /// @notice The entrypoint for verifying the proof of a Real Time LTV.
    /// @param _proofBytes The encoded proof.
    /// @param _publicValues The encoded public values.
    function verifyLtvProof(
        bytes calldata _publicValues,
        bytes calldata _proofBytes
    ) public view returns (uint32) {
        ISP1Verifier(verifier).verifyProof(
            ltvProgramVKey,
            _publicValues,
            _proofBytes
        );
        publicValuesLtv memory publicValues = abi.decode(
            _publicValues,
            (publicValuesLtv)
        );
        return publicValues.real_time_ltv;
    }

    /**
     * Only  owner
     */

    function changeIcrProgramVKey(bytes32 _icrProgramVKey) public onlyOwner {
        icrProgramVKey = _icrProgramVKey;
    }

    function changeLtvProgramVKey(bytes32 _ltvProgramVKey) public onlyOwner {
        ltvProgramVKey = _ltvProgramVKey;
    }

    function changeMcr(uint32 _updatedMcr) public onlyOwner {
        minIcr = _updatedMcr;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override onlyOwner {
        // Only the owner can authorize upgrades
    }
}
