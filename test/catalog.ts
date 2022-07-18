import { expect } from "chai";
import { ethers } from "hardhat";

// import "../contracts/Catalog.sol";
// import "../contracts/Rentals.sol";

describe("Catalog", function () {
  it("Should add item", async function () {
    const signers = await ethers.getSigners();
    const testCatalogFactory = await ethers.getContractFactory("Catalog");
    const testCatalog = await testCatalogFactory.deploy();
    await testCatalog.deployed();

    await testCatalog.addItem("Brush", "http://someurl.xyz", 1000);
    expect(await testCatalog.itemOwner(1)).to.equal(
      await signers[0].getAddress()
    );

    expect(await testCatalog.uri(1)).to.equal("http://someurl.xyz");
    const itemDetails = await testCatalog.itemDetails(1);
    console.log(itemDetails);
    // TODO add expects for the following
    /*
      name: 'Brush',
      metadataURI: 'http://someurl.xyz',
      cost: [
        BigNumber { value: "1" },
        BigNumber { value: "2" },
        price: BigNumber { value: "1" },
        duration: BigNumber { value: "2" }
      ]
    */
  });

  it("Should remove item", async function () {
    const testCatalogFactory = await ethers.getContractFactory("Catalog");
    const testCatalog = await testCatalogFactory.deploy();
    await testCatalog.deployed();

    await testCatalog.addItem("Brush", "http", 1000);
    await testCatalog.removeItem(1);
    expect(await testCatalog.itemOwner(1)).to.equal(
      ethers.constants.AddressZero
    );
    // TODO check that the details are empty too
  });

  it("Should enforce only owner", async function () {
    const signers = await ethers.getSigners();
    const testCatalogFactory = await ethers.getContractFactory("Catalog");
    const testCatalog = await testCatalogFactory.deploy();
    await testCatalog.deployed();

    await testCatalog.addItem("Brush", "http", 1000);
    await expect(
      testCatalog.connect(await signers[1]).removeItem(1)
    ).to.be.revertedWith("Only owner can remove an item");
  });
});
