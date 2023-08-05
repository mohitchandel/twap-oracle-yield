import { ethers } from "hardhat";

async function main() {
  const TWAPYield = await ethers.deployContract("TWAPYield");

  await TWAPYield.waitForDeployment();

  console.log(`TWAPYield contract deployed to ${TWAPYield.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
