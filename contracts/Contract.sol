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

    uint256 public _price = 0.01 ether;
    bool public _paused;
    uint256 public maxTokenIds = 10;
    uint256 public tokenIds;
    string _baseTokenURI;

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

    // This is an important feature if you want to prevent a security problem from escalating.

    modifier onlyWhenNotPaused() {
        require(
            !_paused,
            "This contract is currently in pause. Please wait until we fix the issue."
        );
        _;
    }

    // This function allows anyone to get the contract balance.

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // In case of emergency, we can pause the contract with this function.

    function setPaused(bool val) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _paused = val;
    }

    // This function uses onlyRole modifier and is useful to withdraw the ether obtained from minting. As you can see
    // only the Admin can withdraw the ether.

    function withdraw() public onlyRole(DEFAULT_ADMIN_ROLE) {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // As Solidity by example explains, this functions are required if some people make errors when sending transactions.
    // But also this functions are useful if someone wants to donate ETH directly to the contract without calling a function.

    receive() external payable {}

    fallback() external payable {}
}
