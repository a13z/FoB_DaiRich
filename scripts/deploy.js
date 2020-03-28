// We require the Buidler Runtime Environment explicitly here. This is optional
// when running the script with `buidler run <script>`: you'll find the Buidler
// Runtime Environment's members available as global variable in that case.
const env = require("@nomiclabs/buidler");

//const HybridBank = artifacts.require("HybridBank");

async function main() {
  // You can run Buidler tasks from a script.
  // For example, we make sure everything is compiled by running "compile"
  await env.run("compile");

  // We require the artifacts once our contracts are compiled
  const HybridBank = env.artifacts.require("HybridBank");
  const HybridBankDeployed = await HybridBank.new();

  console.log("HybridBank address:", HybridBank.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
