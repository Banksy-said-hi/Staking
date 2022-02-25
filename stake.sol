pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

// Deploy this contract first (1)
contract Staking_Contract is ERC20("Second Token", "$xDbar") {
    
    Faucet public token;
    uint public vault;
    
    function getBalance(address _source) public {
        token = Faucet(_source);
        vault = token.balanceOf(address(this));
    }

    function stake() public payable {}
}


// Deploy this contract second (2)
contract Reward_Contract {

    Faucet public token;
    uint public vault;

    function getBalance(address _source) public {
        token = Faucet(_source);
        vault = token.balanceOf(address(this));
    }

    function deplete(address _receiver) public {
        token.approve(_receiver, vault);
        token.transfer(_receiver, vault);
    }
}

// Deploy this contract third (3)
contract Faucet is ERC20("First Token", "$dbar") {
    
    address public owner;

    constructor(address _destination) {
        owner = msg.sender;
        _mint(_destination, 1000);
    }

    function mint(uint _quantity) public {
        _mint(msg.sender, _quantity);
    }
}


