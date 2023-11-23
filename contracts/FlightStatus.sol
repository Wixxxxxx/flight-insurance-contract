// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract FlightStatus is ChainlinkClient{

    using Chainlink for Chainlink.Request;

    bytes32 private jobId;
    uint256 private fee;

    event FlightDataReceived(uint256 status);

    constructor() {

        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789); 
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD); 
        jobId = "7d80a6386ef543a3abb52817f6707e3b";
        fee = (1 * LINK_DIVISIBILITY) / 10;

    }

    function requestFlightData(string memory flightNumber, string memory flightStatus) public {
        
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.parseFlightData.selector);

        string memory endpoint =  "http://api.aviationstack.com/v1/flights?access_key=de5902ad5ca34c07554ae378a2fac5d0";
        
        req.add("get", endpoint);

        req.add("path", "RAW,ETH,USD,VOLUME24HOUR");

        sendChainlinkRequest(req, fee);
    }

    function parseFlightData(bytes32 _requestId, uint256 _statusCode) public recordChainlinkFulfillment(_requestId) {
        
        }
}

