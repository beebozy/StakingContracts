Overview 1
StakeEther is a Solidity-based smart contract that allows users to stake Ether and earn rewards over time. The reward is calculated based on the amount of Ether staked and the duration for which it has been staked. This contract offers a simple structure for staking and reward payout with the added benefit of ensuring secure transactions using error handling.

Key Features
Ether Staking: Users can deposit Ether into the contract and have their balance tracked.
Reward Calculation: Rewards are calculated based on the amount staked and the time the Ether has been held in the contract.
Secure Transactions: The contract includes checks and error handling to ensure secure Ether transfers.
Transparent Ownership: The contract's owner can be identified, and a reward rate is set upon contract deployment.
Contract Balance Query: Users can check the total balance of the contract at any time.

StakeERC - A Simple Staking Contract
Overview
StakeERC is an Ethereum-based staking smart contract built on top of an ERC20 token. It allows users to deposit a specified ERC20 token and earn rewards based on their staking duration. The contract is written in Solidity and uses OpenZeppelin libraries for secure token handling.

Key Features
Staking Mechanism: Users can deposit an ERC20 token and have it tracked by the contract.
Reward Calculation: The reward is based on the staked amount and the duration for which the tokens are held. The contract uses a fixed annual reward rate of 5%.
Safe Token Transfers: The contract leverages OpenZeppelin's SafeERC20 library to ensure secure token transfers.
Track Time: The contract keeps track of staking time for each user, which is used to calculate rewards.
Reward Payment: The contract pays out rewards in the form of the staked ERC20 tokens, based on the staking duration.
