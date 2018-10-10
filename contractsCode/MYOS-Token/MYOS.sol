pragma solidity ^0.4.0;
import "./ERC20.sol";
import "./SafeMath.sol";


contract MYOS is ERC20 {


    using SafeMath for uint256;

        /* This creates an array with all balances */
        mapping (address => uint256) public balanceOfUser;

        uint256 totalTokens;
        string public name;
        string public symbol;
        uint8 public decimals;

        // mapping (address => mapping (address => uint256)) public allowed;

        //this function will create token with a initial amount by the owner of the contract
        constructor(uint40 initialSupply,string token_name,string token_symbol,uint8 decimalUnit) public {
         totalTokens = initialSupply * 10**uint256(decimalUnit);
         balanceOfUser[msg.sender] = totalTokens;
         name = token_name;
         symbol = token_symbol;
         decimals = decimalUnit;
       }

     //this function transfer token from the owner's account to some other address
       function transfer(address _to, uint256 value) public returns (bool){
          require(balanceOfUser[msg.sender]>=value);
          balanceOfUser[msg.sender] = balanceOfUser[msg.sender].sub(value);
          balanceOfUser[_to] = balanceOfUser[_to].add(value);
           emit Transfer(msg.sender, _to, value);
           return true;
        }

       function totalSupply() public constant returns (uint256){
           return totalTokens;
       }

       function balanceOf(address _who) public constant returns (uint256){
         return (balanceOfUser[_who]);
       }

    function burnTokens(uint256 _value) public returns (bool){
            require(_value>0);
            require(balanceOfUser[msg.sender]>=_value);
            balanceOfUser[msg.sender] = balanceOfUser[msg.sender].sub(_value);
            totalTokens = totalTokens.sub(_value);
            return true;
    }
}