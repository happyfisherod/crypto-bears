// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./bearhelper.sol";

contract BearAttack is BearHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _bearId, uint _targetId) external onlyOwnerOf(_bearId) {
    Bear storage myBear = bears[_bearId];
    Bear storage enemyBear = bears[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myBear.winCount++;
      myBear.level++;
      enemyBear.lossCount++;
      feedAndMultiply(_bearId, enemyBear.dna, "bear");
    } else {
      myBear.lossCount++;
      enemyBear.winCount++;
      _triggerCooldown(myBear);
    }
  }
}
