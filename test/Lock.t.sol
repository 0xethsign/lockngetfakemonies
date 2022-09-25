// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {Lock} from "src/Lock.sol";
import {FakeMoney} from "src/FakeMonies.sol";
import {IFakeMoney} from "src/IFakeMonies.sol";

contract LockTest is Test {
    using stdStorage for StdStorage;

    Lock lock;
    FakeMoney fake;

    function setUp() external {        
        lock = new Lock(0xC36442b4a4522E871399CD717aBDD847Ab11FE88, 0x627b9A657eac8c3463AD17009a424dFE3FDbd0b1);
    }

    function testLockV3Nft() external {
        // slither-disable-next-line reentrancy-events,reentrancy-benign
        /// Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
        /// Deployed to: 0x627b9A657eac8c3463AD17009a424dFE3FDbd0b1
        /// Transaction hash: 0x613ef40828ba2f84d0edbdaa68de5f2361e19dbf97154bbf6e95587d23d0adb6 
        fake = FakeMoney(0x627b9A657eac8c3463AD17009a424dFE3FDbd0b1);
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        fake.setOwner(address(lock));
        lock.LockV3Nft(13061);
        assertEq(fake.balanceOf(address(this)), 4000);
    }
}