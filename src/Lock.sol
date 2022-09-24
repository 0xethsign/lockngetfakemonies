// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "solmate/auth/Owned.sol";
import "openzeppelin-contracts/token/ERC721/IERC721.sol";
import "./IFakeMonies.sol";
import "./uniswap/interfaces/INonfungiblePositionManager.sol";
import "./uniswap/libraries/TickMath.sol";
import "./uniswap/libraries/LiquidityAmounts.sol";
import "./ILock.sol";
interface IUniswapV3Oracle{
    function getTWAPQuoteNft(uint256 _tokenId,address _quoteToken) external view returns(uint256 _quoteAmount,uint256 _gasEstimate);
}

contract Lock is ILock, Owned {
    mapping (uint256 => address) LP;
    IFakeMoney immutable fakeMonies;
    IERC721 immutable uniswapV3;
    INonfungiblePositionManager immutable nonfungiblePositionManager;
    IUniswapV3Factory immutable uniswapV3Factory;
    IUniswapV3Oracle immutable oracle;
    /**
     * @notice Constructor
     */
    constructor(address _uniswapV3, address _nonfungiblePositionManager, address _fakeMonies, address _oracle) Owned(msg.sender) { 
        oracle = IUniswapV3Oracle(_oracle);
        fakeMonies = IFakeMoney(_fakeMonies);
        uniswapV3 = IERC721(_uniswapV3);
        nonfungiblePositionManager = INonfungiblePositionManager(_nonfungiblePositionManager);
        uniswapV3Factory = IUniswapV3Factory(nonfungiblePositionManager.factory());
    }

    function LockV3Nft(uint256 _tokenId) external returns (uint256) {
        uint256 _amount0;
        uint256 _amount1;
        uint256 _price0;
        uint256 _price1;
        uint256 totalLiquidityInToken0;
        (,,,_amount0,_amount1, _price0, _price1) = _getNFTAmounts(_tokenId);
        totalLiquidityInToken0 = _amount0 + ((_amount1 * _price1) / _price0);
        LP[_tokenId] = msg.sender;
        uniswapV3.transferFrom(msg.sender, address(this), _tokenId);
        fakeMonies.mint(msg.sender, totalLiquidityInToken0);
        return 1;
    }

    function UnlockV3Nft(uint256 _tokenId) external returns (bool){ 
        require(LP[_tokenId] == msg.sender, "Invalid call");
        uint256 _amount0;
        uint256 _amount1;
        uint256 _price0;
        uint256 _price1;
        uint256 totalLiquidityInToken0;
        (,,,_amount0, _amount1, _price0, _price1) = _getNFTAmounts(_tokenId);
        require(fakeMonies.balanceOf(msg.sender) >= totalLiquidityInToken0, "Insufficient balance of FakeMoney");
        fakeMonies.transferFrom(msg.sender, address(0), totalLiquidityInToken0);
        uniswapV3.approve(msg.sender, _tokenId);
        return true;
    }

    function _getNFTAmounts(uint256 _tokenId) internal view returns(address _token0,address _token1,uint24 _fee,uint256 _amount0,uint256 _amount1, uint256 price0, uint256 price1){
        int24 _tickLower;
        int24 _tickUpper;
        uint128 _liquidity;
        (,,_token0,_token1,_fee,_tickLower,_tickUpper,_liquidity,,,,) = nonfungiblePositionManager.positions(_tokenId);
        IUniswapV3Pool _uniswapV3Pool = IUniswapV3Pool(uniswapV3Factory.getPool(_token0,_token1,_fee));
        (,int24 _poolTick,,,,,) = _uniswapV3Pool.slot0();
        uint160 _sqrtRatioX96 = TickMath.getSqrtRatioAtTick(_poolTick);
        uint160 _sqrtRatioAX96 = TickMath.getSqrtRatioAtTick(_tickLower);
        uint160 _sqrtRatioBX96 = TickMath.getSqrtRatioAtTick(_tickUpper);
        (_amount0,_amount1) = LiquidityAmounts.getAmountsForLiquidity(_sqrtRatioX96,_sqrtRatioAX96,_sqrtRatioBX96,_liquidity);
        (price0,) = oracle.getTWAPQuoteNft(_tokenId, _token0);
        (price1,) = oracle.getTWAPQuoteNft(_tokenId, _token1);
    }
}