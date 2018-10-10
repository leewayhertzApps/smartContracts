pragma solidity ^0.4.24;


contract Ownable {
  address public owner;
  
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );
  
  constructor() public {
    owner = msg.sender;
  }
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
}