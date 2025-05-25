// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {ZionResidents} from "../src/ZionResidents.sol";

contract CounterTest is Test {
    ZionResidents public nft;

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);


    address public owner = address(1);
    address public user1 = address(2);
    address public user2 = address(3);

    function setUp() public {
        vm.prank(owner);
        nft = new ZionResidents("Zion Residents", "ZION");
    }

    function testInitialState() public view {
        assertEq(nft.name(), "Zion Residents");
        assertEq(nft.symbol(), "ZION");
        assertEq(nft.balanceOf(owner), 1);
        assertEq(nft.ownerOf(1), owner);
    }

    function testSafeTransferFrom() public {
        vm.expectEmit(true, true, true, true);
        emit Transfer(owner, user1, 1);
        vm.prank(owner);
        nft.safeTransferFrom(owner, user1, 1);
        assertEq(nft.ownerOf(1), user1);
        assertEq(nft.balanceOf(owner), 0);
        assertEq(nft.balanceOf(user1), 1);
    }

    function testRevertTransferFromNotOwner() public {
        vm.prank(user1); 
        vm.expectRevert("Caller is not owner nor approved");
        nft.safeTransferFrom(owner, user2, 1);
    }

    function testApprove() public {
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, user1, 1);
        vm.prank(owner);
        nft.approve(user1, 1);
        assertEq(nft.getApproved(1), user1);
    }

    function testRevertApproveNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Approver is not owner");
        nft.approve(user2, 1);
    }

     function testSetApprovalForAll() public {
        vm.expectEmit(true, true, false, true);
        emit ApprovalForAll(owner, user1, true);
        vm.prank(owner);
        nft.setApprovalForAll(user1, true);
        assertTrue(nft.isApprovedForAll(owner, user1));
    }

    function testRevertSetApprovalForAllToSelf() public {
        vm.prank(owner);
        vm.expectRevert("Approve to caller");
        nft.setApprovalForAll(owner, true);
    }

    function testTokenURI() public view {
        string memory uri = nft.tokenURI(1);
        assertEq(uri, "ipfs://");
    }
}
