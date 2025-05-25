// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { IERC6093 }from "./IERC6093.sol";

contract TrinityToken is IERC6093 {
    string public override name;
    string public override symbol;
    uint8 public override decimals;

    uint256 public override totalSupply;
    mapping(address account => uint256 balance) public override balanceOf;
    mapping(address owner => mapping(address spender => uint256 allowanceOf)) public override allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        balanceOf[msg.sender] = 100_000_000 * (10 ** _decimals);
        totalSupply += 100_000_000 * (10 ** _decimals);
        emit Transfer(address(0), msg.sender, 100_000_000 * (10 ** _decimals));
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        if (from != msg.sender) {
            uint256 _allowance = allowance[from][msg.sender];
            if (_allowance < amount) {
                revert ERC20InsufficientAllowance(msg.sender, _allowance, amount);
            }
        }

        _transfer(from, to, amount);

        return true;
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, to, amount);

        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        if (spender == address(0)) {
            revert ERC20InvalidSpender(spender);
        }

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(from);
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(to);
        }

        uint256 balance = balanceOf[from];
        if (balance < amount) {
            revert ERC20InsufficientBalance(from, balance, amount);
        }
        unchecked {
            balanceOf[from] = balance - amount;
        }
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
    }
}