// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IRentals is IERC721 {

  event StartedRental (
    uint256 indexed tokenId,
    uint256 blockTimestamp,
    uint256 rentalDurationInDays
  );

  event ProcessedRentalCompletion(
    uint256 indexed tokenId,
    uint256 blockTimestamp
  );

  function initiateNewRental(address _renter, string memory _tokenURI, uint256 _rentalDuration) external returns (uint256);
  function processCompletedRental(uint256 _catalogTokenId) external;
}