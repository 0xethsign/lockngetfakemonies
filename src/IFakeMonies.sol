// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
interface IFakeMoney is IERC20 {
    function mint(address account, uint256 amount) external returns (bool status);
}