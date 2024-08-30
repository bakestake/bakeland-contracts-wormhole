// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @title rstBuds token contract
/// @author Bakeland @Rushikesh0125
/// @notice This contract is responsible for Buds token 
contract rstBuds is ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {
    error ZeroAddress();
    error UnAuthorizedAccess();

    /// @notice Staking contract address
    address public _stakingContract;


    /// @param stakingContract Address of stBuds contract
    /// @notice This function is intializer and only called once at the time of deployment
    function initialize(address stakingContract) public initializer {
        if (stakingContract == address(0)) {
            revert ZeroAddress();
        }   

        /// Initializing ERC20, Ownable, and upgradable interface
        __ERC20_init("Bakeland rst Buds token", "rstBUDS");
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        _stakingContract = stakingContract;

    }
    
    /// @notice Modifier for gated functions which are meant to called from staking contract only 
    modifier OnlyStakingContract() {
        if (msg.sender != _stakingContract) revert UnAuthorizedAccess();
        _;
    }

    /// @param _staking Address of staking contract
    /// @dev This function is only callable by owner
    /// @notice Function responsible for setting staking contract address
    function setStBudsContract(address _staking) external onlyOwner{
        _stakingContract = _staking;
    }
    
    function mintTo(address _to, uint256 _amount) external OnlyStakingContract{
        _mint(_to, _amount);
    }

    function burnFrom(address from, uint256 amount) external OnlyStakingContract {
        _burn(from, amount);
    }

    /// @param newImplementation New implementation contract address
    /// @notice @dev Override only meant for inheritance purpose
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
