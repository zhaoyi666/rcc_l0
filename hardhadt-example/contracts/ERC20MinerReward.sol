// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22;

//ERC20: 从 OpenZeppelin 导入 ERC-20 标准合约。
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20MinerReward is ERC20 {
    event LogNewAlert(string description, address indexed _from, uint256 _n);

    constructor() ERC20("MinerReward", "MRW") {}

    //定义了一个名为 _reward 的公共函数，用于奖励矿工。
    function _reward() public {
        //调用 _mint 函数，向当前区块的矿工地址 block.coinbase 铸造 20 个代币。
        _mint(block.coinbase, 20);
        emit LogNewAlert("_rewarded", block.coinbase, block.number);
    }
}
