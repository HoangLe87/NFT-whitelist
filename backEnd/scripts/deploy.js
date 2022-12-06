const main = async () => {
  console.log("starting deploy...");
  const whitelistContractFactory = await hre.ethers.getContractFactory(
    "Whitelist"
  );
  // 10 is the Maximum number of whitelisted addresses allowed
  console.log("deploying whitelistContract contract");
  const whitelistContract = await whitelistContractFactory.deploy(10);
  await whitelistContract.deployed();
  console.log(`whitelistContract deployed to ${whitelistContract.address}`);
};

const runMain = (async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
})();
