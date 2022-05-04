// SPDX-License-Identifier: Unlicnsed

pragma solidity ^0.8.7;

contract CryptoKids {
    // Owner 
    address owner;

    constructor(){
        owner = msg.sender;
    }

    struct Kid {
        address payable walletAddress;
        string firstName;
        string lasName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Kid[] public kids;

    function addKid(address payable walletAddress, string memory firstName, string memory lasName, uint releaseTime, uint amount, bool canWithdraw) public {
        kids.push(Kid(
            walletAddress,
            firstName,
            lasName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

    function deposit(address walletAddress) payable public{
        addToKidsBalance(walletAddress);
    }

    function addToKidsBalance(address walletAddress) private {
        for(uint i=0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                kids[i].amount += msg.value;
            }
        }
    }

    function getIndex(address walletAddress) view private returns(uint){
        for(uint i=0; i< kids.length ; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
        }
        return 999;
    }

    function availableToWithdraw(address walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        if(block.timestamp >= kids[i].releaseTime){
            kids[i].canWithdraw = true;
            return true;
        }
        else {
            return false;
    }
    }

    function withdraw(address payable walletAddress) payable public{
        uint i = getIndex(walletAddress);
        kids[i].walletAddress.transfer(kids[i].amount);
    }

}
// Address - 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,"Jarvis","S",1651588667,0,false