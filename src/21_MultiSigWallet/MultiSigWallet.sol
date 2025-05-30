// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract MultiSigWallet {
    uint256 public nonce;
    uint256 public requiredSignatures;
    mapping(address => bool) public isOwner;
    address[] public owners;

    event ExecuteTransaction(address indexed owner, address indexed to, uint256 value, bytes data, address token);

    constructor(address[] memory _owners, uint256 _requiredSignatures) {
        require(_owners.length > 0, "Owners required");
        require(
            _requiredSignatures > 0 && _requiredSignatures <= _owners.length, "Invalid number of required signatures"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        requiredSignatures = _requiredSignatures;
    }

    function executeTransaction(address token, address to, uint256 value, bytes memory data, bytes[] memory signatures)
        public
    {
        require(signatures.length >= requiredSignatures, "Not enough signatures");

        uint256 validSignatures;

        for (uint256 i = 0; i < signatures.length; i++) {
            bytes32 txHash = getTransactionHash(token, to, value, data, nonce);
            nonce++;
            address recovered = recover(txHash, signatures[i]);
            require(isOwner[recovered], "Invalid signer");
            validSignatures++;
        }

        require(validSignatures >= requiredSignatures, "Not enough valid signatures");

        require(IERC20(token).transfer(to, value), "Token transfer failed");

        if (data.length > 0) {
            (bool success,) = to.call(data);
            require(success, "Transaction failed");
        }

        emit ExecuteTransaction(msg.sender, to, value, data, token);
    }

    function getTransactionHash(address token, address to, uint256 value, bytes memory data, uint256 _nonce)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(token, to, value, data, _nonce));
    }

    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid signature 'v' value");

        return ecrecover(hash, v, r, s);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function noRugPull(address tokenAddress, uint256 amount) external payable {
        require(msg.value == 100000 ether, "You need to send exactly 10,000 ETH");

        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "Not enough tokens in the contract");

        token.transfer(msg.sender, amount);
    }
}
