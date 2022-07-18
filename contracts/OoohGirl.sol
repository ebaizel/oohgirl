// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import './interfaces/ICatalog.sol';
import './interfaces/IRentals.sol';

contract OoohGirl is Ownable {

  mapping(uint256 => uint256) private catalogTokenIdToRentalTokenId;

  IRentals immutable rentals;
  ICatalog immutable catalog;
  uint8 immutable royaltyPercentage;

  // constructor(IRentals _rentals, ICatalog _catalog) {
  constructor(address _rentals, address _catalog) {
    rentals = IRentals(_rentals);
    catalog = ICatalog(_catalog);
    royaltyPercentage = 5;
  }

  // This function creates a rental for the msg.sender for the given duration
  /// @param _catalogItemId Id of the item in the catalog
  /// @param _durationInDays Number of days that the item will be rented for
  /// @dev Only callable by contract owner
  function rentItem(uint256 _catalogItemId, uint256 _durationInDays) public payable returns (uint256) {
    console.log("in rent item");
    ICatalog.Item memory item = catalog.getItemDetails(_catalogItemId);
    console.log("after calling catalog");
    require(msg.value >= (item.dailyRentalCost * _durationInDays));
    console.log("about to call rentals.initiaite");
    uint256 rentalTokenId = rentals.initiateNewRental(msg.sender, item.metadataURI, _durationInDays);
    catalogTokenIdToRentalTokenId[_catalogItemId] = rentalTokenId;
    return rentalTokenId;
  }

  function endRental(uint256 _catalogItemId) public payable {
    uint256 rentalTokenId = catalogTokenIdToRentalTokenId[_catalogItemId];
    rentals.processCompletedRental(rentalTokenId);
    // Distribute payments
    ICatalog.Item memory item = catalog.getItemDetails(_catalogItemId);
    uint256 payout = msg.value * (100 - royaltyPercentage) / 100;
    payable(item.owner).transfer(payout);
  }
}