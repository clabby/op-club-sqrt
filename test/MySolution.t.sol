// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { ISqrt, SqrtChallenge, INPUT_SIZE } from "src/SqrtChallenge.sol";
import { Fixed18 } from "src/Fixed18.sol";
import { IOptimizor, OPTIMIZOR_MAINNET } from "src/IOptimizor.sol";
import { computeKey } from "src/CommitHash.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";

contract MySolutionTest is Test {
    uint256 constant SQRT_ID = 1;
    SqrtChallenge challenge;
    ISqrt sqrt;

    // Change accordingly.
    uint256 constant currentLeaderGas = 1000000;
    // Change accordingly.
    uint256 constant SEED = 0;
    // Change accordingly.
    uint256 constant SALT = 0;
    // Change accordingly.
    address constant MY_ADDRESS = address(0xcafe);

    function setUp() public {
        // Fork mainnet
        vm.createSelectFork(vm.rpcUrl("flashbots"));

        // Deploy our solution & a mock challenge
        sqrt = ISqrt(HuffDeployer.config().deploy("Solution"));
        challenge = new SqrtChallenge();
    }

    function testSpecificSeed() public {
        testWithSeed(SEED);
    }

    function testFuzzSeed(uint256 seed) public {
        testWithSeed(seed);
    }

    function testEndToEnd() public {
        // Commit our solution
        OPTIMIZOR_MAINNET.commit(computeKey(MY_ADDRESS, address(sqrt).codehash, SALT));

        // Fast forward 65 blocks
        vm.roll(block.number + 65);

        // Call the challenge contract's `challenge` func as `MY_ADDRESS`
        vm.prank(MY_ADDRESS);
        OPTIMIZOR_MAINNET.challenge(SQRT_ID, address(sqrt), MY_ADDRESS, SALT);
    }

    function testWithSeed(uint256 seed) internal {
        Fixed18[INPUT_SIZE] memory input;
        for (uint256 i = 0; i < INPUT_SIZE; ++i) {
            input[i] = Fixed18.wrap(i);
        }

        uint256 gasSpent = challenge.run(address(sqrt), seed);
        assertTrue(gasSpent < currentLeaderGas);
    }
}
