// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { IERC721 } from './IERC721.sol';

contract ZionResidents is IERC721{

        string public name;
        string public symbol;

        mapping(address owner => uint256 balance) public balanceOf;
        mapping(uint tockenId => address owner) public ownerOf;

        mapping (uint256 tokenId => address operaton) public getApproved;
        mapping(address owner => mapping(address operator => bool approved)) public isApprovedForAll;

        constructor (string memory _name,string memory _symbol)
        {
            name = _name;
            symbol = _symbol;

            ownerOf[1]=msg.sender;
            emit Transfer(address(0), msg.sender, 1);
            balanceOf[msg.sender] +=1;
        }

        function safeTransferFrom(address from, address to, uint tokenId) external payable{
            require(
                from == msg.sender && ownerOf[tokenId] == msg.sender,
                "Caller is not owner nor approved"
            );
           
                balanceOf[from]--;
                balanceOf[to]++;
                ownerOf[tokenId] = to;
                emit Transfer(from,to,tokenId);
                return;
        }

        function safeTransferFrom(address from, address to, uint tokenId, bytes calldata) external payable{
            require(
                from == msg.sender && ownerOf[tokenId] == msg.sender,
                "Caller is not owner nor approved"
            );

                balanceOf[from]--;
                balanceOf[to]++;
                ownerOf[tokenId] = to;
                emit Transfer(from,to,tokenId);
                return;

        }

        function approve(address operator, uint256 tokenId) external payable{
            require(ownerOf[tokenId] == msg.sender,"Approver is not owner");
            require(operator != address(0),"Approve to zero address");
            getApproved[tokenId] = operator;
            emit Approval(ownerOf[tokenId],operator,tokenId);
        }

        function setApprovalForAll(address operator, bool approved) external{
            require(operator != msg.sender,"Approve to caller");
            require(operator != address(0),"Approve to zero address");
            isApprovedForAll[msg.sender][operator] = approved;
            emit ApprovalForAll (msg.sender, operator ,approved);  
        }

        function tokenURI(uint256 tokenId) external view returns (string memory){
            require(ownerOf[tokenId] != address(0), "Token doesn't exist");
            return "ipfs://";
        } 
}