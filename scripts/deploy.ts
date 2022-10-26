import { ethers } from "hardhat";
import { BigNumber, Contract, Signer} from "ethers";

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = ethers.utils.parseEther("1");

  // const Lock = await ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();
  // console.log(`Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`);

  const FEE_RECEIVER = "0x39442835A99fd8F90bf3Ed56EdEbA0e2fcB82e3E";
  const BASE_URL2 = "https://bafybeialg7vinh5hbgrsojtvdwriiqk6tfqb35e5ajearrnla6yiojpipm.ipfs.nftstorage.link/";
  const BASE_URL = "https://ipfs.io/ipfs/bafybeialg7vinh5hbgrsojtvdwriiqk6tfqb35e5ajearrnla6yiojpipm/";
  const BrisePadNFT = await ethers.getContractFactory("BrisePadNFT");
  const brisePadNFT: Contract = await BrisePadNFT.deploy(FEE_RECEIVER, BASE_URL2);
  await brisePadNFT.deployed();
  console.log(`BrisePadNFT is deployed at ${brisePadNFT.address}`)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
