import { expect } from "chai";
import { ethers } from "hardhat";

describe("Contract", function () {
  it("Should initialize", async function () {
    const testCatalogFactory = await ethers.getContractFactory("Catalog");
    const testRentalsFactory = await ethers.getContractFactory("Rentals");
    const testCatalog = await testCatalogFactory.deploy();
    const testRentals = await testRentalsFactory.deploy();

    const OoohGirl = await ethers.getContractFactory("OoohGirl");
    const ooohGirl = await OoohGirl.deploy(
      testRentals.address,
      testCatalog.address
    );
    await ooohGirl.deployed();
  });

  it("Should mint a rental nft", async function () {
    const testCatalogFactory = await ethers.getContractFactory("Catalog");
    const testRentalsFactory = await ethers.getContractFactory("Rentals");
    const testCatalog = await testCatalogFactory.deploy();
    const testRentals = await testRentalsFactory.deploy();

    const OoohGirl = await ethers.getContractFactory("OoohGirl");
    const ooohGirl = await OoohGirl.deploy(
      testRentals.address,
      testCatalog.address
    );
    await testRentals.transferOwnership(ooohGirl.address);
    await ooohGirl.deployed();
    await testCatalog.addItem("Brush", "http", 1000);
    const signers = await ethers.getSigners();
    await ooohGirl
      .connect(await signers[1])
      .rentItem(1, 3, { value: ethers.utils.parseUnits("3000", "wei") });
    expect(await testRentals.ownerOf(1)).to.equal(signers[1].address);
    // expect(await testCatalog.uri(1)).to.equal("http://someurl.xyz");
    // const itemDetails = await testCatalog.itemDetails(1);
  });

  it("Should pay out rental fees", async function () {
    const testCatalogFactory = await ethers.getContractFactory("Catalog");
    const testRentalsFactory = await ethers.getContractFactory("Rentals");
    const testCatalog = await testCatalogFactory.deploy();
    const testRentals = await testRentalsFactory.deploy();

    const OoohGirl = await ethers.getContractFactory("OoohGirl");
    const ooohGirl = await OoohGirl.deploy(
      testRentals.address,
      testCatalog.address
    );
    await testRentals.transferOwnership(ooohGirl.address);
    await ooohGirl.deployed();

    await testCatalog.addItem("Brush", "http", 1000);
    const signers = await ethers.getSigners();
    await ooohGirl
      .connect(await signers[1])
      .rentItem(1, 3, { value: ethers.utils.parseUnits("3000", "wei") });

    // Move the date to three days from now, so the rental will be expired
    // await ethers.provider.send("evm_mine", [Date.now() + (3600 * 24 * 3)]);

    // const endRentalTx = await ooohGirl.endRental(1);
    // await endRentalTx.wait();
  });
});
