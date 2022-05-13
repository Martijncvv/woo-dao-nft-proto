// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title Contract for WOO-DAO NFT mint;
/// @author Martijncvv
/// @notice Openzeppelin based ERC721; Role-based access control,
/// @notice Pausabe, Disableable transfers, Bulk mint functionality
/// @notice This is a test contract.
contract WooDaoNftProto_1 is ERC721, ERC721URIStorage, Pausable, AccessControl {

    /// @notice Emitted when token is minted
    /// @param sender Address that sent mint tx
    /// @param receiver Address that receives the nft
    /// @param tokenId Token Id of NFT
    event MintNFT(address indexed sender, address indexed receiver, uint tokenId);

    // Keeps track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Used for Soulbound status
    bool public allowTransfer;

    // Accesscontrol Roles
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    
    /// @notice Sets roles, ERC721 info and disables transfers
    constructor() ERC721("WooDaoNftProto_1", "WDNP")  {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        
        allowTransfer = false;
    }

    /// @notice Gives Pauser Roles ability to (un)pause contract functionality
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /// @notice Gives Pauser Roles ability to pause transfer functionality
    function enableTransfers() public onlyRole(PAUSER_ROLE) {
        allowTransfer = true;
    }
    /// @notice Gives Pauser Roles ability to unpause transfer functionality
    function disableTransfers() public onlyRole(PAUSER_ROLE) {
        allowTransfer = false;
    }

    /// @notice Gives Minter Roles the ability to (bulk) mint NFTs to accounts with given URI input
    /// @param accounts Array of receiving addresses
    /// @param uris Array of URI links
    function mintNfts(address[] memory accounts, string[] memory uris) public onlyRole(MINTER_ROLE) 
    {
        for(uint i = 0; i< accounts.length; i++) {
            uint256 newItemId = _tokenIdCounter.current();
            _mint(accounts[i], newItemId);
            _setTokenURI(newItemId, uris[i]);
            _tokenIdCounter.increment();

            console.log("An NFT w/ ID %s has been minted to %s", newItemId, accounts[i]);
            emit MintNFT(msg.sender, accounts[i], newItemId);
        }
    }
 
    /// @notice Gets executed before each Transfer type; checks if contract is paused and if 
    /// @notice user is allowed to transfer
    /// @param from Sending address
    /// @param to Receiving address
    /// @param tokenId Token that gets transfered
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
    

    /// @notice The following functions appear more than once because of inheritance and require overrides.
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

// GAS COSTS TEST
// contract deployment; role-based accesscontrol, Pausable, Disable transfers,
// cost: 3746065 gas    gwei 55     $470    ETH $2300

// TEST MINTS
// First NFT mint (More expensive in general)
// cost: 173755 gas     gwei 55     $21     ETH $2300
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"],["https://woo-dao.org/nft-data/accountAddress"]

// single NFT mint, 2nd NFT mint or more
// cost: 139555 gas     gwei 55     $17     ETH $2300
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"],["https://woo-dao.org/nft-data/accountAddress"]

// 2 NFT mints
// cost: 237283 gas     gwei 55     $30     ETH $2300
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"],["https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress"]

// 10 NFT mints 
// cost: 1038460 gas     gwei 55     $130   ETH $2300
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372"],["https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress", "https://woo-dao.org/nft-data/accountAddress"]
// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2","0x17F6AD8Ef982297579C203069C1DbfFE4348c372"],
// ["https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress", "https://woo-dao.org/accountAddress"]

// 25 NFTs mints
// cost: 2573153 gas     gwei 55     $323   ETH $2300
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


