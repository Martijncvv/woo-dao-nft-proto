// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract WooDaoNftProto_1 is ERC721URIStorage, ERC721Burnable, Pausable, AccessControl {
    // keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bool public allowTransfer;

    // roles
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    

    constructor() ERC721("WooDaoNftProto_1", "WDNP")  {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);

        allowTransfer = false;
   
    }

    /////////////////
    // NOT IMPLEMENTED YET
    modifier checkAllowTransfer() {
         require(allowTransfer == true, 'WooDaoNftProto_1: ALLOW_TRANSFER_FALSE');
         _;
    }
    function enableTransfers() public onlyRole(PAUSER_ROLE) {
        allowTransfer = true;
    }
    function disableTransfers() public onlyRole(PAUSER_ROLE) {
        allowTransfer = false;
    }
    // NOT IMPLEMENTED YET
    /////////////////

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }


    function mintNft(address account, string memory uri)
        public onlyRole(MINTER_ROLE) 
    {
        uint256 newItemId = _tokenIdCounter.current();
        _mint(account, newItemId);
        _setTokenURI(newItemId, uri);

        _tokenIdCounter.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, account);
    }


    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
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

