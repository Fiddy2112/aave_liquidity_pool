// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract AaveLiquidityPool {
  address payable owner;

  IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
  IPool public immutable POOL;

  address private immutable linkAddress = 0xf8Fb3713D459D7C1018BD0A49D19b4C44290EBE5;
  IERC20 private link;

  constructor(address _addressesProvider) {
    ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressesProvider);
    POOL = IPool(ADDRESSES_PROVIDER.getPool());
    owner = payable(msg.sender);
    link = IERC20(linkAddress);
  }

  modifier onlyOnwer {
    require(msg.sender == owner,"You don't have permission, only owner can perform this action");
    _;
  }

  function supplyLiquidity(address _tokenAddress, uint256 _amount) external{

      address asset = _tokenAddress;
      uint256 amount = _amount;
      address onBehalfOf = address(this);
      uint16 referralCode =0;

      POOL.supply( asset, amount, onBehalfOf, referralCode);
  }

  function withdrawLiquidity(address _tokenAddress, uint256 _amount) external returns(uint256){

    address asset = _tokenAddress; 
    uint256 amount = _amount;
    address to = address(this);

    return POOL.withdraw( asset, amount, to);
  }

    function getUserAccountData(address _addressUser)external view returns (
      uint256 totalCollateralBase,
      uint256 totalDebtBase,
      uint256 availableBorrowsBase,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    ){

       return POOL.getUserAccountData(_addressUser);

    }

    function approveLINK(uint256 _amount, address _poolContractAddress)external returns(bool){
        return link.approve(_poolContractAddress,_amount);
    }

    function allowanceLink(address _poolContractAddress) external view returns(uint256){
        return link.allowance(address(this), _poolContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns(uint256){
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOnwer{
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender,token.balanceOf(address(this)));
    }

    receive() external payable { }

}


