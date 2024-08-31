
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract StakeEther {

    address public owner;
    uint public rate;

    struct Staking {
        address person;
        uint amount;
        uint time;
    }

    Staking[] public stakes;
    
    mapping(address => uint) public balances;
    mapping(address => uint) public timeTrack;

    event Deposited(address indexed user, uint amount, uint time);
    event RewardPaid(address indexed user, uint reward);

    error ZeroAddress();
    error FailedTransfer();

    constructor(uint _rate) payable {
        owner = msg.sender;
        rate = _rate;
    }

    function deposit() external payable {
        if (msg.sender == address(0)) revert ZeroAddress();
        assert(msg.value > 0);

        balances[msg.sender] += msg.value;
        timeTrack[msg.sender] = block.timestamp;

        Staking memory newStake = Staking({
            person: msg.sender,
            amount: msg.value,
            time: block.timestamp
        });

        stakes.push(newStake);

        emit Deposited(msg.sender, msg.value, block.timestamp);
    }

    function calculateReward(address recipient) internal view returns (uint) {
        uint amountAccrued = balances[recipient] * rate * (block.timestamp - timeTrack[recipient])/100;
        uint reward = amountAccrued - balances[recipient];
        return reward;
    }

    function contractBalance()external view returns (uint){

        return address(this).balance;

    }

    function payReward(address recipient) external payable  {
        uint reward = calculateReward(recipient);
        
        (bool success, ) = payable(recipient).call{value: reward}("");
        if (!success) revert FailedTransfer();

        emit RewardPaid(recipient, reward);
    }
}


