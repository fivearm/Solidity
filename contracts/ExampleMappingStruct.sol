//SPDX-License-Identifier:  MIT

pragma solidity 0.8.17;

contract ExampleMappingStruct{

    struct Transaction {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        uint numWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    mapping(address => Balance) public acctDetails;

    function getBalance(address _address) public view returns(uint) {
        return acctDetails[_address].totalBalance;
    }

    function depositMoney() public payable {
        acctDetails[msg.sender].totalBalance += msg.value;

        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        //set acctDetails.deposits key to numDeposits and value to the 'deposit' Transaction
        acctDetails[msg.sender].deposits[acctDetails[msg.sender].numDeposits] = deposit;
        //increase numDeposits by one
        acctDetails[msg.sender].numDeposits++;
    }

    function withdrawMoney(address payable _to, uint _amount) public payable {
        acctDetails[msg.sender].totalBalance -= _amount;

        Transaction memory withdrawal = Transaction(msg.value, block.timestamp);
        acctDetails[msg.sender].withdrawals[acctDetails[msg.sender].numWithdrawals] = withdrawal;
        acctDetails[msg.sender].numWithdrawals++;

        //send the amount out
        _to.transfer(_amount);

    }

}