Looking at the contracts we can see a vulnerability in `FreeRiderNFTMarketplace`. `buyMany` is an external payable function that calls a private `_buyOne` function that uses `msg.value`. When using a `payable` function, `for` loop and `msg.value` the function can be exploited. This pattern effectively means that we can buy multiple NFTs for the same sent value and the payment of the seller will continue functioning, despite the fact that we sent too little ether, because it will instead use the marketplace’s own balance of 90 ether in this case. To learn more on this vulnerability see [SushiSwap MISO](https://www.paradigm.xyz/2021/08/two-rights-might-make-a-wrong) and [Opyn Hack](https://peckshield.medium.com/opyn-hacks-root-cause-analysis-c65f3fe249db).