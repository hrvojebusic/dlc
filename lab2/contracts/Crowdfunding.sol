pragma solidity ^0.4.24;

import "./Timer.sol";

/// This contract represents the most simple crowdfunding campaign.
/// This contract does not protect investors from not receiving goods
/// they were promised from the crowdfunding owner. This kind of contract
/// might be suitable for campaigns that do not promise anything to the
/// investors except that they will start working on the project.
/// (e.g. almost all blockchain spinoffs.)
contract Crowdfunding {

    address private owner;
    Timer private timer;
    uint256 public goal;
    uint256 public endTimestamp;
    uint256 private funds;
    mapping (address => uint256) public investments;

    constructor(
        address _owner,
        Timer _timer,
        uint256 _goal,
        uint256 _endTimestamp
    ) public {
        owner = _owner == 0 ? msg.sender : _owner;
        timer = _timer;
        goal = _goal;
        endTimestamp = _endTimestamp;
        funds = 0;
    }    

    function invest() public payable {
        // TODO Your code here
        require(timer.getTime() < endTimestamp, "Funding period has ended");
        require(funds < goal, "Goal already reached");
        require(msg.value!=0, "Message has no value");
        investments[msg.sender] += msg.value;
        funds += msg.value;
    }

    function claimFunds() public {
        // TODO Your code here
        require(timer.getTime() >= endTimestamp, "Funding period has not ended");
        require(funds >= goal, "Goal has not been reached");
        require(msg.sender == owner, "Only owner can claim funds");
        msg.sender.transfer(funds);
    }

    function refund() public {
        // TODO Your code here
        require(timer.getTime() >= endTimestamp, "Funding period has not ended");
        require(funds < goal, "Goal has been reached");
        require(investments[msg.sender] != 0, "Nothing to claim");
        uint value = investments[msg.sender];
        investments[msg.sender] = 0;
        msg.sender.transfer(value);
    }
}