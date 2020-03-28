<<<<<<< HEAD
const Migrations = artifacts.require("Migrations");
=======
var Migrations = artifacts.require("./Migrations.sol");
>>>>>>> 6299496d828f31180312d3dd8c0ed03827202362

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
