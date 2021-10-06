pragma solidity >=0.8.0 <0.9.0;

import "./bearfeeding.sol";

contract BearHelper is BearFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _bearId) {
    require(bears[_bearId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    address _owner = owner();
    _owner.transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _bearId) external payable {
    require(msg.value == levelUpFee);
    bears[_bearId].level = bears[_bearId].level.add(1);
  }

  function changeName(uint _bearId, string calldata _newName) external aboveLevel(2, _bearId) onlyOwnerOf(_bearId) {
    bears[_bearId].name = _newName;
  }

  function changeDna(uint _bearId, uint _newDna) external aboveLevel(20, _bearId) onlyOwnerOf(_bearId) {
    bears[_bearId].dna = _newDna;
  }

  function getBearsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerBearCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < bears.length; i++) {
      if (bearToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
