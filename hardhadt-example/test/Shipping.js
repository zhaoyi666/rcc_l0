// chai: 是一个断言库，用于编写测试断言。expect 是 chai 提供的一个断言函数，用于检查某个值是否符合预期。
const { expect } = require("chai");
// hre: 是 Hardhat Runtime Environment 的缩写，它提供了与 Hardhat 相关的工具和功能，比如部署合约、获取合约实例等。
const hre = require("hardhat");

// describe: 是 Mocha 测试框架中的一个函数，用于定义一个测试套件。这里定义了一个名为 Shipping 的测试套件，用于测试 Shipping 合约的功能。
describe("Shipping", function () {
  let shippingContract;
  before(async () => {
    // ⽣成合约实例并且复⽤
    //Hardhat 提供的一个方法，用于部署名为 Shipping 的合约。[] 表示构造函数没有参数。
    shippingContract = await hre.ethers.deployContract("Shipping", []);
  });
  it("should return the status Pending", async function () {
    // assert that the value is correct
    expect(await shippingContract.Status()).to.equal("Pending");
  });


  //测试合约中发送的事件。以确认事件会返回所需的说明。
  it("should return correct event description", async () => {
    // Calling the Delivered() function
    // Check event description is correct
    await expect(shippingContract.Delivered()) // 验证事件是否被触发
      .to.emit(shippingContract, "LogNewAlert") // 验证事件的参数是否符合预期
      .withArgs("Your package has arrived");
  }); 


  it("should return the status Shipped", async () => {
    // Calling the Shipped() function
    await shippingContract.Shipped();
    // Checking if the status is Shipped
    expect(await shippingContract.Status()).to.equal("Shipped");
  });



  
});

// https://hardhat.org/hardhat-runner/docs/guides/test-contracts
// npx hardhat test
// 指定测试文件运行
// npx hardhat test test/Shipping.js
//如果你想运行 test/Shipping.js 中描述为 "should return the status Pending" 的测试用例
// npx hardhat test test/Shipping.js --grep "should return the status Shipped"

// 所有测试文件下 描述为 "should return the status Pending" 的测试用例
// npx hardhat test --grep "should return the status Shipped"

//使用 npx hardhat test <文件路径> 可以指定运行某个测试脚本。
//使用 --grep 参数可以运行特定的测试用例。
//通过修改 hardhat.config.js 可以设置默认的测试文件。
