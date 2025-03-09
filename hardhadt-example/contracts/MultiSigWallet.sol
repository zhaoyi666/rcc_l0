// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 多签钱包的功能: 合约有多个 owner，一笔交易发出后，需要多个 owner 确认，确认数达到最低要求数之后，才可以真正的执行。

// 部署时候传入地址参数和需要的签名数
//      多个 owner 地址
//      发起交易的最低签名数
// 所有者可以提交交易、确认交易，并在满足条件时执行交易。

contract MultiSigWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public required;

    // 事件
    event Deposit(address indexed sender, uint256 amount);
    //提交交易
    event SubmitTransaction(uint256 indexed txId);
    //确认交易
    event ConfirmTransaction(address indexed owner, uint256 indexed txId);
    //执行交易
    event ExecuteTransaction(uint256 indexed txId);
    //撤销确认
    event RevokeConfirmation(address indexed owner, uint256 indexed txId);

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmationCount;
    }

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    //有接受 ETH 主币的方法，
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 函数修改器
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint256 _txId) {
        require(
            !isConfirmed[_txId][msg.sender],
            "Transaction already confirmed"
        );
        _;
    }

    //多个 owner 地址 , 发起交易的最低签名数
    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owner required");
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );

        for (uint256 index = 0; index < _owners.length; index++) {
            address owner = _owners[index];
            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique"); // 如果重复会抛出错误
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    // 查询余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    //提交交易
    function submitTransaction(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public onlyOwner {
        uint256 txId = transactions.length;
        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                confirmationCount: 0
            })
        );
        emit SubmitTransaction(txId);
    }

    //确认交易
    function confirmTransaction(
        uint256 _txId
    ) public onlyOwner txExists(_txId) notExecuted(_txId) notConfirmed(_txId) {
        Transaction storage transaction = transactions[_txId];
        isConfirmed[_txId][msg.sender] = true;
        transaction.confirmationCount += 1;
        emit ConfirmTransaction(msg.sender, _txId);

        if (transaction.confirmationCount >= required) {
            executeTransaction(_txId);
        }
    }

    //执行交易
    function executeTransaction(
        uint256 _txId
    ) public onlyOwner txExists(_txId) notExecuted(_txId) {
        Transaction storage transaction = transactions[_txId];
        require(
            transaction.confirmationCount >= required,
            "Not enough confirmations"
        );

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "Transaction execution failed");

        emit ExecuteTransaction(_txId);
    }

    //撤销确认
    function revokeConfirmation(
        uint256 _txId
    ) public onlyOwner txExists(_txId) notExecuted(_txId) {
        require(isConfirmed[_txId][msg.sender], "Transaction not confirmed");

        Transaction storage transaction = transactions[_txId];
        isConfirmed[_txId][msg.sender] = false;
        transaction.confirmationCount -= 1;

        emit RevokeConfirmation(msg.sender, _txId);
    }

    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    function getTransaction(
        uint256 _txId
    )
        public
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 confirmationCount
        )
    {
        Transaction storage transaction = transactions[_txId];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.confirmationCount
        );
    }
}
