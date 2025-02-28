// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 定义接口
interface IStorage {
    function set(uint256 _value) external;

    function get() external view returns (uint256);
}

//实现接口 可以不显示的继承接口
contract Storage is IStorage {
    uint256 private value;

    function set(uint256 _value) external {
        value = _value;
    }

    function get() external view returns (uint256) {
        return value;
    }
}

//使用接口
contract StorageUser {
    IStorage public storageContract;

    constructor(address _storageAddress) {
        storageContract = IStorage(_storageAddress);
    }

    function setValue(uint256 _value) external {
        storageContract.set(_value);
    }

    function getValue() external view returns (uint256) {
        return storageContract.get();
    }
}

// 临时存储 数据交易后清空
// EIP-1153引入
contract TemporaryStorage {
    bytes32 constant SLOT = 0;

    function write_tmp(bytes32 _value) public {
        assembly {
            // 写入临时存储
            tstore(SLOT, _value)
        }
    }

    function read_tmp() public view returns (bytes32 value) {
        assembly {
            // 读取临时存储
            value := tload(SLOT)
        }
    }
}

//实现重入锁 基于storge实现的gas消耗高, 使用 临时存储 的低
contract ReentrancyLock {
    bytes32 constant IS_LOCKED = 0;

    function testLock() public relocked {
        // do something
    }   

    modifier relocked() {
        assembly {
            //检查是否锁定
            // assembly中if 不需要花括号
            if sload(IS_LOCKED) {
                // 内联汇编（Inline Assembly）中，
                // 简单回滚：当你不需要返回具体的错误信息，只需要终止交易并回滚状态时，可以使用 revert(0, 0)。
                //Gas 优化：相比于 Solidity 的 revert() 或 require()，revert(0, 0) 的 Gas 成本更低，因为它不需要处理错误信息。
                revert(0, 0)
            }
            // 锁定
            tstore(IS_LOCKED, 1)
        }
        _;
        assembly {
            // 解锁
            tstore(IS_LOCKED, 0)
        }
    }
}
