// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import { ISqrt } from "src/SqrtChallenge.sol";
import { IOptimizor, OPTIMIZOR_MAINNET } from "src/IOptimizor.sol";
import { computeKey } from "src/CommitHash.sol";

// Change accordingly.
uint256 constant SQRT_ID = 1;
// Change accordingly.
address constant SUBMITTER = address(0xfd8e46f80ec8A2f05732B58744921Fa8234c4A6b);
// Change accordingly.
address constant RECEIVER = address(0x7b36949624eFeA27dD9F0925b25c309A09774784);
// Change accordingly.
uint256 constant SALT = 0;
// Deploy solution contract.
address constant DEPLOYED_SOLUTION = address(0xfa873c8438C98849883e5bfd667Fc32E9133058C);

contract MySolutionDeployAndCommit is Script {
    function run() public {
        vm.startBroadcast();

        // Compile Solution contract
        string[] memory cmds = new string[](3);
        cmds[0] = "huffc";
        cmds[1] = string("src/Solution.huff");
        cmds[2] = "-b";
        bytes memory code = vm.ffi(cmds);

        // Deploy solution contract.
        address sqrt;
        assembly {
            sqrt := create(0, add(code, 0x20), code)
        }

        // Commit solution key.
        OPTIMIZOR_MAINNET.commit(computeKey(SUBMITTER, address(sqrt).codehash, SALT));

        // vm.roll(block.number + 65);
        //
        // OPTIMIZOR_MAINNET.challenge(SQRT_ID, address(sqrt), RECEIVER, SALT);

        vm.stopBroadcast();
    }
}

contract MySolutionChallenge is Script {
    function run() public {
        vm.broadcast();

        // Submit the challenge solution.
        OPTIMIZOR_MAINNET.challenge(SQRT_ID, address(DEPLOYED_SOLUTION), RECEIVER, SALT);
    }
}
