// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IGauge} from "../../interfaces/IGauge.sol";
import {IStBuds} from "../../interfaces/IStBuds.sol";
import {IRstBuds} from "../../interfaces/IRstBuds.sol";

library LibBera {

    struct BeraState {
        IGauge _gauge;
        IStBuds _stBuds;
        IRstBuds _rstBuds;
    }

    bytes32 constant GLOBAL_BERA_STORAGE_POSITION = keccak256("diamond.standard.global.BeraFacet.storage");

    function getStorage() internal pure returns (BeraState storage ds) {
        bytes32 position = GLOBAL_BERA_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

}