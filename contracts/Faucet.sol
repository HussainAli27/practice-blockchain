// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Faucet {
    // Allows users to withdraw a limited amount
    function withdraw(uint256 withdraw_amount) public {
        require(withdraw_amount <= 1 ether, "Exceeds maximum withdrawal limit");
        require(address(this).balance >= withdraw_amount, "Insufficient balance in faucet");

        payable(msg.sender).transfer(withdraw_amount); // Fix: Convert to payable
    }

    // Fallback function to accept Ether deposits
    receive() external payable {}
}
