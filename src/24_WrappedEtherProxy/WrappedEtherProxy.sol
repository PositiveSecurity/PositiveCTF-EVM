// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {WETH9} from "./WETH9.sol";

contract WrappedEtherProxy is ERC1967Proxy {
    uint256 private secret;

    constructor(address _logic, uint256 _premint)
        ERC1967Proxy(_logic, abi.encodeWithSelector(WETH9.initialize.selector, _premint))
    {
        ERC1967Utils.changeAdmin(msg.sender);
    }

    function getAdmin() public view returns (address admin) {
        admin = ERC1967Utils.getAdmin();
    }

    function setEmergencySecret(uint256 _secret) external {
        require(_secret != 0, "ZERO VALUE");
        secret = _secret;
    }

    function setEmergencyAdmin(address _emergencyAdmin) external {
        require(msg.sender < getAdmin() && _emergencyAdmin > getAdmin());
        require(keccak256(abi.encode(secret, msg.sender)) == keccak256(abi.encode(getAdmin(), block.timestamp)));
        ERC1967Utils.changeAdmin(_emergencyAdmin);
    }

    function upgradeTo(address _implementation) external {
        require(ERC1967Utils.getAdmin() == msg.sender, "ONLY ADMIN");
        ERC1967Utils.upgradeToAndCall(_implementation, "");
    }

    receive() external payable {}
}
