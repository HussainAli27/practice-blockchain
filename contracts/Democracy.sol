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


interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Democracy is Destructable {
    IERC20 public usdt;
    
    struct Candidate {
        string name;
        address candidateAddress;
        uint256 votes;
        uint256 fundsReceived;
    }

    mapping(address => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    Candidate[] public candidateList;

    event CandidateRegistered(string name, address candidateAddress);
    event Voted(address voter, address candidate);
    event Funded(address funder, address candidate, uint256 amount);

    constructor(address _usdtAddress) {
        usdt = IERC20(_usdtAddress); // USDT contract address
    }

    function registerAsCandidate(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(candidates[msg.sender].candidateAddress == address(0), "Already registered");

        Candidate memory newCandidate = Candidate(_name, msg.sender, 0, 0);
        candidates[msg.sender] = newCandidate;
        candidateList.push(newCandidate);

        emit CandidateRegistered(_name, msg.sender);
    }

    function vote(address _candidateAddress) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidates[_candidateAddress].candidateAddress != address(0), "Candidate does not exist");

        // Increase vote count
        candidates[_candidateAddress].votes += 1;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, _candidateAddress);
    }

    function fundCandidate(address _candidateAddress, uint256 _amount) public {
        require(candidates[_candidateAddress].candidateAddress != address(0), "Candidate does not exist");

        // Transfer USDT from sender to candidate
        require(usdt.transfer(_candidateAddress, _amount), "USDT transfer failed");

        // Track funds received
        candidates[_candidateAddress].fundsReceived += _amount;

        emit Funded(msg.sender, _candidateAddress, _amount);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidateList;
    }
}

