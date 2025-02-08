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

contract Democracy is Destructable{
    struct Candidate {
        string name;
        address candidateAddress;
        uint256 votes;
    }

    mapping(address => bool) public hasRegistered; // Track unique addresses
    mapping(string => bool) public isNameTaken; // Track unique names
    mapping(address => Candidate) public candidates; // Store candidate details

    event CandidateRegistered(string name, address candidateAddress);

    function registerAsCandidate(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(!hasRegistered[msg.sender], "Address already registered");
        require(!isNameTaken[_name], "Name already taken");

        // Register candidate
        candidates[msg.sender] = Candidate(_name, msg.sender, 0);
        hasRegistered[msg.sender] = true;
        isNameTaken[_name] = true;

        emit CandidateRegistered(_name, msg.sender);
    }
}