// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "solmate/auth/Owned.sol";
import "openzeppelin-contracts/token/ERC721/IERC721.sol";
import "./uniswap/interfaces/INonfungiblePositionManager.sol";
import "./uniswap/libraries/TickMath.sol";
import "./uniswap/libraries/LiquidityAmounts.sol";
import "./ILock.sol";

contract Lock is ILock, Owned {
    IERC721 public uniswapV3;
    INonfungiblePositionManager public nonfungiblePositionManager;
    IUniswapV3Factory public uniswapV3Factory;

    /**
     * @notice Constructor
     */
    constructor(address _uniswapV3, address _nonfungiblePositionManager) Owned(msg.sender) {
        uniswapV3 = IERC721(_uniswapV3);
        nonfungiblePositionManager = INonfungiblePositionManager(_nonfungiblePositionManager);
        uniswapV3Factory = IUniswapV3Factory(nonfungiblePositionManager.factory());
    }

    function LockV3Nft(uint256 _tokenId) external returns (uint256){ 
        uniswapV3.transferFrom(msg.sender, address(this), _tokenId);
        return 1;
    }

    function UnlockV3Nft(uint256 _tokenId) external returns (bool){
        return true;
    }

    function getNFTAmounts(uint256 _tokenId) external view returns(address _token0,address _token1,uint24 _fee,uint256 _amount0,uint256 _amount1){
        (_token0,_token1,_fee,_amount0,_amount1) = _getNFTAmounts(_tokenId);
    }

    function _getNFTAmounts(uint256 _tokenId) internal view returns(address _token0,address _token1,uint24 _fee,uint256 _amount0,uint256 _amount1){
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
    }
}