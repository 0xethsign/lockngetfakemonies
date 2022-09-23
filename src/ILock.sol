// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

/// @notice A generic interface for a contract which Implements a lock mechanism for Uniswap v3 LP tokens.
interface ILock {
    function LockV3NFT(uint256 _tokenId, address _quoteToken) external returns(uint256);
}