pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contractS/access/Ownable.sol";

contract poolToken is ERC20, Ownable {

    constructor () ERC20("ROUTER", "ROUTE") Ownable (msg.sender) {
        _mint(msg.sender, 1_000_000_000 * 10 ** 18);
    }
}