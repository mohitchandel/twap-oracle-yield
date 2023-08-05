import { expect } from "chai";
import { ethers } from "hardhat";

describe("TWAPYield", function () {
  let contract: any;
  let user: any;

  beforeEach(async function () {
    [user] = await ethers.getSigners();
    const TWAPYield = await ethers.getContractFactory("TWAPYield");
    contract = await TWAPYield.deploy();
  });

  describe("Catching Success Yield Calculation", function () {
    it("Should return the correct yield", async function () {
      const tokenIn = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
      const tokenOut = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
      const amountIn = ethers.parseEther("1");
      const seconds = 600;
      const fee = 3; // can be anything

      const calculatedYield = await contract.calculateYield(
        tokenIn,
        tokenOut,
        amountIn,
        seconds,
        fee
      );

      expect(calculatedYield).to.equal(0);
    });
  });
});
