// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//创建任务
// 修改任务名称
// 任务名写错的时候
// 修改完成状态：
// 手动指定完成或者未完成
// 自动切换
// 如果未完成状态下，改为完成
// 如果完成状态，改为未完成

contract ToDoList {
    struct Todo {
        string name;
        bool isCompleted;
    }

    Todo[] public todos;

    //新建任务
    function createTask(string memory _name) public {
        todos.push(Todo({name: _name, isCompleted: false}));
    }

    //修改任务名称
    function updateTask(uint256 _index, string memory _name) public {
        todos[_index].name = _name;
    }

    //更改任务状态 自动切换 toggle
    function toggleCompleted(uint256 _index) public {
        todos[_index].isCompleted = !todos[_index].isCompleted;
    }

    //获取任务
    function getTask(uint256 _index) public view returns (Todo memory) {
        return todos[_index];
    }
}
