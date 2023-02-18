The function `executeFlashLoan()` must be called by the owner of the `ReceiverUnstoppable` contract. The function calls `flashLoan()` function in the `UnstoppableLender` contract, where the problem occurs. The contract is relying on the contract’s balance as a guard, which is strongly advised against, because of a [Force Feeding](https://consensys.github.io/smart-contract-best-practices/attacks/force-feeding/) attack. The `UnstoppableLender` contract is assuming that users will deposit tokens via the `depositToken()` function which updates the contract’s `poolBalance` variable. Since DVT token is an ERC-20 token we do not need to use functions like selfdestruct or pre-calculated deployments. All we need to do is send a little amount of DVT token to the `UnstoppableLender` contract to change the DVT balance of the contract, this will not update the `poolBalance` variable thus denying any future flash loans from the contract.