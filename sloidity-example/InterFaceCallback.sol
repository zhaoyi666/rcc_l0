// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 场景描述
// 假设有两个合约：
// Alpay：调用银行合约的转账, 银行转账完成后 回调 Alpay 告知完成
// Bank：银行合约，转账函数，转账完成后调用 Alpay 的回调函数

// 定义回调接口
interface ICallback {
    function onComplete(uint256 result) external;
}

//  被调用的合约，处理逻辑后 调用回调接口
contract Bank {
    // 执行某些操作，并在完成后回调调用者
    function transferAccounts() external {
        // 模拟一些操作 开始转账
        uint256 result = 42;
        // 回调调用者 Alpay 的 onComplete 函数
        ICallback(msg.sender).onComplete(result);
    }
}

// 调用者 Alpay 可以不用显示 is  ICallback 接口，只需实现接口函数即可
contract Alpay  {
    address public immutable i_bankAddress;

    constructor(address _bankAddress) {
        i_bankAddress = _bankAddress;
    }

    // 调用银行合约的转账函数
    function transfer() external {
        Bank(i_bankAddress).transferAccounts();
    }

    // 实现回调接口 ICallback 的 onComplete 函数
    function onComplete(uint256 result) external {
        // 确保对应银行才能调用
        require(
            msg.sender == i_bankAddress,
            "Only the bank can call this function"
        );

        // 避免在回调函数中执行外部调用 可能重入攻击
        // 必须需要时,确保重入锁或者其他防护措施
         //(bool success,)= msg.sender.call("");
         //require(success, "Failed to call back");

        // 处理回调逻辑
        require(result == 42, "Transfer failed");
        emit TransferComplete(200);
    }

    event TransferComplete(uint256 code);
}
