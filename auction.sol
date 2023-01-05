// SPDX-License-Identifier: GPL-3.0
//Author RG
//Simple auction implemented using solidity
 pragma solidity 0.8.17;

 contract SimpleAuction {

    uint auctionEnd;

	//Address of highest bidder
    address public highestBidder;

	//Value of highest bid
    uint public highestBid;

    //benficiary address, who will get all the bids collected
    address public beneficiary;

    //Allowed withdrawls of previous bids 
    mapping (address => uint) pendingReturns;

    bool ended;

    event HighestBidIncreased(address bidder, uint amount);

    event AuctionEnded(address winner, uint amount);

	//Initalize the bidding time and beneficiary 
    constructor (uint biddingTime, address _beneficiary) {
        auctionEnd = block.timestamp + biddingTime;
        beneficiary = _beneficiary;
    }

    function bid() public payable {

        require (msg.value > highestBid);

        if (highestBid !=0) {
            pendingReturns[highestBidder] = pendingReturns[highestBidder] + highestBid;
         }

         highestBidder = msg.sender;

         highestBid = msg.value;

         emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public payable returns (bool) {

        uint amount = pendingReturns[msg.sender];

        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
				
                   pendingReturns[msg.sender] = amount;
                   return false; 
            }
        }

        return true;
    }

    function getFunds() view public returns(uint) {
        return address(this).balance;
    }

    function endAuction() public {

        require(!ended);

        ended = true;

        emit AuctionEnded(highestBidder, highestBid);
		
		//Transaction has to be payable to ensure that the ether are actually getting transferred.
		//Sending only the winning bid to the beneficiary 
		//if (!payable(beneficiary).send(highestBid))
		
		//Task is to send all the money to beneficiary, ideally bids shold be reverted to all bidders except winning bid
        if (!payable(beneficiary).send(address(this).balance)) {
			//fallback or error handling code block
        }
    }


 }