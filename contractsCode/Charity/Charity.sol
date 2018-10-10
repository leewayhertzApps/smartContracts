pragma solidity ^0.4.0;

import "./Ownable.sol";
import "./ERC20.sol";
import "./SafeMath.sol";

contract Charity is ERC20,Ownable{

   using SafeMath for uint256;

    ERC20 _tokenContract;
    uint256 totalAllocatedTokens;
    uint256 tokenReleaseDate;
    bool isSaleStart = false;


    mapping (address => uint256) public allocatedTokens;

        constructor() public{
         _tokenContract = ERC20(0x7e0f46c6c75bc48f75226d3abd4635dafb1221f7);
        }

       /*
        * this function add team members to array and also allocate tokens to them.
        */       
        function addUsers(address _userAddress, uint256 _tokens) public onlyOwner {

          uint256 contractBalance = _tokenContract.balanceOf(address(this));

          require(contractBalance.sub(totalAllocatedTokens) >= _tokens);
          totalAllocatedTokens = totalAllocatedTokens.add(_tokens);

          //allocate tokens to the user
          allocatedTokens[_userAddress] = allocatedTokens[_userAddress].add(_tokens);
        }


    /*
     *transfer tokens from contract account to the user  
     */
      function transfer(address _to, uint256 _tokens)  public returns (bool) {

        require(tokenReleaseDate!=0);
        require(now > tokenReleaseDate);
        require(msg.sender==_to);

        uint256 userBalance = _tokenContract.balanceOf(_to);
        uint256 contractBalance = balanceOf(address(this));

        require((userBalance+_tokens)<=allocatedTokens[_to]);

        require(contractBalance>=_tokens);

        totalAllocatedTokens=totalAllocatedTokens.sub(_tokens);

         if(!isSaleStart)
              isSaleStart = true;
        _tokenContract.transfer(_to,_tokens);
        return true;
    }

    /*
     * set release date of tokens , 
     * only called by admin 
     */
    function releaseTokens(uint256 startDate)  public onlyOwner returns (bool) {
          //require(tokenReleaseDate==0);
          require(!isSaleStart);
          require(startDate>now);
          //tokenReleaseDate is equal to startDate plus time limit
          tokenReleaseDate = startDate.add(94694400);
          return true;
    }

    /*
     *return allocatedTokens , user balance and available tokens to withdraw 
     */
    function getUserDetails(address _userAddress) public constant returns(uint256,uint256,uint256){
        uint256 userAllocation = allocatedTokens[_userAddress];
        uint256 userBalance = _tokenContract.balanceOf(_userAddress);
        uint256 availableTokens;
        if(now>tokenReleaseDate){
         availableTokens = userAllocation.sub(userBalance);
        }
        return (userAllocation,userBalance,availableTokens);
    }

    /*
     * burn the tokens of the contract, 
     * only called by the owner 
     */
    function burnTokens(uint256 _value)  public onlyOwner returns (bool) {
          _tokenContract.burnTokens(_value);
          return true;
    }

     /*
      * return total supply of tokens
      */
     function totalSupply() public constant returns (uint256){
           return _tokenContract.totalSupply();
       }

     /*
      * return balance(no of tokens) of user
      */
       function balanceOf(address _who) public constant returns (uint256){
         return _tokenContract.balanceOf(_who);
       }
}