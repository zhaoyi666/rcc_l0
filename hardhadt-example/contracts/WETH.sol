// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//WETH 是包装 ETH 主币，作为 ERC20 的合约。
// https://eips.ethereum.org/EIPS/eip-20
// 标准的 ERC20 合约包括如下几个

// 3 个查询
// balanceOf: 查询指定地址的 Token 数量
// allowance: 查询指定地址对另外一个地址的剩余授权额度
// totalSupply: 查询当前合约的 Token 总量
// 2 个交易
// transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
// 这是一个写入方法，所以还会抛出一个 Transfer 事件。
// transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
// 2 个事件
// Transfer
// Approval
// 1 个授权
// approve: 授权指定地址可以操作调用者的最大 Token 数量。

contract WETH {
    uint8 public decimals = 18;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowed;

    uint256 private _totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from] -= value;
        _balances[to] += value;
        _allowed[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }
}
