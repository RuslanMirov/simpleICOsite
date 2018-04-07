var MyToken = artifacts.require("./MyToken.sol");
var DappTokenSale = artifacts.require("./DappTokenSale.sol");

module.exports = function(deployer) {
  deployer.deploy(MyToken, 1000000).then(function() {
    // Token price is 0.001 Ether
    var tokenPrice = 1000000000000000;
    return deployer.deploy(DappTokenSale, MyToken.address, tokenPrice);
  });
};
