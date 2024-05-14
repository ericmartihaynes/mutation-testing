// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Bank {
    mapping(address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;

        (bool sent,) = payable(msg.sender).call{value: _amount}("");
        require(sent, "Can't withdraw Ether");
    }

    function getBalance(address _address) external view returns (uint256) {
        return balances[_address];
    }
}
