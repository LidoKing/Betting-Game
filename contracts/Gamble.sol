pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Gamble is VRFConsumerBase {

    bytes32 public reqId;
    uint256 public randomNumber;
    bytes32 internal keyHash;
    uint256 internal fee;

    address constant VFRC_address = 0xf720CF1B963e0e7bE9F58fd471EFa67e7bF00cfb; // VRF Coordinator
    address constant LINK_address = 0x20fE562d797A42Dcb3399062AE9546cd06f63280; // LINK token

    constructor() VRFConsumerBase(VFRC_address, LINK_address) public {
        fee = 0.1 * 10 ** 18; // 0.1 LINK
        keyHash = 0xced103054e349b8dfb51352f0f8fa9b5d20dde3d06f9f43cb2b85bc64b238205;
    }

    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        reqId = requestId;
        randomNumber = randomness;
    }
}
