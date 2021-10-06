// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ownable.sol";

contract BearFactory is Ownable {

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
    bears.push(Bear(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    uint id = bears.length - 1;
    bearToOwner[id] = msg.sender;
    ownerBearCount[msg.sender]++;
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
