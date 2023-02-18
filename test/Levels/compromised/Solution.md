Use [this](http://www.unit-conversion.info/texttools/hexadecimal/) tool to convert hex data to text

`1. hex: 4d 48 68 6a 4e 6a 63 34 5a 57 59 78 59 57 45 30 4e 54 5a 6b 59 54 59 31 59 7a 5a 6d 59 7a 55 34 4e 6a 46 6b 4e 44 51 34 4f 54 4a 6a 5a 47 5a 68 59 7a 42 6a 4e 6d 4d 34 59 7a 49 31 4e 6a 42 69 5a 6a 42 6a 4f 57 5a 69 59 32 52 68 5a 54 4a 6d 4e 44 63 7a 4e 57 45 35`

`2. hex: 4d 48 67 79 4d 44 67 79 4e 44 4a 6a 4e 44 42 68 59 32 52 6d 59 54 6c 6c 5a 44 67 34 4f 57 55 32 4f 44 56 6a 4d 6a 4d 31 4e 44 64 68 59 32 4a 6c 5a 44 6c 69 5a 57 5a 6a 4e 6a 41 7a 4e 7a 46 6c 4f 54 67 33 4e 57 5a 69 59 32 51 33 4d 7a 59 7a 4e 44 42 69 59 6a 51 34`

`1. text(Base64): MHhjNjc4ZWYxYWE0NTZkYTY1YzZmYzU4NjFkNDQ4OTJjZGZhYzBjNmM4YzI1NjBiZjBjOWZiY2RhZTJmNDczNWE5`

`2. text (Base64): MHgyMDgyNDJjNDBhY2RmYTllZDg4OWU2ODVjMjM1NDdhY2JlZDliZWZjNjAzNzFlOTg3NWZiY2Q3MzYzNDBiYjQ4`

To get the private key from text use this [tool](https://www.base64decode.org)

`1. private key: 0xc678ef1aa456da65c6fc5861d44892cdfac0c6c8c2560bf0c9fbcdae2f4735a9`

`2. private key: 0x208242c40acdfa9ed889e685c23547acbed9befc60371e9875fbcd736340bb48`

To get the public key from private key we can use [eth-toolbox](https://eth-toolbox.com)

`1. ETH address: 0xe92401a4d3af5e446d93d11eec806b1462b39d15`

`2. ETH address: 0x81a5d6e50c214044be44ca0cb057fe119097850c`

We can see that the ETH addresses belong to the two out of three price on-chain oracles, which means we can manipulate the price by changing what each oracle reports as the current price, with `postPrice()`.
