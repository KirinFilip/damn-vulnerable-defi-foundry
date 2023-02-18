The `TrusterLenderPool` contact has only one function called `flashLoan()`. Immediately the function arguments `address target` and `bytes calldata data` seem suspicious. The function checks that the pool has enough tokens to borrow from, transfers the amount to the borrower address and then calls a function given by the caller with `target.functionCall(data)`, `functionCall()` only checks that the called target is a contract. There are a few problems with the `flashLoan()` function. Firstly, it does not have any checks for `borrowAmount`, like is it `0` or not, next it does not check the `address borrower` argument nor the `address target`. Secondly, it lets users specify what contract and what function to externally call which is never good. To exploit this contact we can create a new contract or just call all the functions one by one. I have created a new contract called `TrusterAttack` that executes all functions at once with the `attack()` function. The `attack()` function takes as its arguments the `TrusterLenderPool` address and the `token` address. First the function creates a bytes data variable that uses `abi.encodeWithSignature()` function to allow us to call approve on this contract with the maximum amount allowed for uint256 to approve. Then the function calls the `flashLoan()` function from the pool with `0` amount to borrow, `msg.sender` as the borrower, the tokens contract as the target and our custom data as the data. This approves our contract to use `transferFrom()` and transfer all of the funds from the `TrusterLenderPool` to the `attacker`.