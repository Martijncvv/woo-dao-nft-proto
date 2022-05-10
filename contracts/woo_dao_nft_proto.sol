// SPDX-License-Identifier: UNLICENSED
//3621421 gas
pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract WooDaoNftProto_1 is ERC721, ERC721URIStorage, Pausable, AccessControl {
    // keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bool public allowTransfer;

    // roles
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    

    constructor() ERC721("WooDaoNftProto_1", "WDNP")  {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        

        allowTransfer = false;
   
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function enableTransfers() public onlyRole(PAUSER_ROLE) {
        allowTransfer = true;
    }
    function disableTransfers() public onlyRole(PAUSER_ROLE) {
        allowTransfer = false;
    }

    function mintNfts(address[] memory accounts, string[] memory uris) public onlyRole(MINTER_ROLE) 
    {
        for(uint i = 0; i< accounts.length; i++) {
            uint256 newItemId = _tokenIdCounter.current();
            _mint(accounts[i], newItemId);
            _setTokenURI(newItemId, uris[i]);

            _tokenIdCounter.increment();

            console.log("An NFT w/ ID %s has been minted to %s", newItemId, accounts[i]);
        }
    }
 

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        if (allowTransfer == false) {
            require(hasRole(MINTER_ROLE, msg.sender), 'WooDaoNftProto: ALLOW_TRANSFER_FALSE');
        }
        super._beforeTokenTransfer(from, to, tokenId);
    }
    
    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
     
}

// contract deployment; role-based accesscontrol, Pausable, Disable transfers,
// cost: 3746065 gas    gwei 55     $470    

// TEST MINTS
// First NFT mint (More expensive in general)
// cost: 173755 gas     gwei 55     $21
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"],["https://woo-dao.org/nft-data/accountAddress"]

// single NFT mint, 2nd NFT mint or more
// cost: 139555 gas     gwei 55     $17
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"],["https://woo-dao.org/nft-data/accountAddress"]

// 2 NFT mints
// cost: 237283 gas     gwei 55     $30
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"],["https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress"]

// 10 NFT mints 
// cost: 1106860 gas     gwei 55     $139
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372"],["https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress"]

// 25 NFTs mints
// cost: 2573153 gas     gwei 55     $323
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372", 
// "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372",
// "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372",
// "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372",
// "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372"]
// ,["https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress",
//  "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress",
//   "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress",
//    "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress",
//     "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress"]


