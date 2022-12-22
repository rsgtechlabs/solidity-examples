// SPDX-License-Identifier: MIT
//Author - RSG
//Coding Assignment - 1
//Solidity Programming - Voter Application
pragma solidity ^0.4.10;

contract Voting {
  
   //Owner of the contract, address which deploys the contract
   address owner;
   
   //Contract level variables to capture the state of the contract
   uint numCandidates;
   uint numVoters;
   uint numOfVotes;
   
   
   //Complex Data Type
   //Contract level object to store Voter information
   struct Voter {
       uint candidateIdVote;
       bool hasVoted;
       bool isAuthorized;
   }

   //Complex Data Type
   //Contract level object to store Candidate information
   struct Candidate {
       string name;
       string party;
       uint noOfVotes;
       bool doesExist;
   }
   
   //Stores List of candidates & voters 
   //Could have used array as well here
   mapping (uint => Candidate) candidates;
   mapping (address => Voter) voters;
   
   //Constructor to initialize owner as the address which creates the contract
   constructor () public {
       owner = msg.sender;
   }

   //Pre execution Function/Validation Check - executes before the actual function call
   //This is usually added to other function definition as prerequisite 
   modifier onlyOwner() {
       require(msg.sender == owner);
       _;   //This step will ensure that next function call happens
   }

   
   //Add Candidate
   //OnlyOwner of the contract can add candidates
   function addCandidate(string memory name, string memory party) onlyOwner public {
   
      uint candidateId = numCandidates++;
	  candidates[candidateId] = Candidate(name, party, 0, true);  
   }
   
   //Vote for candidate
   //Anyone can vote as long as they are authorized & have not voted earlier
   function vote(uint candidateId) public {
   
		require (!voters[msg.sender].hasVoted);   //Check if candidate has voted earlier

        require (voters[msg.sender].isAuthorized);  //Check if the voter is authorized
		
		if (candidates[candidateId].doesExist == true) {
		
			voters[msg.sender] = Voter(candidateId, true, true);
			candidates[candidateId].noOfVotes++;
			numOfVotes++;
			numVoters++;
		}
		  
   }
   
   
   function totalVotes(uint candidateId) view public returns (uint) {
			
			return candidates[candidateId].noOfVotes;
   }
   
   
   function getNumOfCandidates() public view returns (uint) {
   
		return numCandidates;
   }
   
   function getNumOfVoters() public view returns (uint) {
   
		return numVoters;
   }
   
   function getCandidate(uint candidateId) public view returns (uint, string memory, string memory, uint) {
   
		return (candidateId, candidates[candidateId].name, candidates[candidateId].party, candidates[candidateId].noOfVotes);
   }
   
   //Returns the owner and Sender address
   //Used only for debugging
   function getOwnerAndSender() public view returns (address, address) {
	  return (owner, msg.sender);
   }
   
   

	//Function to auhorize voters
	//Only owner of the contract can authorize other voters
   function authorize(address voterId) public onlyOwner {
   
	   //Authorize a particular address, enables them to vote
       voters[voterId].isAuthorized = true;
   }

}