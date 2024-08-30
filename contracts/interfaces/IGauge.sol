// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGauge {
    function getWhitelistedTokens() external view returns (address[] memory);
    function stake(uint256 amount) external ;
    function delegateStake(address account, uint256 amount) external;
    function delegateWithdraw(address account, uint256 amount) external;
    function whitelistIncentiveToken(address token, uint256 minIncentiveRate) external;
    function getTotalDelegateStaked(address account) external view returns (uint256);
    function getDelegateStake(address account, address delegate) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}