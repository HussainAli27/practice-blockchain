const hre = require("hardhat");

async function main() {
  // Replace with the actual USDT contract address for your network
  const USDT_ADDRESS = "0xdAC17F958D2ee523a2206206994597C13D831ec7"; // Ethereum Mainnet USDT

  // Get the contract factory
  const DemocracyFactory = await hre.ethers.getContractFactory("Democracy");

  // Get a signer (first account by default)
  const [signer] = await hre.ethers.getSigners();

  console.log("Deploying Democracy contract with signer:", signer.address);

  // Deploy the contract with the USDT address
  const democracyContract = await DemocracyFactory.connect(signer).deploy(USDT_ADDRESS);

  // Wait for deployment to complete
  await democracyContract.waitForDeployment();

  // Get the deployed contract address
  const democracyDeployedAddress = democracyContract.target;

  console.log("Democracy contract deployed to:", democracyDeployedAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
