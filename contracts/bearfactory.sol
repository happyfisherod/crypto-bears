pragma solidity >=0.8.0 <0.9.0;

import "./ownable.sol";
import "./safemath.sol";

contract BearFactory is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewBear(uint bearId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Bear {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Bear[] public bears;

  mapping (uint => address) public bearToOwner;
  mapping (address => uint) ownerBearCount;

  function _createBear(string memory _name, uint _dna) internal {
    uint id = bears.push(Bear(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    bearToOwner[id] = msg.sender;
    ownerBearCount[msg.sender] = ownerBearCount[msg.sender].add(1);
    emit NewBear(id, _name, _dna);
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomBear(string memory _name) public {
    require(ownerBearCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createBear(_name, randDna);
  }

}
