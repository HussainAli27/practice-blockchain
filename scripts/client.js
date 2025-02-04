const { debug } = require("console");
const hre = require("hardhat");
async function main() {
  debugger;
  const SimpleStorage = await hre.ethers.getContractFactory("SimpleStorage");
  const simpleStorage = await SimpleStorage.attach(
    "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9"
  );

  // Set data
  await simpleStorage.set(42);

  // Get data
  const result = await simpleStorage.get();
  console.log("Stored data:", result.toString());
}

main();
