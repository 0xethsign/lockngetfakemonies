## README

`Write a smart contract to lock Uniswap V3 NFT and issue ERC20 equal to total liquidity in that NFT w.r.t. token0. Example: If token0 is DAI and token1 is ETH, and the NFT holds 1 ETH and 1000 DAI, mint 2000 ERC20 tokens.`

The [`Lock.sol`](./src/Lock.sol) contains the code to lock and unlock the LP NFT.

Test:

![outputimage](./testoutputimage/Screenshot%202022-09-26%20at%206.03.56%20AM.png)