pragma solidity ^0.5.0;

interface IAtoken {
  function redirectInterestStream(address _to) external;
  function redirectInterestStreamOf(address _from, address _to) external;
  function redeem(uint256 _amount) external;
  function balanceOf(address _user) external view returns(uint256);
  function principalBalanceOf(address _user) external view returns(uint256);
  function totalSupply() external;
  function isTransferAllowed(address _user, uint256 _amount) external view returns (bool);
  function getUserIndex(address _user) external view returns(uint256);
  function getInterestRedirectionAddress(address _user) external view returns(address);
  function getRedirectedBalance(address _user) external view returns(uint256);
}