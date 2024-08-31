
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract StakeERC is ERC20 {
    using SafeERC20 for IERC20;

    address public tokenAddress;
    address public owner;

    struct Staker {
        address user;
        uint amount;
        bool hasStaked;
        uint time;
    }

    Staker[] public stakes;

    event Stake(address indexed user, uint amount, uint time);

    mapping(address => uint) public balances;
    mapping(address => uint) public trackTime;

    constructor(address _tokenAddress) ERC20("STAKE", "STK") {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        _mint(owner, 1000 * 10 ** decimals());
    }

    function deposit(uint amount) external {
        require(msg.sender != address(0), "Address zero detected");
        require(amount > 0, "Deposit amount must be greater than zero");

        uint userBalance = IERC20(tokenAddress).balanceOf(msg.sender);
        require(userBalance >= amount, "Insufficient balance");

        // Transfer tokens from the user to this contract
        IERC20(tokenAddress).safeTransferFrom(msg.sender, address(this), amount);

        // Track the balance and staking details
        balances[msg.sender] += amount;
        trackTime[msg.sender] = block.timestamp;

        Staker memory newStake = Staker({
            user: msg.sender,
            amount: amount,
            hasStaked: true,
            time: block.timestamp
        });

        stakes.push(newStake);

        emit Stake(msg.sender, amount, block.timestamp);
    }

    function reward(address staker) public view returns (uint) {
        require(trackTime[staker] > 0, "No staking time recorded");

        uint stakingDuration = block.timestamp - trackTime[staker];
        require(stakingDuration > 0, "Staking duration too short");

        uint annualRewardRate = 5;
        uint rewardAmount = (balances[staker] * annualRewardRate * stakingDuration) / (365 days * 100);
        
        return rewardAmount;
    }

    function payRewardWithToken(address recipient) external {
        uint rewardAmount = reward(recipient);

        // Ensure the contract has enough tokens to pay the reward
        require(IERC20(tokenAddress).balanceOf(address(this)) >= rewardAmount, "Insufficient reward balance");

        // Transfer the reward to the recipient
        IERC20(tokenAddress).safeTransfer(recipient, rewardAmount);
    }

    function unstake(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient staked balance");

        // Calculate and pay reward before unstaking
      //  payRewardWithToken(msg.sender);

        // Update balance and transfer the staked tokens back to the user
        balances[msg.sender] -= amount;
        IERC20(tokenAddress).safeTransfer(msg.sender, amount);

        // If the user has no more balance staked, reset their tracking time
        if (balances[msg.sender] == 0) {
            trackTime[msg.sender] = 0;
        }
    }
}
