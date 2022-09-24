// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

/// @notice A generic interface for a contract which Implements a lock mechanism for Uniswap v3 LP tokens.
interface ILock {
    function LockV3Nft(uint256 _tokenId) external returns (uint256);
    function UnlockV3Nft(uint256 _tokenId) external returns (bool);
}