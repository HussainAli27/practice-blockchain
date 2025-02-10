const hre = require("hardhat");

async function main() {
  debugger;

  // Replace with your deployed Democracy contract address
  const DEMOCRACY_CONTRACT_ADDRESS = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";

  // Replace with the USDT contract address on your network
  const USDT_ADDRESS = "0xdAC17F958D2ee523a2206206994597C13D831ec7"; // Ethereum Mainnet USDT

  // Replace with the candidate's address (who will receive USDT)
  const CANDIDATE_ADDRESS = "0x1234567890abcdef1234567890abcdef12345678"; // Change to actual candidate address

  // Amount of USDT to send (convert to smallest unit, e.g., 6 decimals for USDT)
  const USDT_AMOUNT = hre.ethers.parseUnits("10", 6); // Sending 10 USDT (USDT has 6 decimals)

  // Get the contract instances
  const DemocracyContract = await hre.ethers.getContractFactory("Democracy");
  const democracy = await DemocracyContract.attach(DEMOCRACY_CONTRACT_ADDRESS);

  // Get the USDT contract instance
  const USDTContract = await hre.ethers.getContractAt("IERC20", USDT_ADDRESS);

  // Get the signer (first account from Hardhat)
  const [signer] = await hre.ethers.getSigners();

  console.log(`Approving ${DEMOCRACY_CONTRACT_ADDRESS} to spend ${USDT_AMOUNT} USDT`);

  // Approve the Democracy contract to spend USDT
  const approveTx = await USDTContract.connect(signer).approve(DEMOCRACY_CONTRACT_ADDRESS, USDT_AMOUNT);
  await approveTx.wait();
  console.log("Approval transaction successful:", approveTx.hash);

  console.log(`Funding candidate ${CANDIDATE_ADDRESS} with ${USDT_AMOUNT} USDT`);

  // Call fundCandidate function
  const tx = await democracy.connect(signer).fundCandidate(CANDIDATE_ADDRESS, USDT_AMOUNT);

  // Wait for the transaction to be mined
  await tx.wait();

  console.log("Fund transaction successful:", tx.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
