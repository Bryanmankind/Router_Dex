// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract RouterDex is ERC20, Ownable {

    using SafeERC20 for IERC20;
    
   
    
    // @dev address of trading token;
    IERC20 public tradingToken;


    constructor (IERC20 _tradingToken) ERC20("ROUTE", "RIT") Ownable(msg.sender) {
        tradingToken = IERC20 (_tradingToken);
        
    }

    function dexBalance () public view returns (uint256) {
        return IERC20(tradingToken).balanceOf(address(this));
    }

    function addLiquidity (uint256 _amount) public payable returns (uint256) {
        uint256 _liquidity;
        uint256 _balanceInEth = balanceOf(address(this));
        uint256 tokenReserve = dexBalance();
        IERC20 _tradingToken = IERC20 (tradingToken);

        if (tokenReserve == 0) {
            _tradingToken.transferFrom(msg.sender, address(this), _amount);
            _liquidity = _balanceInEth;
            _mint(msg.sender, _amount);
        }else {
            uint256 reservedETH = _balanceInEth - msg.value;
            require(_amount >= (tokenReserve * msg.value)/ reservedETH, "less than tokens required");
            _tradingToken.transferFrom(msg.sender, address(this), _amount);

            unchecked {
                _liquidity = (totalSupply() * msg.value) / reservedETH;
            }

            _mint(msg.sender, _liquidity);
        }

        return _liquidity;
    }

    function removeLiquidity (uint256 _amount) public returns (uint256, uint256) {
        require(_amount != 0, "can't be a zero value");
        uint256 _reservedETH = address(this).balance;
        uint256 _totalSupply = totalSupply();
        
        uint256 ethAmount = (_reservedETH * _amount) / totalSupply(); 
        uint256 _tokenAmount = (dexBalance() * _amount) / _totalSupply;
        
        _burn(msg.sender, _amount);

        payable(msg.sender).transfer(ethAmount);
        IERC20(tradingToken).transfer(msg.sender, _tokenAmount);

        return (ethAmount, _tokenAmount);
    }

    function getAmountOfTokens (uint256 inputAmount, uint256 inputReserve, uint256 outputReserve) public pure returns(uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
        uint256 numerator = inputAmount * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmount;
        unchecked {
            return numerator / denominator; 
        }

    }

    function swapEthToToken () public payable  {
        uint256 _reserveToken = dexBalance();
        uint256 _tokensBought = getAmountOfTokens(msg.value, address(this).balance, _reserveToken);
        IERC20(tradingToken).transfer(msg.sender, _tokensBought);

    }

    function swapTokenToEth (uint256 _tokenSold) public {
        uint256 _reserveToken = dexBalance();
        uint256 _ethBought = getAmountOfTokens(_tokenSold, address(this).balance, _reserveToken);
        IERC20(tradingToken).transfer(msg.sender, _tokenSold);

        payable (msg.sender).transfer(_ethBought);
    }

}