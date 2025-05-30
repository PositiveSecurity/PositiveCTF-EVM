# PositiveCTF

A set of tasks for cracking implementations of smart-contracts with typical vulnerabilities.

## Play

Visit [positive.com](https://www.positive.com/ctf)

OR

Clone the repository and solve locally, a separate test is made for each problem

```sh
git clone https://github.com/PositiveSecurity/PositiveCTF-EVM.git

cd PositiveCTF-EVM

forge install
```

## Important

- In some cases it may be necessary to write part of the exploit in the `setUp()` function, due to the peculiarities of processing the `SELFDESTRUCT` command in Foundry
- Some tasks require fork testing (`--fork-url`)
- There are two roles in `BaseTest.t.sol`, sometimes it is required to send transactions from `player`, you cannot send transactions from `owner`
- It is possible to manipulate the time of the blockchain within reasonable limits

## Disclaimer

All Solidity code, practices and patterns in this repository are for educational purposes only.

DO NOT USE IN PRODUCTION.
