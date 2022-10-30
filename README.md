<img align="right" width="150" height="150" top="100" src="./assets/sqrt.svg">

# Optimizor Club SQRT challenge

This repo contains my solution to the [Optimizor Club SQRT challenge](https://optimizor.club/).

> In the SQRT problem your contract is given an array of Fixed18 numbers, and it
> must return the square root of each number with an error margin of 10^-5.
> The challenge contract can be found at
> [0x2747096ff9e0fce877cd168dcd5de16040a4ab85](https://etherscan.io/address/0x2747096ff9e0fce877cd168dcd5de16040a4ab85#code#F3#L1).
>
> The interface that your solution contract must adhere to is below. The `sqrt` function will be called by the challenge
> contract when you call its `challenge` function.
>
> ```solidity
> interface ISqrt {
>    function sqrt(Fixed18[INPUT_SIZE] calldata) external view returns (Fixed18[INPUT_SIZE] memory);
> }
> ```

## Test

This solution is written in [Huff](https://github.com/huff-language), so you will need
[huffc](https://huff.sh) installed to compile it.

> **Note**
> In order to use the huff compiler within foundry tests / scripts, FFI must be enabled. If you'd like to
> read into what this repo uses FFI for before running anything, see [foundry-huff](https://github.com/huff-language/foundry-huff)
> and [huff-rs](https://github.com/huff-language/huff-rs).

To test locally:

```bash
$ forge test
```
