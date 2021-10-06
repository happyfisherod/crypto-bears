pragma solidity >=0.8.0 <0.9.0;

import "./bearfactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract BearFeeding is BearFactory {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _bearId) {
    require(msg.sender == bearToOwner[_bearId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Bear storage _bear) internal {
    _bear.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Bear storage _bear) internal view returns (bool) {
      return (_bear.readyTime <= now);
  }

  function feedAndMultiply(uint _bearId, uint _targetDna, string memory _species) internal onlyOwnerOf(_bearId) {
    Bear storage myBear = bears[_bearId];
    require(_isReady(myBear));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myBear.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createBear("NoName", newDna);
    _triggerCooldown(myBear);
  }

  function feedOnKitty(uint _bearId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_bearId, kittyDna, "kitty");
  }
}
