// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/LidGlobalDataState.sol";
import "../lib/LibXpManager.sol";

import { IERC721Errors } from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import { IERC20Errors } from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract XpLevelManager {    

    function levelUpFarmer(uint256 tokenId) external {
        if (!LibGlobalVarState.interfaceStore()._farmerToken.isAuthorized(LibGlobalVarState.interfaceStore()._farmerToken.ownerOf(tokenId), msg.sender, tokenId))
            revert IERC721Errors.ERC721InsufficientApproval(msg.sender, tokenId);
        if (LibGlobalVarState.interfaceStore()._farmerToken.ownerOf(tokenId) != msg.sender) revert IERC721Errors.ERC721IncorrectOwner(msg.sender, tokenId, LibGlobalVarState.interfaceStore()._farmerToken.ownerOf(tokenId));

        uint256 xpToBurn = calculateRequiredXp(LibXpManager.getStorage().levelByTokenId[tokenId]);

        LibXpManager.getStorage()._xpToken.burnFrom(msg.sender, xpToBurn);

        LibXpManager.getStorage().levelByTokenId[tokenId]++;
        LibGlobalVarState.interfaceStore()._farmerToken.setTokenUri(tokenId, LibXpManager.getStorage().uriByLevel[LibXpManager.getStorage().levelByTokenId[tokenId]]);
    }

    function levelUpNarc(uint256 tokenId) external {
        if (!LibGlobalVarState.interfaceStore()._narcToken.isAuthorized(LibGlobalVarState.interfaceStore()._narcToken.ownerOf(tokenId), msg.sender, tokenId))
            revert IERC721Errors.ERC721InsufficientApproval(msg.sender, tokenId);
        if (LibGlobalVarState.interfaceStore()._narcToken.ownerOf(tokenId) != msg.sender) revert IERC721Errors.ERC721IncorrectOwner(msg.sender, tokenId, LibGlobalVarState.interfaceStore()._narcToken.ownerOf(tokenId));

        uint256 xpToBurn = calculateRequiredXp(LibXpManager.getStorage().levelByTokenId[tokenId]);

        LibXpManager.getStorage()._xpToken.burnFrom(msg.sender, xpToBurn);

        LibXpManager.getStorage().levelByTokenId[tokenId]++;
        LibGlobalVarState.interfaceStore()._narcToken.setTokenUri(tokenId, LibXpManager.getStorage().uriByLevel[LibXpManager.getStorage().levelByTokenId[tokenId]]);
    }

    function burnForBuds(uint256 amount) external returns (uint256 budsRewarded) {
        if (amount < 1000 || amount < LibGlobalVarState.interfaceStore()._budsToken.balanceOf(msg.sender))
            revert IERC20Errors.ERC20InsufficientBalance(msg.sender, amount, 1000 ether);
        budsRewarded = calculateBudsForXP(amount);
        LibXpManager.getStorage()._xpToken.burnFrom(msg.sender, amount);
        LibGlobalVarState.interfaceStore()._budsVault.sendBudsTo(msg.sender, budsRewarded);
    }

    function claimXP() public returns (uint256 xpToMint) {
        if (LibXpManager.getStorage().lastClaimBy[msg.sender] < 1 days) revert LibXpManager.ClaimOnlyAfterADay();
        LibXpManager.getStorage().lastClaimBy[msg.sender] = block.timestamp;
        xpToMint = calculateXp(msg.sender);
        LibXpManager.getStorage()._xpToken.mintTo(msg.sender, xpToMint);
    }

    /// @notice Function to calculate amount of XP to be claimed by user
    /// Depends on users Stake
    function calculateXp(address userAddress) internal view returns (uint256 xpToMint) {
        LibGlobalVarState.Stake[] memory stks = LibGlobalVarState.mappingStore().stakeRecord[userAddress];
        uint256 budsAmount = 0;
        uint256 tokenId = LibGlobalVarState.mappingStore().stakedFarmer[userAddress];

        for(uint i = 0; i < stks.length; i++){
            budsAmount += stks[i].budsAmount;
        }
        xpToMint += 10;
        xpToMint += (budsAmount / 1000);
        xpToMint += tokenId == 0 ? 0 : 10;
    }

    /// @param amount Amount of XP 
    /// @notice Calculates amount of buds to be rewarded to user for burning specific amount of XP
    function calculateBudsForXP(uint256 amount) public pure returns (uint256 budsReward) {
        if (amount <= 0) {
            revert LibXpManager.InvalidParam();
        }
        budsReward = amount / 1000;
    }

    function calculateRequiredXp(uint8 level) internal pure returns (uint256 xpToBurn) {
        return level + 1 * 500 ether;
    }

}