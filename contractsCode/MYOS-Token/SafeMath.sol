pragma solidity ^0.4.16;


library SafeMath {
  function mul(uint40 a, uint40 b) internal pure returns (uint40) {
    if (a == 0) {
      return 0;
    }
    uint40 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint40 a, uint40 b) internal pure returns (uint40) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint40 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint40 a, uint40 b) internal pure returns (uint40) {
    assert(b <= a);
    return a - b;
  }

  function add(uint40 a, uint40 b) internal pure returns (uint40) {
    uint40 c = a + b;
    assert(c >= a);
    return c;
  }
}