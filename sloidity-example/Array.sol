// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ArrayRemoveByShifting {

    uint256[] public s_array;

    // 删除数组中指定索引的元素,保障原本顺序
    function remove(uint256 _index) public {
        // 每次从storage中读取数组长度 需要消耗gas的 
        // 这里一次性读取数组长度 节省gas
        uint256 arr_size =  s_array.length;
        require(_index < arr_size, "index out of bound");

        for (uint256 i = _index; i < arr_size - 1; i++) {
            s_array[i] = s_array[i + 1];
        }
        s_array.pop();
    }

    // 删除元素 通过交换不保证原本顺序
    function removeBySwapping(uint256 _index) public {
        uint256 arr_size =  s_array.length;
        require(_index < arr_size, "index out of bound");
        s_array[_index] = s_array[arr_size- 1];
        s_array.pop();
    }



}
