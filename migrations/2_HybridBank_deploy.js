var HybridBank = artifacts.require("HybridBank");

module.exports = function(deployer) {
    // deployment steps
    deployer.deploy(HybridBank,"0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5","0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD","0x58AD4cB396411B691A9AAb6F74545b2C5217FE6a");
};
