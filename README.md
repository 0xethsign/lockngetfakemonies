## README

`Write a smart contract to lock Uniswap V3 NFT and issue ERC20 equal to total liquidity in that NFT w.r.t. token0. Example: If token0 is DAI and token1 is ETH, and the NFT holds 1 ETH and 1000 DAI, mint 2000 ERC20 tokens.`

The [`Lock.sol`](./src/Lock.sol) contains the code to lock and unlock the LP NFT.

Test:

![outputimage](./testoutputimage/Screenshot%202022-09-26%20at%206.03.56%20AM.png)

To reproduce the test, the steps are:

run `anvil --fork-url <MAINNET_RPC_URL>` on a terminal

run the following commands on another terminal

`forge create --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 src/FakeMonies.sol:FakeMoney`

This deploys the FakeMoney ERC20 token on the forked network. Enter the deployed address as the second parameter in `Lock.t.sol` `setUp()` function when initializing with `new Lock(,)`

`forge test --match-path test/Lock.t.sol --rpc-url http://127.0.0.1:8545 -vvvv`
