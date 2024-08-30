// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../interfaces/IXP.sol";

library LibXpManager {

    error ClaimOnlyAfterADay();
    error InvalidParam();

    struct XpManagaerState {
        IXP _xpToken;

        mapping(uint256 tokenId => uint8 level)  levelByTokenId;
        mapping(uint8 level => string uri) uriByLevel;
        mapping(address => uint) lastClaimBy;
    }

    bytes32 constant GLOBAL_XP_STORAGE_POSITION = keccak256("diamond.standard.global.XpManager.storage");

    function getStorage() internal pure returns (XpManagaerState storage ds) {
        bytes32 position = GLOBAL_XP_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

}