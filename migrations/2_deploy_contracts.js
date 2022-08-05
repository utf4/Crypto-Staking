const MyToken = artifacts.require("MyToken");

module.exports = function (deployer) {
  deployer.deploy(MyToken,"Token1", "To", 3, 1000000);
};
