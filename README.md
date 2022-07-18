# OoooohGirl! 👗 😍 💵 
*Where did you get that outfit??*

You're going to see your favorite artist play in the metaverse. Everyone is going to be there, and you don't want to show up in just your default Decentraland outfit. You want to wear something snazzy! But you don't want to fork over the money to buy an outfit.

*Oohgirl! Rent that outfit instead!*

## How it works
Designers create catalogs of their products, which include the cost to rent.
Buyers peruse these catalogs, and can rent items for a specified period of time, eg 'rent this shirt for 2 days'.

## How it works - technical
Designer catalogs are maintained within an ERC1155 contract. Each NFT collection within the contract is owned by an individual designer. Each item within a collection is a rentable item. So a designer who has created four articles of clothing, would have a single entry within the overall ERC1155 contract, and four NFTs as part of that collection.

Rentals are ERC721 tokens that get minted when a renter submits a transaction. Also, the rental payment is sent to the contract, and paid out upon expiration of the token. Anyone can trigger this payment by calling the burn functionality after the rental has expired.

*The implementation is still a work in progress.*

## Future improvements
- Using a service like Superfluid, stream the payments to the designer instead an all-at-once payment at the end.

## To run the tests
```sh
npm install
npx hardhat test
```