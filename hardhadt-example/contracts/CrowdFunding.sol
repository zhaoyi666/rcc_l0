// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 众筹合约分为两种角色：一个是受益人，一个是资助者。
// 两种角色:
//      受益人   beneficiary => address         => address 类型
//      资助者   funders     => address:amount  => mapping 类型 或者 struct 类型

// 状态变量按照众筹的业务：
// 状态变量
//      筹资目标数量    fundingGoal
//      当前募集数量    fundingAmount
//      资助者列表      funders
//      资助者人数      fundersKey

// 需要部署时候传入的数据:
//      受益人
//      筹资目标数量

contract CrowdFunding {
    address public immutable beneficiary; // 受益人
    uint256 public immutable fundingGoal; // 筹资目标数量

    uint256 public fundingAmount; // 当前的 金额

    mapping(address => uint) funders; // 资助者列表

    bool private AVAILABLED = true; // 状态

    constructor(address _beneficiary, uint256 _fundingGoal) {
        beneficiary = _beneficiary;
        fundingGoal = _fundingGoal;
    }

    //仅仅受益人可操作
    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "You are not the beneficiary");
        _;
    }

    //合约状态是开启
    modifier availabled() {
        require(AVAILABLED, "The contract is not available");
        _;
    }

    // 进行资质 , 对超过目标的金额进行退回
    function contribute() public payable availabled {
        require(msg.value > 0, "The value must be greater than 0");

        // 如果超过目标金额，进行退回
        uint256 senderAmount = msg.value;
        uint256 refundAmount;
        if (fundingAmount + senderAmount > fundingGoal) {
            refundAmount = fundingAmount + msg.value - fundingGoal;
            senderAmount = msg.value - refundAmount;
        }

        fundingAmount += senderAmount;
        funders[msg.sender] += senderAmount;

        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
    }

    //取款 关闭
    function withdraw() external onlyBeneficiary returns (bool) {
        // 1.检查
        if (fundingAmount < fundingGoal) {
            return false;
        }
        //修改后的状态
        AVAILABLED = false;
        // 3. 操作取全部钱
        payable(beneficiary).transfer(address(this).balance);
        return true;
    }
}
