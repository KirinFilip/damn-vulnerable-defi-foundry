There are 4 contracts, `TheRewarderPool`, `RewardToken`, `AccountingToken` and `FlashLoanerPool`. `TheRewaredPool` gives out `RewardTokens` depending on the amount of DVT tokens deposited and tracks of them via the `AccountingToken`. `FlashLoanerPool` gives flash loans for DVT tokens. `TheRewarderPool` pays out rewards every 5 days based on a snapshot token balance. As a general rule, if some logic relies on a single snapshot in time instead of continuous/aggregated data points, it can be manipulated by flash loans. We can wait 5 days when the rewards are being distributed again, take a huge flash loan and deposit all tokens from the flash loan to the reward pool. The `deposit` function of the `RewarderPool` takes a new snapshot of the current token balances and distributes the rewards if the 5 day period has passed. When we deposit a huge amount of tokens our share of the overall tokens in the reward pool will be huge, and the integer division in the `rewards = (amountDeposited _ 100 _ 10 \*\* 18) / totalDeposits;` will result in all other accounts receiving 0 reward tokens.