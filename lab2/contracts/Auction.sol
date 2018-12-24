pragma solidity ^0.4.24;

import "./Timer.sol";

/// This contract represents abstract auction.
contract Auction {

    /// Enum that shows the state of the auction.
    enum Outcome {
        NOT_FINISHED,
        NOT_SUCCESSFUL,
        SUCCESSFUL
    }

    /// Timer contract.
    Timer private timer;

    /// Address of a judge.
    address private judgeAddress;

    /// Address of seller.
    address private sellerAddress;

    /// Address of the highest bidder.
    /// This should be set when the auction is over.
    address internal highestBidderAddress;

    /// Indicates auction outcome.
    Outcome internal outcome;

    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer
    ) public {
        sellerAddress = _sellerAddress;
        judgeAddress = _judgeAddress;
        timer = _timer;
        if (sellerAddress == address(0)) {
            sellerAddress = msg.sender;
        }
        outcome = Outcome.NOT_FINISHED;
    }

    /// Internal function used to finish an auction.
    /// Auction can finish in three different scenarios:
    /// 1.) Somebody won the auction and seller has the rights to receive the
    ///     funds to this contract.
    /// 2.) Auction finished with a highest bidder, but for some reason the
    ///     highest bidder does not have the right to claim the auction item
    ///     (e.g. minimal item price is not reached).
    /// 3.) Not one bid has been placed for an item.
    ///
    /// The values that should be used with this function call for each of
    /// the cases are:
    /// 1.) In the case of the first outcome, contract should call this method with
    ///     _highestBidderAddress != address(0) and _outcome should be equal to
    ///     Auction.Outcome.SUCCESSFUL.
    /// 2.) In the case of the second outcome, contract should call this method
    ///     with _outcome == AuctionOutcome.NOT_SUCCESSFUL and arbitrary value
    ///     for the _highestBidderAddress parameter.
    /// 3.) In the third case when not a single bid was placed, then this function
    ///     should be called with _outcome == NOT_SUCCESSFUL and
    ///     _highestBidderAddress should be equal to address(0).
    ///
    /// @param _outcome Outcome of the auction.
    /// @param _highestBidder Address of the highest bidder or address(0) if auction did not finish successfully.
    function finishAuction(Outcome _outcome, address _highestBidder) internal {
        require(_outcome != Outcome.NOT_FINISHED, "Internal error: outcome should never be 'NOT_FINISHED'"); // This should not happen.
        outcome = _outcome;
        highestBidderAddress = _highestBidder;
    }

    /// Settles the auction and sends the funds to the auction seller.
    /// This function can only be called when the auction has finished successfully.
    /// If no judge is specified for an auction then anybody can request
    /// the transfer of funds to the seller. If the judge is specified,
    /// then only the judge or highest bidder can transfer the funds to the seller.
    function settle() public {
        // TODO Your code here
        require(outcome == Outcome.SUCCESSFUL, "Auction is not successful");
        // require(highestBidderAddress != address(0), "Highest bidder not present");
        if (judgeAddress != address(0)) {
            require((msg.sender == judgeAddress) || (msg.sender == highestBidderAddress), "Can only be invoked by judge or highest bidder");
        }
        finishAuction(Outcome.SUCCESSFUL, highestBidderAddress);
        sellerAddress.transfer(address(this).balance);
    }

    // Returns the money to the highest bidder only in the case of unsuccessful
    // auction outcome. If the judge is specified then only the judge or
    // the seller can return the money to the highest bidder. If no judge is
    // specified then anybody should be able to request the transfer of funds
    // to the highest bidder (if such exists).
    function refund() public {
        // TODO Your code here
        require(outcome == Outcome.NOT_SUCCESSFUL, "Auction is not unsuccessful");
        require(highestBidderAddress != address(0), "Highest bidder not present");
        if (judgeAddress != address(0)) {
            require((msg.sender == judgeAddress) || (msg.sender == sellerAddress), "Can only be invoked by judge or seller");
        }
        finishAuction(Outcome.NOT_SUCCESSFUL, highestBidderAddress);
        highestBidderAddress.transfer(address(this).balance);
    }

    // This is provided for testing
    // You should use this instead of block.number directly
    // You should not modify this function.
    function time() public view returns (uint) {
        return timer.getTime();
    }

    /// Function that returns highest bidder address or address(0) if
    /// auction is not yet over.
    function getHighestBidder() public returns (address) {
        return highestBidderAddress;
    }
}

