This challenge is basically the same as Puppet only this time we are using UniswapV2. Again the problem arises with the `_getOracleQuote` function. This time we use official UniswapV2 functions, however the `quote()` function in `_getOracleQuote` does the same thing as the `_computeOraclePrice()` in the previous challenge.