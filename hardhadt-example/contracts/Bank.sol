// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 所有人都可以存钱
// ETH
// 只有合约 owner 才可以取钱
// 只要取钱，合约就销毁掉 selfdestruct
// 扩展：支持主币以外的资产
// ERC20
// ERC721

// 安装 OpenZeppelin 的合约库
// hardhat install @openzeppelin/contracts

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bank {
    address public immutable i_owner;
    bool public isEthActive = true; // 独立管理 ETH 功能状态
    bool public isTokenActive = true; // 独立管理 ERC20 功能状态

    event Deposit(address indexed from, uint256 value);
    event Withdraw(uint256 indexed amount);

    event DepositERC20(
        address indexed from,
        address indexed token,
        uint256 amount
    );
    event WithdrawERC20(
        address indexed to,
        address indexed token,
        uint256 amount
    );
    event DepositERC721(
        address indexed from,
        address indexed token,
        uint256 tokenId
    );
    event WithdrawERC721(
        address indexed to,
        address indexed token,
        uint256 tokenId
    );

    constructor() {
        i_owner = msg.sender;
    }

    // 接收 ETH 存款
    // 所有人都可以存钱, receive ,不能取钱就不用记录在合约里面了
    receive() external payable {
        require(isEthActive, "Contract is inactive");
        // 存钱 记录存钱事件
        emit Deposit(msg.sender, msg.value);
    }

    // 提款 ETH
    // 只有合约 owner 才可以取钱
    function withdraw() external {
        require(msg.sender == i_owner, "only owner can withdraw");

        require(isEthActive, "Contract is already inactive");

        // 取钱
        emit Withdraw(address(this).balance);
        // 报错原因：selfdestruct 已被弃用，自 Cancun 硬分叉后，该操作码不再删除合约代码和数据，仅转移以太坊余额，且未来可能进一步减少其功能。
        //修复建议：避免使用 selfdestruct，改为直接转移合约余额给所有者，并在转移后标记合约状态为不可用。
        //selfdestruct(payable(i_owner));

        uint256 balance = address(this).balance;
        // transfer
        // 固定的 2300 gas 限制
        // 自动回退（revert）机制：如果转账失败，交易会自动回滚，无需手动处理失败情况。
        // 使用场景例如
        //  单一支付操作：比如在拍卖结束时，自动将资金发送到获胜者的账户。
        //  无复杂逻辑的转账：适用于无需复杂回调或逻辑的简单转账。
        payable(i_owner).transfer(balance);
        isEthActive = false;
    }

    // 存款 ERC20 代币
    function depositERC20(address token, uint256 amount) external {
        require(isTokenActive, "Token functionality is inactive");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        emit DepositERC20(msg.sender, token, amount);
    }

    // 提款 ERC20 代币
    function withdrawERC20(address token, uint256 amount) external {
        require(msg.sender == i_owner, "only owner can withdraw");
        require(isTokenActive, "Token functionality is already inactive");

        IERC20(token).transfer(i_owner, amount);
        emit WithdrawERC20(i_owner, token, amount);
        isTokenActive = false;
    }
}
