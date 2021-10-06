var CryptoBears = artifacts.require("./CryptoBears.sol");
module.exports = function(deployer) {
  deployer.deploy(CryptoBears);
};