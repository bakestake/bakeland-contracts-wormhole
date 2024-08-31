// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "wormhole-solidity-sdk/libraries/BytesParsing.sol";
import "wormhole-solidity-sdk/interfaces/IWormhole.sol";
import {LibGlobalVarState} from "../lib/LidGlobalDataState.sol";
import {QueryResponse} from "../../wormholeSupport/QueryResponse.sol";

contract NftMinter is QueryResponse {

    function mintFarmer(bytes memory response, IWormhole.Signature[] memory signatures) external returns (uint256) {
        uint256 highestTokenId = 0;

        ParsedQueryResponse memory r = parseAndVerifyQueryResponse(response, signatures);
        uint256 numResponses = r.responses.length;
        if (numResponses != LibGlobalVarState.intStore().noOfChains) {
            revert("Unmatched length 1");
        }

        for (uint256 i = 0; i < numResponses; ) {
            EthCallQueryResponse memory eqr = parseEthCallQueryResponse(r.responses[i]);

            // Validate that update is not stale
            validateBlockTime(eqr.blockTime, block.timestamp - 300);

            if (eqr.result.length != 1) {
                revert("Unmatched length 2");
            }

            // Validate addresses and function signatures
            address[] memory validAddresses = new address[](1);
            bytes4[] memory validFunctionSignatures = new bytes4[](1);
            validAddresses[0] = address(this);
            validFunctionSignatures[0] = bytes4(keccak256(bytes("getNextTokenId()")));

            validateMultipleEthCallData(eqr.result, validAddresses, validFunctionSignatures);

            require(eqr.result[0].result.length == 32, "result is not a uint256");

            uint256 curTokenId = abi.decode(eqr.result[0].result, (uint256));

            if(curTokenId > highestTokenId){
                highestTokenId = curTokenId;
            }

            unchecked {
                ++i;
            }
        }

        LibGlobalVarState.interfaceStore()._farmerToken.safeMint(msg.sender, highestTokenId);

        return highestTokenId;
    }

    function mintNarc(bytes memory response, IWormhole.Signature[] memory signatures) external returns (uint256) {
        uint256 highestTokenId = 0;

        ParsedQueryResponse memory r = parseAndVerifyQueryResponse(response, signatures);
        uint256 numResponses = r.responses.length;
        if (numResponses != LibGlobalVarState.intStore().noOfChains) {
            revert("Unmatched length 1");
        }

        for (uint256 i = 0; i < numResponses; ) {
            EthCallQueryResponse memory eqr = parseEthCallQueryResponse(r.responses[i]);

            // Validate that update is not stale
            validateBlockTime(eqr.blockTime, block.timestamp - 300);

            if (eqr.result.length != 1) {
                revert("Unmatched length 2");
            }

            // Validate addresses and function signatures
            address[] memory validAddresses = new address[](1);
            bytes4[] memory validFunctionSignatures = new bytes4[](1);
            validAddresses[0] = address(this);
            validFunctionSignatures[0] = bytes4(keccak256(bytes("getNextTokenId()")));

            validateMultipleEthCallData(eqr.result, validAddresses, validFunctionSignatures);

            require(eqr.result[0].result.length == 32, "result is not a uint256");

            uint256 curTokenId = abi.decode(eqr.result[0].result, (uint256));

            if(curTokenId > highestTokenId){
                highestTokenId = curTokenId;
            }

            unchecked {
                ++i;
            }
        }

        LibGlobalVarState.interfaceStore()._narcToken.safeMint(msg.sender, highestTokenId);

        return highestTokenId;
    }


    function _authorizeUpgrade(address newImplementation) internal virtual override {}
}