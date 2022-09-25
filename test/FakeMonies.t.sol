// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {FakeMoney} from "src/FakeMonies.sol";

contract FakeMoniesTest is Test {
    using stdStorage for StdStorage;

    FakeMoney fake;

    function setUp() external {
        fake = new FakeMoney();
    }

    function testmint() external {
        fake.mint(address(fake), 50);
        assertEq(fake.balanceOf(address(fake)), 50);
    }
}