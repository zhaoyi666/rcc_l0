// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleStorage {
    uint256 public s_num;

    function set(uint256 _num) public {
        s_num = _num;
    }

    // view 代表这个函数不会修改合约的状态
    // 外部读取不会消耗gas, 但是其他合约调用会消耗gas
    function get() public view returns (uint256) {
        return s_num;
    }
}
