// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 这一个实战主要是加深大家对 3 个取钱方法的使用。

// 任何人都可以发送金额到合约
// 只有 owner 可以取款
// 3 种取钱方式

contract EtherWallet {
    address public immutable i_owner;

    event Log(string funName, address from, uint256 value, bytes data);

    constructor(address _owner) {
        i_owner = _owner;
    }

    // | 特性          | `transfer`               | `send`                   | `call`
    // |--------------|--------------------------|--------------------------|------------------------
    // | **Gas 限制**  | 2300                     | 2300                     | 无限制
    // | **异常处理**   | 失败时抛出异常并回滚        | 失败时返回 `false`        | 失败时返回 `false`
    // | **灵活性**    | 低                        | 低                       | 高
    // | **适用场景**  | 简单转账，确保成功或回滚      | 简单转账，手动处理失败      | 复杂转账，灵活控制 gas 和数据

    function withdraw() external {
        require(msg.sender == i_owner, "Not owner");

        // 失败时抛出异常并回滚, 	gas 2300
        //payable(msg.sender).transfer(address(this).balance);

        // 失败时返回 false, 需要手动回滚	, gas 2300
        //bool success = payable(msg.sender).send(address(this).balance);
        //require(success, "Failed");

        // 失败时返回 false, 需要手动回滚, 灵活控制 gas 和数据
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Failed");
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
