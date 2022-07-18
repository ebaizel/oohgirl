// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "./interfaces/IRentals.sol";

contract Rentals is IRentals, ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  mapping(uint256 => uint256) private _rentalDurations;

  constructor() ERC721("Rentals", "RNTL") {}

  function initiateNewRental(
    address _renter,
    string memory _tokenURI,
    uint256 _rentalDurationInDays)
    public onlyOwner returns (uint256)
    {
    _tokenIds.increment();
    uint256 rentalTokenId = _tokenIds.current();
    _mint(_renter, rentalTokenId);
    _setTokenURI(rentalTokenId, _tokenURI);
    _rentalDurations[rentalTokenId] = block.timestamp + (_rentalDurationInDays * 1 days);
    emit StartedRental(rentalTokenId, block.timestamp, _rentalDurationInDays);
    return rentalTokenId;
  }

  // Anyone should be able to call this
  function processCompletedRental(uint256 _tokenId) public {
    // Verify the rental has ended
    require(block.timestamp > _rentalDurations[_tokenId], "Rental still active");
    _burn(_tokenId);
    emit ProcessedRentalCompletion(_tokenId, block.timestamp);
  }

}