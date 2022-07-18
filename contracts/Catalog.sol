// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/ICatalog.sol";

contract Catalog is ERC1155, ICatalog {
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIds;
  mapping(uint256 => address) public itemOwner;
  mapping(uint => ICatalog.Item) public itemDetails;
  uint itemsCount;
  ICatalog.RentalStatus defaultStatus = ICatalog.RentalStatus.AVAILABLE;

  constructor() ERC1155("OoohGirl") {}

  function addItem(
    string memory _name,
    string memory _metadataURI,
    uint _dailyCostInWei)
    external override returns(uint currentTokenId) {

    ICatalog.Item memory itemDetail = ICatalog.Item(msg.sender, _name, _metadataURI, _dailyCostInWei, defaultStatus);

    _tokenIds.increment();
    currentTokenId = _tokenIds.current();
    itemDetails[currentTokenId] = itemDetail;

    super._mint(msg.sender, currentTokenId, 1, "");
    itemOwner[currentTokenId] = msg.sender;
  }

  function uri(uint256 id) public view override(ERC1155, IERC1155MetadataURI) returns (string memory) {
    require(itemOwner[id] != address(0), "Token does not exist");
    return itemDetails[id].metadataURI;
  }

  function removeItem(uint256 _id) external returns(bool) {
    require(itemOwner[_id] == msg.sender, "Only owner can remove an item");
    itemOwner[_id] = address(0);
    delete(itemDetails[_id]);
    emit RemoveItem(_id);
    return true;
  }

  function getItemDetails(uint256 id) external view returns(ICatalog.Item memory item) {
    item = itemDetails[id];
  }
}