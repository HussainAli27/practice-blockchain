const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const MyContractFactory = await hre.ethers.getContractFactory("Faucet");

  // Get a signer (first account by default)
  const [signer] = await hre.ethers.getSigners();

  // Deploy the contract
  const myContract = await MyContractFactory.connect(signer).deploy();

  // Wait for deployment to complete
  await myContract.waitForDeployment();

  // Get the deployed contract address
  const myContractDeployedAddress = myContract.target;

  console.log("SimpleStorage deployed to:", myContractDeployedAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
