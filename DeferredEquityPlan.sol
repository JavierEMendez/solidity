pragma solidity ^0.5.0;

contract DeferredEquityPlan {
    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    uint total_shares = 1000;
    uint annual_distribution = 250; // 250 per year

    uint start_time = now; // start now
    uint unlock_time = now + 365 days; // unlocks every year

    uint public distributed_shares;

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        require(unlock_time <= now);
        require(distributed_shares < total_shares);

        // Make sure to include the parenthesis around (now - start_time) to get accurate results!
        unlock_time += 365 days; 
        distributed_shares = (now - start_time) / 365 days * annual_distribution; 

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

    // deactivation
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}