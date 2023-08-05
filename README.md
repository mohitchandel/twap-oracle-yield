# TWAPYield Smart Contract

This is a smart contract that provides functionalities for calculating the time-weighted average price (TWAP) and yield amount based on the percentage change in the TWAP for a given token pair on Uniswap V3.

## Requirements

- Solidity Compiler Version: 0.7.6
- Uniswap V3 Core: [IUniswapV3Pool.sol](https://github.com/Uniswap/uniswap-v3-core/blob/main/contracts/interfaces/IUniswapV3Pool.sol)
- Uniswap V3 Periphery: [OracleLibrary.sol](https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/OracleLibrary.sol) and [PoolAddress.sol](https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/PoolAddress.sol)
- Uniswap V3 Factory: [IUniswapV3Factory.sol](https://github.com/Uniswap/uniswap-v3-core/blob/main/contracts/interfaces/IUniswapV3Factory.sol)

## Functions

### `isPairSupported(address _tokenA, address _tokenB, uint24 _fee) internal pure returns (bool)`

Check if the provided token pair is supported in the Uniswap V3 factory with the given fee tier.

- `_tokenA`: The address of the first token of the pair.
- `_tokenB`: The address of the second token of the pair.
- `_fee`: The fee tier of the pool.

Returns `true` if the pair is supported; otherwise, returns `false`.

### `getTwap(address _tokenIn, address _tokenOut, uint32 _secondsAgo, uint24 _fee) internal view returns (uint256)`

Get the time-weighted average price for the given token pair with the given fee tier.

- `_tokenIn`: The address of the first token of the pair.
- `_tokenOut`: The address of the second token of the pair.
- `_secondsAgo`: The amount of time to look back for the TWAP, in seconds.
- `_fee`: The fee tier of the pool.

Returns the time-weighted average price as a `uint256`.

### `calculateYield(address _tokenIn, address _tokenOut, uint256 amount, uint24 _secondsAgo, uint24 _fee) external view returns (uint256 yieldAmount)`

Calculates the yield amount based on the percentage change in the time-weighted average price.

- `_tokenIn`: The address of the first token of the pair.
- `_tokenOut`: The address of the second token of the pair.
- `amount`: The amount of tokens to calculate the yield for.
- `_secondsAgo`: The amount of time to look back for the initial TWAP, in seconds.
- `_fee`: The fee tier of the pool.

Returns the calculated yield amount as a `uint256`.

## Usage

1. Deploy the smart contract on the Ethereum network.

2. Use the `calculateYield` function to calculate the yield amount based on the percentage change in the TWAP for a given token pair.

**Note**: Make sure to import the required Uniswap V3 interfaces and libraries before deploying the smart contract.
