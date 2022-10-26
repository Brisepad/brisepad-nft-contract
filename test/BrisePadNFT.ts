import { BrisePadNFT } from './../typechain-types/contracts/BrisePadNFT';
import { ethers } from "hardhat";
import { BigNumber, Contract, Signer} from "ethers";
import { assert, expect, should } from "chai";

describe("BrisePadNFT", function () {
    let brisePadNFT: Contract;
    let accounts: any[];
    let feeReceiver;
    const baseUrl = "https://myipfslink.com/";


    // NFTs
    const ROUGH_RYDER = 289;
    const F_FURIOUS = 51;
    const HYDRO_DRIVE = 703;
    const LAND_JET = 101;
    const D_LONER = 40;
    const CRAZY_FUMEZ = 849;
    const LAND_SLIDER = 7;
    const CRANK_WHEELS = 231;
    const LORD_LUCAD = 152;

    before(async function () {
        accounts = await ethers.getSigners();
        feeReceiver = accounts[1].address;
    
        const BrisePadNFT = await ethers.getContractFactory("BrisePadNFT");
        brisePadNFT = await BrisePadNFT.deploy(feeReceiver, baseUrl);
        await brisePadNFT.deployed();
        console.log("BrisePadNFT deployed at: ", brisePadNFT.address);
    });

    
    it("Should mint NFT", async function () {
        // First mint
        const mintAmount: number = 5;
    
        const overrides = {
            value: ethers.utils.parseEther("5")
        };
        await brisePadNFT.mint(ROUGH_RYDER, mintAmount, overrides);
        const newTotalSupply: BigNumber = await brisePadNFT.totalSupply(ROUGH_RYDER);
        expect(newTotalSupply.toNumber()).to.equal(mintAmount);

        // Second mint
        await brisePadNFT.connect(accounts[2]).mint(ROUGH_RYDER, mintAmount, overrides);
        const newTotalSupply2: BigNumber = await brisePadNFT.totalSupply(ROUGH_RYDER);
        expect(newTotalSupply2.toNumber()).to.equal(2 * mintAmount);

    });

    it("Should note if a token supply max is reached",async function () {
        const ryderAns = await brisePadNFT.isMaxSupplyReached(ROUGH_RYDER);
        const jetAns = await brisePadNFT.isMaxSupplyReached(LAND_JET);
        
        expect(ryderAns).to.equal(true);
        expect(jetAns).to.equal(false);
    });

    it("Should NOT mint due to insufficient mint fee sent", async function () {
        const mintAmount: number = 3;
        const overrides = {
            value: ethers.utils.parseEther("1")
        };
        await expect(brisePadNFT.connect(accounts[0]).mint(F_FURIOUS, mintAmount, overrides))
            .to.be.revertedWith("BrisePadNFT: Not enough mint fee");
    });

    it("Should NOT mint due to exceeded token per wallet", async function () {
        const excessMintAmt: number = 6;
        const overrides = {
            value: ethers.utils.parseEther("12")
        };
        await expect(brisePadNFT.connect(accounts[2]).mint(F_FURIOUS, excessMintAmt, overrides))
            .to.be.revertedWith("BrisePadNFT: Wallet max exceeded");
    });

    it("Should NOT mint due to exceeded max supply", async function () {
        const excessMintAmt: number = 11;
        const overrides = {
            value: ethers.utils.parseEther("12")
        }
        await expect(brisePadNFT.connect(accounts[3]).mint(HYDRO_DRIVE, excessMintAmt, overrides))
            .to.be.revertedWith("BrisePadNFT: Max supply exceeded");
    });
});