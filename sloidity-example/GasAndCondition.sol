// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * Gas：衡量计算工作量的单位，每项操作（如加法、存储写入）都有固定的Gas消耗。
 * Gas Price：用户愿意为每单位Gas支付的价格，通常以Gwei（1 Gwei = 0.000000001 ETH）计价。
 * Gas Limit：用户愿意为交易支付的最大Gas量，防止因错误代码或复杂操作导致过高费用。
 * 
 * Gas费 = Gas Used * Gas Price
 * Gas Used：实际消耗的Gas量，取决于交易的复杂性。
 * Gas Price：用户设定的每单位Gas价格，影响交易处理速度。
 * 
 * Gas Limit的作用
 * 保护用户：防止因代码错误或复杂操作导致费用过高。
 * 防止网络滥用：限制单个交易对网络资源的占用。
 * 
 * EIP-1559 引入了基础费和小费：
 * 基础费：根据网络拥堵动态调整，会被销毁。
 * 小费：用户支付给矿工的额外费用，激励交易打包。
 * 
 * Gas费的用途
 * 激励矿工/验证节点：支付Gas费以激励他们处理交易。
 * 防止网络滥用：通过收费机制防止恶意行为。
 * 
 * Gas费是以太坊网络的核心机制，确保资源合理分配和网络安全。用户需根据需求调整Gas Price和Gas Limit，以优化交易成本。
 */

contract Gas {
    
    uint256 public i = 0;

    // Using up all of the gas that you send causes your transaction to fail.
    // State changes are undone.
    // Gas spent are not refunded.
    function forever() public {
        // Here we run a loop until all of the gas are spent
        // and the transaction fails
        while (true) {
            i += 1;
        }
    }
}

// if / else statement
contract IfElse {
    function foo(uint256 x) public pure returns (uint256) {
        if (x < 10) {
            return 0;
        } else if (x < 20) {
            return 1;
        } else {
            return 2;
        }
    }

    function ternary(uint256 _x) public pure returns (uint256) {
        // if (_x < 10) {
        //     return 1;
        // }
        // return 2;

        // shorthand way to write if / else statement
        // the "?" operator is called the ternary operator
        return _x < 10 ? 1 : 2;
    }
}

contract Loop {

    function loop() public pure {
        // for loop
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                // Skip to next iteration with continue
                continue;
            }
            if (i == 5) {
                // Exit loop with break
                break;
            }
        }

        // while loop
        uint256 j;
        while (j < 10) {
            j++;
        }
    }
}