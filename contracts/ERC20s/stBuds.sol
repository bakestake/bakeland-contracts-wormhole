// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC20CappedUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";

/// @title stBuds - Staked buds
/// @author Bakeland @Rushikesh0125
/// @notice Contract for staked buds tokens, Meant to minted to users on staking buds in staking pool
contract StBuds is ERC20CappedUpgradeable, UUPSUpgradeable, OwnableUpgradeable {
    /// Staking contract address
    address public _stakingContract;

    /// @notice Modifier for gated functions which are meant to called from staking contract only
    modifier onlyStakingContract() {
        require(msg.sender == _stakingContract, "Only staking contract");
        _;
    }

    /// @param stakingContract Address of staking contract
    /// @notice This function is intializer and only called once at the time of deployment
    function initialize(address stakingContract) external initializer {
        _stakingContract = stakingContract;

        __ERC20_init("stBuds", "Staked Buds");
        __ERC20Capped_init(420000000 * 1e18);
        __Ownable_init(msg.sender);
    }

    /// @param _addr Address of staking contract
    /// @dev This function is only callable by owner
    /// @notice Function responsible for setting staking contract address
    function setStakingAddress(address _addr) external onlyOwner {
        _stakingContract = _addr;
    }

    function mintTo(address to, uint256 amount) external onlyStakingContract {
        _mint(to, amount);
    }

    function burnFrom(address from, uint256 amount) external onlyStakingContract {
        _burn(from, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override {}
}