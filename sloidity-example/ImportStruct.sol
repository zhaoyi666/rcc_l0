// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Todos.sol";

contract ImportStruct {

    Todo[] public todos;

    function addTodo(string memory _text) public {
        todos.push(Todo(_text, false));
    }

    function getTodo(uint256 _index) public view returns (Todo memory) {
        return todos[_index];
    }

    function getTodos() public view returns (Todo[] memory) {}
}