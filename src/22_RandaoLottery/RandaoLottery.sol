// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandaoLottery {
    struct Commitment {
        bytes32 hash;
        uint256 value;
    }

    address immutable owner;
    uint256 public revealDeadline;
    uint256 public randomResult;
    bool public lotteryEnded;

    mapping(address => Commitment) commitments;
    address[] public participants;

    event Commit(address indexed participant, bytes32 hash);
    event Reveal(address indexed participant, uint256 value);
    event Winner(address indexed winner, uint256 prize);

    constructor(uint256 _revealDeadline) payable {
        owner = msg.sender;
        revealDeadline = _revealDeadline;
        lotteryEnded = false;

        bytes32 hash = keccak256(abi.encodePacked(block.number));

        commit(hash);

        randomResult = uint160(uint256(hash));
    }

    function commit(bytes32 hash) public beforeDeadline {
        require(commitments[msg.sender].hash == 0, "Already committed");

        commitments[msg.sender] = Commitment({hash: hash, value: 0});
        participants.push(msg.sender);

        emit Commit(msg.sender, hash);
    }

    function reveal(uint256 value) external afterDeadline {
        require(!lotteryEnded, "Lottery already ended");

        Commitment storage commitment = commitments[msg.sender];
        require(commitment.hash != 0, "No commitment found");
        require(commitment.value == 0, "Already revealed");
        require(
            commitment.hash == keccak256(abi.encodePacked(value)),
            "Invalid value"
        );

        commitment.value = value;

        randomResult += value;

        emit Reveal(msg.sender, value);
    }

    function endLottery() external onlyOwner afterDeadline {
        require(!lotteryEnded, "Lottery already ended");

        lotteryEnded = true;
        uint256 winnerIndex = randomResult % block.number;
        address winner = participants[winnerIndex];
        uint256 prize = address(this).balance;

        payable(winner).transfer(prize);

        emit Winner(winner, prize);
    }

    function resetLottery(
        uint256 newRevealDeadline
    ) external onlyOwner afterDeadline {
        require(lotteryEnded, "Current lottery must be ended");

        unchecked {
            for (uint256 i = 0; i < participants.length; ++i) {
                delete commitments[participants[i]];
            }
            delete participants;
        }

        randomResult = 0;
        revealDeadline = newRevealDeadline;
        lotteryEnded = false;
    }

    modifier beforeDeadline() {
        block.timestamp <= revealDeadline;
        _;
    }

    modifier afterDeadline() {
        block.timestamp > revealDeadline;
        _;
    }

    modifier onlyOwner() {
        msg.sender == owner;
        _;
    }

    function updateDeadline(
        uint256 newRevealDeadline
    ) external onlyOwner beforeDeadline {
        require(
            newRevealDeadline > block.timestamp,
            "New deadline must be in the future"
        );
        revealDeadline = newRevealDeadline;
    }
}
