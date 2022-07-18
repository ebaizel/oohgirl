import { expect } from "chai";
import { ethers } from "hardhat";

describe("Rentals", function () {
  it("Should rent item", async function () {
    const signers = await ethers.getSigners();
    const testRentalsFactory = await ethers.getContractFactory("Rentals");
    const testRentals = await testRentalsFactory.deploy();
    await testRentals.deployed();

    const rentalTokenId = await testRentals.callStatic.initiateNewRental(
      await signers[0].getAddress(),
      "http://someurl.xyz",
      3
    );

    expect(rentalTokenId).to.equal(1);
  });

  it("Should process rental terminations", async function () {
    const signers = await ethers.getSigners();
    const testRentalsFactory = await ethers.getContractFactory("Rentals");
    const testRentals = await testRentalsFactory.deploy();
    await testRentals.deployed();

    const rentalTx = await testRentals.initiateNewRental(
      await signers[0].getAddress(),
      "http://someurl.xyz",
      3
    );
    await rentalTx.wait();
    console.log("rental address ", testRentals.address);
    // Verify the duration is enforced
    await expect(testRentals.processCompletedRental(1)).to.be.revertedWith("Rental still active");

    // Move the date to three days from now, so the rental will be expired
    await ethers.provider.send("evm_mine", [Date.now() + (3600 * 24 * 4)]);

    const completeRentalTx = await testRentals.processCompletedRental(1);
    await completeRentalTx.wait();

    await expect(testRentals.ownerOf(1)).to.be.revertedWith("ERC721: owner query for nonexistent token");
  });
});
