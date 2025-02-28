// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Constants {
    // 1. 常量 constant
    // 常量是只读的，不能被修改
    // 编译到代码中 节省gas
    address public constant MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint256 public constant MY_UINT = 123;

    //不可变变量 immutable  节省gas
    address public immutable i_owner;

    constructor() {
        // immutable 不可变 变量需要再构造函数中完成初始化 
        i_owner = msg.sender;
    }
}
