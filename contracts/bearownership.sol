pragma solidity >=0.8.0 <0.9.0;

import "./bearattack.sol";
import "./erc721.sol";
import "./safemath.sol";

/// @title A contract that manages transfering bear ownership
/// @author Nero Zato 💯💯😎💯💯
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft
contract BearOwnership is BearAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) bearApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerBearCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return bearToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerBearCount[_to] = ownerBearCount[_to].add(1);
    ownerBearCount[msg.sender] = ownerBearCount[msg.sender].sub(1);
    bearToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (bearToOwner[_tokenId] == msg.sender || bearApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    bearApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
