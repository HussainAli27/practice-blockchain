// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Destructable {
    address private owner;
    bool public isDestroyed = false;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier isNotDestroyed {
        require(!isDestroyed, "Contract is already destroyed");
        _;
    }

    receive () external payable {
    }


    function destroy() public onlyOwner isNotDestroyed {
        // (bool success, ) = owner.call{value: address(this).balance}("");
        // require(success, "Transfer failed.");

        uint256 balance = address(this).balance;

        // Transfer all Ether to the owner
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Ether transfer to owner failed on selfdestruct.");

        // Mark contract as destroyed
        isDestroyed = true;
    }

    

}