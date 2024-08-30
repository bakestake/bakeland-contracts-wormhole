// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


interface IAsset is IERC721{
    
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function isAuthorized(address owner, address sender, uint256 tokenId) external view returns(bool);

    function setTokenUri(uint256 tokenId, string calldata uriString) external;
    function safeMint(address to) external returns (uint256);
    function safeMint(address to, uint256 _tokenId) external returns (uint256);
    function mintTokenId(address to, uint256 tokenId) external;
    function burnFrom(uint256 tokenId) external;
}
