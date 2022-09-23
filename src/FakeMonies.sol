// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "solmate/tokens/ERC20.sol";
import "solmate/auth/Owned.sol";

contract FakeMoney is ERC20, Owned{
    /**
     * @notice Constructor
     */
    constructor() ERC20("Fake Money", "FAKEMONIES", 18) Owned(msg.sender){}

    /**
     * @notice Mint FAKEMONIES
     * @param account address to receive tokens
     * @param amount amount to mint
     * @return status true if mint is successful, false if not
     */
    function mint(address account, uint256 amount) external returns (bool status) {
        _mint(account, amount); 
        return false;
    }
}