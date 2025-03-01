// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("ShippingModule", (m) => {
  //m.contract 是模块构建器提供的方法，用于部署一个智能合约。
  //第一个参数是合约的名称（"Shipping"），Hardhat Ignition 会根据这个名称找到对应的合约文件（如 contracts/Shipping.sol）。
  //第二个参数是合约构造函数的参数列表（[]），这里是一个空数组，表示构造函数没有参数。
  const shipping = m.contract("Shipping", []);
  //m.call 是模块构建器提供的方法，用于调用合约的函数。
  //第一个参数是合约实例（shipping），表示要调用哪个合约的函数。
  //第二个参数是函数名称（"Status"），表示要调用的函数。
  //第三个参数是函数参数列表（[]），这里是一个空数组，表示 Status 函数没有参数。
  m.call(shipping, "Status", []);
  return { shipping };
});

//部署
//1 先启动本地网络，如果已经启动就跳过这⼀步 npx hardhat node
//2 执行部署命令： npx hardhat ignition deploy ignition/modules/Shipping.js --network localhost
