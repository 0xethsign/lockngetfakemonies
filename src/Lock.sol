// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "solmate/auth/Owned.sol";
import "./ILock.sol";

contract Lock is ILock, Owned {


    /**
     * @notice Constructor
     */
    constructor() Owned(msg.sender){}

    function LockV3Nft(uint256 _tokenId, address _quoteToken) external returns (uint256){

    }

    function UnlockV3Nft(uint256 _tokenId, address _quoteToken) external returns (bool){
        
    }
}