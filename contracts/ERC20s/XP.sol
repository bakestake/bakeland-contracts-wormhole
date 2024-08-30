// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20Errors } from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

/// @title XP token
/// @author @Rushikesh0125
/// @notice Contract responsible for XP token contract
contract XP is ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {
    error ZeroAddress();
    error InvalidParam();
    error ClaimOnlyAfterADay();

    address public _stakingContract;

    /// @notice Modifier for gated functions which are meant to called from staking contract only 
    modifier OnlyStakingContract() {
        if (msg.sender != _stakingContract) revert();
        _;
    }

    /// @notice Initializer function
    /// @param _staking Address of staking contract
    function initialize(address _staking) public initializer {
        if (_staking == address(0)) {
            revert ZeroAddress();
        }
        __ERC20_init("Bakeland XP Token", "BAKED");
        __Ownable_init(msg.sender);
        
        _stakingContract = _staking;
    }

    /// @param _address Function to set staking contract address
    /// @dev Only callable by owner
    function setStaking(address _address) external onlyOwner {
        if(_address == address(0)) revert ZeroAddress();
        _stakingContract  = _address;
    }

    function mintTo(address _to, uint256 _amount) external OnlyStakingContract{
        _mint(_to, _amount);
    }

    function burnFrom(address from, uint256 amount) external OnlyStakingContract {
        _burn(from, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override {}
}
