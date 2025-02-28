// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * storage 永久存储在区块链上的数据
 * memory 据仅在函数执行期间存在，函数执行结束后会被清除
 * calldata 只读的、临时的数据区域，用于存储函数调用时的输入参数
 */

contract DataLocations {
    uint256[] private arr;
    mapping(uint256 => address) map;

    struct MyStruct {
        uint256 foo;
    }

    mapping(uint256 => MyStruct) myStructs;

    function f() public {
        // call _f with state variables
        _f(arr, map, myStructs[1]);

        // get a struct from a mapping
        MyStruct storage myStruct = myStructs[1];
        myStruct.foo = 1; // 直接修改状态变量

        // create a struct in memory
        MyStruct memory myMemStruct = myStructs[1];
        myMemStruct.foo = 2; // 修改内存变量
    }

    function getFoo(uint i) public view returns (uint256) {
        return myStructs[i].foo;
    }

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        // do something with storage variables
    }

    // You can return memory variables
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // do something with memory array
    }

    function h(uint256[] calldata _arr) external {
        // do something with calldata array
    }
}
