// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/** Imports */
import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@thirdweb-dev/contracts/extension/PermissionsEnumerable.sol";

/** Contracts */

contract Contract is ERC721Base, PermissionsEnumerable {
    /** Constructor */

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    ) ERC721Base(_name, _symbol, _royaltyRecipient, _royaltyBps) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /** State variables */

    mapping(uint256 => uint256) public powerLevel;

    /** Functions */

    function setPowerLevel(uint256 _tokenId, uint256 _powerLevel)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        powerLevel[_tokenId] = _powerLevel;
    }

    function mintTo(address _to, string memory _tokenURI)
        public
        virtual
        override
    {
        uint256 tokenId = nextTokenIdToMint();
        super.mintTo(_to, _tokenURI);
        powerLevel[tokenId] = tokenId;
    }

    function burn(uint256 _tokenId) public virtual override {
        burn(_tokenId);
    }
}
