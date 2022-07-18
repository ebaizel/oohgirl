// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';

interface ICatalog is IERC1155MetadataURI {

  // If a required condition for executing the function is not met, it reverts and throws this error
  error InvalidConditions();

  enum RentalStatus { AVAILABLE, RENTED, UNAVAILABLE }

  struct Item {
    address owner;
    string name;
    string metadataURI;
    uint256 dailyRentalCost;
    RentalStatus status;
  }

  event RemoveItem(
    uint256 indexed id
  );

  // Returns the id of the new item
  function addItem(string memory _name, string memory _metadataURI, uint _dailyCostInWei) external returns(uint);

  // function removeItem(uint id) external returns(bool);

  function getItemDetails(uint256 id) external returns(ICatalog.Item memory);
}