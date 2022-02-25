pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


// Deploy this contract third 
// (3)
contract Staking_Contract is ERC20("Second Token", "$xDbar") {
    
    Faucet public token_$dbar;
    uint public vault_$dbar;
    
    constructor(address _faucet) {
        token_$dbar = Faucet(_faucet);
    }

    function updateBalance0() public {
        vault_$dbar = token_$dbar.balanceOf(address(this));
    }

    

    // ## ATTENTION ##
    // before executing this function, user has to approve 
    // this contract within the $dbar contract (faucet contract)
    function deposit() public returns(uint) {

        updateBalance0();

        // retreiving the amount of $dbar user has approved this contract to have
        uint quantity = token_$dbar.allowance(msg.sender, address(this));

        // transfering $dbar from user to this contract
        token_$dbar.transferFrom(msg.sender, address(this), quantity);

        // Minting $xDbar for the user proportional to the staked amount
        uint rate;
        if (vault_$dbar == 0) {
            rate = 1;
        } else {
            rate = quantity/vault_$dbar;
        }

        _mint(msg.sender, quantity*rate);

        // Constructing a struct including the necessary information assigned to the staker
        // firstStaking = stake(msg.sender, quantity, rate);

        updateBalance0();

        return rate;
    }





    // Retrieving the $xDbar and giving out the $dbar
    function withdraw() public {
        
        uint quantity = balanceOf(msg.sender);
        
        // Burning the redeemed $xDbar from the user
        _burn(msg.sender, quantity);

        //Sending back the main and gained $dbar to the staker
        updateBalance0();
        
        // uint blockCounter = block.number - firstStaking.startBlock;
        // uint amount = firstStaking.rate*blockCounter*10;

        // return amount;
        
        // token_$dbar.increaseAllowance(msg.sender, firstStaking.amount);
        // token_$dbar.transferFrom(address(this), msg.sender, firstStaking.amount);
    }
}





// Deploy this contract second 
// (2)
contract Reward_Contract {

    uint public startBlock;

    Faucet public token_$dbar;
    uint public vault_$dbar;

    constructor(address _faucet) {
        token_$dbar = Faucet(_faucet);
        startBlock = block.number;
    }

    function updateBalance0() public {
        vault_$dbar = token_$dbar.balanceOf(address(this));
    }

    function redeem(address _receiver) public {

        updateBalance0();

        uint span = 10*(block.number - startBlock);
        token_$dbar.approve(_receiver, span);
        token_$dbar.transfer(_receiver, span);

        startBlock = block.number;

        updateBalance0();
    }
}




// Deploy this contract first
// (1)
contract Faucet is ERC20("First Token", "$dbar") {
    
    constructor() {
        _mint(msg.sender, 100);
    }

    function mint(address _receiver, uint _quantity) public {
        _mint(_receiver, _quantity);
    }
}


