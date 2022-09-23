// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "solmate/auth/Owned.sol";
import "./ILock.sol";

contract Lock is Owned {
    /**
     * @notice Constructor
     */
    constructor() Owned(msg.sender){}
}