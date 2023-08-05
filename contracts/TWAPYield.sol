// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";
import "@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

contract TWAPYield {
    // Uniswap V3 factory address
    IUniswapV3Factory public constant UNISWAP_V3_FACTORY =
        IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);

    /**
     * @dev check for if pair is supported
     * @param _tokenA The first token of the pair
     * @param _tokenB The second token of the pair
     * @param _fee The fee tier of the pool
     */
    function isPairSupported(
        address _tokenA,
        address _tokenB,
        uint24 _fee
    ) internal pure returns (bool) {
        address _pool = PoolAddress.computeAddress(
            address(UNISWAP_V3_FACTORY),
            PoolAddress.getPoolKey(_tokenA, _tokenB, _fee)
        );
        if (_pool != address(0)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Get the time-weighted average price for the given token pair with the given fee tier.
     * @param _tokenIn The first token of the pair
     * @param _tokenOut The second token of the pair
     * @param _secondsAgo The amount of time to look back for the TWAP
     * @param _fee The fee tier of the pool
     */
    function getTwap(
        address _tokenIn,
        address _tokenOut,
        uint32 _secondsAgo,
        uint24 _fee
    ) internal view returns (uint256) {
        require(
            isPairSupported(_tokenIn, _tokenOut, _fee),
            "Pair not supported"
        );
        require(_secondsAgo <= 900, "Seconds too high");

        address _pool = PoolAddress.computeAddress(
            address(UNISWAP_V3_FACTORY),
            PoolAddress.getPoolKey(_tokenIn, _tokenOut, _fee)
        );

        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = _secondsAgo; // from (before)
        secondsAgos[1] = 0; // to (now)

        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(_pool).observe(
            secondsAgos
        );

        uint256 _priceAverage = TickMath.getSqrtRatioAtTick(
            int24((tickCumulatives[1] - tickCumulatives[0]) / _secondsAgo)
        );
        return _priceAverage;
    }

    /**
     * @dev Calculates the yield amount based on the percentage change in the time-weighted average price.
     * @param _tokenIn The first token of the pair
     * @param _tokenOut The second token of the pair
     * @param amount The amount of tokens to calculate the yield for
     * @param _secondsAgo The amount of time to look back for the initial TWAP
     */
    function calculateYield(
        address _tokenIn,
        address _tokenOut,
        uint256 amount,
        uint24 _secondsAgo,
        uint24 _fee
    ) external view returns (uint256 yieldAmount) {
        uint256 initialTwap = getTwap(_tokenIn, _tokenOut, _secondsAgo, _fee);
        uint256 currentTwap = getTwap(_tokenIn, _tokenOut, 0, _fee);
        uint256 percentageChange = (currentTwap * 10000) / initialTwap;
        return (yieldAmount = (amount * percentageChange) / 10000);
    }
}
