// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 当 struct 定义在合约外部时，它属于文件级作用域，可以被同一文件中的所有合约使用。
// 当 struct 定义在合约内部时，它仅在该合约及其继承合约中可见和使用。
struct Todo {
    string text;
    bool completed;
}

contract Todos {
    // An array of 'Todo' structs
    Todo[] public todos;

    function create(string memory _text) public {
        // 3 ways to initialize a struct
        // - calling it like a function
        //todos.push(Todo(_text, false));

        // key value mapping
        //todos.push(Todo({text: _text, completed: false}));

        // initialize an empty struct and then update it
        Todo memory todo;
        todo.text = _text;
        todos.push(todo);
        // todo.completedinitialized to false
    }

    // Solidity automatically created a getter for 'todos' so
    // you don't actually need this function.
    function get(
        uint256 _index
    ) public view returns (string memory text, bool completed) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // update text
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completed
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}
