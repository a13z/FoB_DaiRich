var HybridBank = artifacts.require('./HybridBank.sol');

module.exports = function(deployer) {
	deployer.deploy(HybridBank);
};
