pragma solidity ^0.4.16;
import "./ERC20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract Pre_ICO_1 is Ownable{

       using SafeMath for uint256;

        uint constant public HARD_CAP =   4934 * 10**18;
        uint constant public SOFT_CAP =   700 * 10**18;
        // rate is the number of tokens per ether
        uint constant public rate = 144000;
        bool isSaleStart = false;

        uint public icoStartDate;
        uint public endDate;
        uint public totalWeiCollected;
        ERC20 _tokenContract;

        address public beneficiary = 0x09B673099Cb9a92FC7D9086BB0F49218b28747C2;

        constructor() public {
            //address of token contract
            _tokenContract = ERC20(0x1d18b8516244c171d19cfa0aebcaea487bcc9b46);
        }

        //this function is called whenever some spender send ethers to this contract
        function() public payable {
             buyTokens();
        }

        function buyTokens() public payable {
            require(msg.value>0);

            require(endDate>0);


            uint weiCollectedAfterTransaction = totalWeiCollected.add(msg.value);
            require(weiCollectedAfterTransaction <= HARD_CAP);

            //if softcap is not reached, then extend sale to one month
            if(now>endDate && totalWeiCollected<SOFT_CAP){

                  endDate=endDate.add(2678400);

            }
            require(now<=endDate);

            uint tokenBrought = (msg.value).mul(rate);

            require((_tokenContract.balanceOf(address(this)))>=tokenBrought);

             if(!isSaleStart)
                  isSaleStart = true;
            _tokenContract.transfer(msg.sender,tokenBrought);
            //this line transfer received ethers to beneficiary account
            beneficiary.transfer(msg.value);
        }

        function burnTokens(uint256 _value)  public onlyOwner returns (bool) {
            _tokenContract.burnTokens(_value);
            return true;
        }

        function releaseTokens(uint256 _startDate) public onlyOwner returns(bool){
            require(!isSaleStart);
            icoStartDate= _startDate;
            endDate = _startDate.add(2678400);
            return true;
        }
}