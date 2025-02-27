// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//Here is a simple contract that you can get, increment and decrement the count store in this contract.
contract Counter {
    uint256 public count;

    function increment() public {
        count += 1;
    }

    function decrement() public {
        count -= 1;
    }
}
