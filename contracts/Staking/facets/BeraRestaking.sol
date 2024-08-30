// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibBera} from "../lib/LibBera.sol";

contract BeraRestaking {

    function stakeInGauge(uint256 amount) external {
        LibBera.getStorage()._stBuds.transferFrom(msg.sender, address(this), amount);
        LibBera.getStorage()._stBuds.approve(address(LibBera.getStorage()._gauge),amount);

        LibBera.getStorage()._gauge.delegateStake(msg.sender, amount);
        LibBera.getStorage()._rstBuds.mintTo(msg.sender, amount);
    }

    function withdrawFromGauge(uint256 amount) external{
        LibBera.getStorage()._gauge.delegateWithdraw(msg.sender, amount);
    }

}
    