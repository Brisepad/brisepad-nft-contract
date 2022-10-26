import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

// const private_key = process.env.PRI_KEY;
// console.log("Priv key: ", private_key);

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "bitgert",
  networks: {
    hardhat: {},
    bitgert: {
      url: "https://mainnet-rpc.brisescan.com",
      accounts: [""],
      chainId: 32520
    }
  },
  mocha: {
    timeout: 120000
  }
};

export default config;
