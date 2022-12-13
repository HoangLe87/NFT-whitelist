// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract NFTCraze is ERC721Enumerable, Ownable {
    string _baseTokenURI;
    // the price of one Crypto Dev NFT
    uint256 public _price = 0.01 ether;
    // _paused is used to pause the contract in case of an emergency
    bool public _paused;
    // max number of tokens
    uint256 public maxToekenIds = 20;
    uint256 public tokenIds;
    // Whitelist contract instance
    IWhitelist whitelist;
    // bool to keep track of whether presale started or not
    bool public presaleStarted;
    // timestamp for when presale would end
    uint256 public presaleEnded;
    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract currently paused");
        _;
    }

    // constructor
    constructor(string memory baseURI, address whitelistedContract)
        ERC721("NFT Craze", "NFTC")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistedContract);
    }

    //
    function presaleMint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEneded,
            "Presale is not running"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(tokenIds < maxToekenIds, "Exceed maximum of NFT Craze supply");
        require(msg.value >= price, "Please pay at least the minumum price");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && presaleEnded <= block.timestamp,
            "Presale has not ended yet"
        );
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(tokenIds < maxToekenIds, "Exceed maximum of NFT Craze supply");
        require(msg.value >= price, "Please pay at least the minumum price");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // setPaused makes the contract paused or unpaused
    function setPaused(bool val) external onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
