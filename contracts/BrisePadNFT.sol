// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract BrisePadNFT is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {

    // Asset ids
    uint256 public ROUGH_RYDER = 289;
    uint256 public F_FURIOUS = 51;
    uint256 public HYDRO_DRIVE = 703;
    uint256 public LAND_JET = 101;
    uint256 public D_LONER = 40;
    uint256 public CRAZY_FUMEZ = 849;
    uint256 public LAND_SLIDER = 7;
    uint256 public CRANK_WHEELS = 231;
    uint256 public LORD_LUCAD = 152;


    uint256 private tokenMaxSupply = 246;
    mapping(address => mapping(uint256 => uint256)) private userMintedAmount;
    uint256 private tokenMaxPerWallet;
    uint256 private MINT_PRICE = 120000000 ether;
    string public baseUrl;
    address public feeReceiver;
    
    constructor(address _feeReceiver, string memory _baseUrl) ERC1155("") {
        feeReceiver = _feeReceiver;
        baseUrl = _baseUrl;
        
        
        // Init tokenMaxPerWallet here
        tokenMaxPerWallet = 10;
        
    }

    function setURI(string memory newuri) public onlyOwner {
        // _setURI(newuri);
        baseUrl = newuri;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(uint256 id, uint256 amount)
        public
        payable 
    {
        _checkEligible(_msgSender(), msg.value, id, amount);
        userMintedAmount[_msgSender()][id] += amount;
        _mint(_msgSender(), id, amount, "");

        payable(feeReceiver).transfer(msg.value);
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        public
        payable
    {
        _checkEligibleBatch(_msgSender(), msg.value, ids, amounts);
        _mintBatch(_msgSender(), ids, amounts, "");
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // Custom functions
    function uri(uint256 tokenId) public view override returns (string memory){
        return(
            string(
                abi.encodePacked(
                baseUrl,
                Strings.toString(tokenId),
                ".json"
                )
            )
        );
    }

    function _checkEligible(address caller, uint256 briseAmountSent, uint256 id, uint256 amount) internal view {
        // Check if Brise sent is the right amount
        require(briseAmountSent >= (MINT_PRICE * amount), "BrisePadNFT: Not enough mint fee");
        
        // Check if the max supply has been reached
        require((amount + totalSupply(id)) <= tokenMaxSupply, "BrisePadNFT: Max supply exceeded");
        
        // Check if the user has the max amount per wallet
        require((amount + userMintedAmount[caller][id]) <= tokenMaxPerWallet, "BrisePadNFT: Wallet max exceeded");
    }

    function _checkEligibleBatch(address caller, uint256 briseAmountSent, uint256[] memory ids, uint256[] memory amounts) internal view {
        require(amounts.length == ids.length, "BrisePadNFT: accounts and ids length mismatch");
        
        uint256 totalAmount;
        for(uint256 i = 0; i < amounts.length; i++){
            
            // Check if the max supply has been reached for each NFT
            require((amounts[i] + totalSupply(ids[i])) <= tokenMaxSupply, "BrisePadNFT: Max supply exceeded");
            
            // check if the user has the max amount per wallet for each NFT
            require((amounts[i] + userMintedAmount[caller][ids[i]]) <= tokenMaxPerWallet, "BrisePadNFT: Wallet max exceeded");
            
            totalAmount += amounts[i];
        }
        // Check if Brise sent is the right amount
        require(briseAmountSent >= (MINT_PRICE * totalAmount), "BrisePadNFT: Not enough mint fee");
        
    }

    function checkCanMint(uint256 id, uint256 amount, address caller) external view returns(bool) {
        bool ans;
        if(((amount + totalSupply(id)) <= tokenMaxSupply) && (amount + userMintedAmount[caller][id]) <= tokenMaxPerWallet){
            ans = true;
        }else{
            ans = false;
        }
        return ans;
    }

    function isMaxSupplyReached(uint256 id) public view returns(bool){
        return totalSupply(id) >= tokenMaxSupply;
    }


    function setTokenMaxSupply(uint256 newSupply) public onlyOwner {
        require(newSupply > 0, "BrisePadNFT: Max supply MUST the more than zero");
        tokenMaxSupply = newSupply;
    }

    function setTokenMaxPerWallet(uint256 newMax) public onlyOwner {
        require(newMax > 0, "BrisePadNFT: Wallet max MUST be more than zero");
        require(tokenMaxSupply >= newMax, "BrisePadNFT: Wallet max MUST NOT be more than max supply");
        tokenMaxPerWallet = newMax;
    }

    function setMintPrice(uint256 newPrice) public onlyOwner {
        require(newPrice > 0, "BrisePadNFT: Mint price MUST be more than zero");
        // require(tokenMaxSupply >= newMax, "BrisePadNFT: Wallet max MUST NOT be more than max supply");
        MINT_PRICE = newPrice * 1 ether;
    }

    function setFeeReceiver(address newReceiver) public onlyOwner {
        require(newReceiver > address(0), "BrisePadNFT: Fee receiver CANNOT be more than zero");
        feeReceiver = newReceiver;
    }

    function nftArray() public view returns(uint256[] memory){
         uint256[] memory a = new uint256[](9);
         a[0] = ROUGH_RYDER;
         a[1] = F_FURIOUS;
         a[2] = HYDRO_DRIVE;
         a[3] = LAND_JET;
         a[4] = D_LONER;
         a[5] = CRAZY_FUMEZ;
         a[6] = LAND_SLIDER;
         a[7] = CRANK_WHEELS;
         a[8] = LORD_LUCAD;
        return a;
    }

    function getTokenMintPrice() public view returns(uint256){
        return MINT_PRICE;
    }
    
    function getTokenMaxSupply() public view returns (uint256) {
        return tokenMaxSupply;
    }

    function getTokenMaxPerWallet() public view returns(uint256) {
        return tokenMaxPerWallet;
    }

    function getUserMintedAmount(address user, uint256 id) public view returns(uint256) {
        return userMintedAmount[user][id];
    }

    function getConfigs() public view returns(uint256[] memory){
        uint256[] memory configs = new uint256[](3);
        configs[0] = tokenMaxPerWallet;
        configs[1] = tokenMaxSupply;
        configs[2] = MINT_PRICE;
        return configs;
    } 
}
