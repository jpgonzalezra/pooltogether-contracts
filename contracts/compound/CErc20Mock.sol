pragma solidity ^0.5.0;

import "./ICErc20.sol";
import "zos-lib/contracts/Initializable.sol";
import "openzeppelin-eth/contracts/token/ERC20/IERC20.sol";

contract CErc20Mock is Initializable, ICErc20 {
  mapping(address => uint256) ownerTokenAmounts;

  uint __supplyRateMantissa;

  function initialize (address _token, uint256 _supplyRateMantissa) public initializer {
    require(_token != address(0), "token is not defined");
    underlying = _token;
    __supplyRateMantissa = _supplyRateMantissa;
  }

  function mint(uint amount) external returns (uint) {
    ownerTokenAmounts[msg.sender] = amount;
    require(IERC20(underlying).transferFrom(msg.sender, address(this), amount), "could not transfer tokens");
    return 0;
  }

  function getCash() external view returns (uint) {
    return IERC20(underlying).balanceOf(address(this));
  }

  function redeemUnderlying(uint requestedAmount) external returns (uint) {
    require(ownerTokenAmounts[msg.sender] > 0, "you must have supplied tokens");
    require(IERC20(underlying).transfer(msg.sender, requestedAmount), "could not transfer tokens");
    return 0;
  }

  function balanceOfUnderlying(address account) external returns (uint) {
    return (ownerTokenAmounts[account] * 120) / 100;
  }

  function supplyRatePerBlock() external view returns (uint) {
    return __supplyRateMantissa;
  }
}
