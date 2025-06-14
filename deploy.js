async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with account:", deployer.address);

  const MyContract = await ethers.getContractFactory("MyContract");
  const myContract = await MyContract.deploy();
  await myContract.waitForDeployment();

  console.log("MyContract deployed to:", await myContract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});