pragma solidity >=0.8.0 <0.9.0;

import "./bearhelper.sol";

contract BearAttack is BearHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _bearId, uint _targetId) external onlyOwnerOf(_bearId) {
    Bear storage myBear = bears[_bearId];
    Bear storage enemyBear = bears[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myBear.winCount = myBear.winCount.add(1);
      myBear.level = myBear.level.add(1);
      enemyBear.lossCount = enemyBear.lossCount.add(1);
      feedAndMultiply(_bearId, enemyBear.dna, "bear");
    } else {
      myBear.lossCount = myBear.lossCount.add(1);
      enemyBear.winCount = enemyBear.winCount.add(1);
      _triggerCooldown(myBear);
    }
  }
}
