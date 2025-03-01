const hre = require("hardhat");

async function main() {
  const MolandakBash = await hre.ethers.getContractFactory("MolandakBash");
  const molandakBash = await MolandakBash.deploy();
  await molandakBash.deployed();
  console.log("MolandakBash deployed to:", molandakBash.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
