const main = async () => {
  const whitelistContract = "0xBb5d63FbD9d7AE206da1688ed1908245b57D6D2A"
  console.log("starting deploy...");
  const nftCrazeContract = await hre.ethers.getContractFactory("NFTCraze");
  // 10 is the Maximum number of whitelisted addresses allowed
  console.log("deploying NFTCraze contract");
  const nftCraze = await nftCrazeContract.deploy(10);
  await nftCraze.deployed();
  console.log(`NFTCraze deployed to ${nftCraze.address}`);
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
