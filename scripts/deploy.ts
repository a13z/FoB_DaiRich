import { ethers } from "@nomiclabs/buidler";

async function main() {
  const factory = await ethers.getContract("HybridContract")

  // If we had constructor arguments, they would be passed into deploy()
  let contract = await factory.deploy("0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5","0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD","0x58AD4cB396411B691A9AAb6F74545b2C5217FE6a");

  // The address the Contract WILL have once mined
  console.log(contract.address);

  // The transaction that was sent to the network to deploy the Contract
  console.log(contract.deployTransaction.hash);

  // The contract is NOT deployed yet; we must wait until it is mined
  await contract.deployed()
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });