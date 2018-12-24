pragma solidity ^0.4.24;

import "./Auction.sol";

contract EnglishAuction is Auction {

    uint internal highestBid;
    uint internal initialPrice;
    uint internal biddingPeriod;
    uint internal lastBidTimestamp;
    uint internal minimumPriceIncrement;

    address internal highestBidder;

    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer,
        uint _initialPrice,
        uint _biddingPeriod,
        uint _minimumPriceIncrement
    ) public Auction(_sellerAddress, _judgeAddress, _timer) {
        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        lastBidTimestamp = time();
        minimumPriceIncrement = _minimumPriceIncrement;
    }

    function bid() public payable {
        // TODO Your code here
        uint timestamp = time();

        require(outcome == Outcome.NOT_FINISHED, "Auction is not active");
        require(timestamp < lastBidTimestamp + biddingPeriod, "Bidding time ran out");
        require(msg.value >= initialPrice, "Bidding price needs to meet or exceed initial price");
        require(msg.value >= highestBid + minimumPriceIncrement, "Minimum price increment not met");

        if(highestBidder != address(0)) {
            highestBidder.transfer(highestBid);
        }
        
        require(address(this).balance == msg.value, "Funds not in escrow");

        highestBid = msg.value;
        highestBidder = msg.sender;
        lastBidTimestamp = timestamp;
    } 

    /// Function that returns highest bidder address or address(0) if
    /// auction is not yet over.
    function getHighestBidder() public returns (address) {
        if(time() >= lastBidTimestamp + biddingPeriod) {
            if(highestBidder != address(0)) {
                finishAuction(Outcome.SUCCESSFUL, highestBidder);
            } else {
                finishAuction(Outcome.NOT_SUCCESSFUL, address(0));
            }
        }

        return highestBidderAddress;
    }
}

