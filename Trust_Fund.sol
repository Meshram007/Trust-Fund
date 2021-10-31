//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Trust_Fund {
    
     // define the data structure for kid

     struct Kid {
        uint amount;
        uint maturity; // maturity is the time period to mature fund
        bool paid; // amount to be paid after maturity
     }


     // define kids with their unique address and amount and status of paid or unpaid
     mapping(address => Kid) public kids;


     // manager will only enetrd the data of kids
     address public manager;


     // define the manager with unique address and only he can able to add the kids
     constructor() {
         manager = msg.sender;
     }


     // this function will define the adress of kis an =d period of maturity
     // this function can be operated by externally or by kids after maturity period
     function addKid(address kid, uint timeToMaturity) external payable {
          require(msg.sender == manager, "only manager");
          require(kids[msg.sender].amount == 0, "kid already exist");
          kids[kid] = Kid(msg.value, block.timestamp + timeToMaturity, false);
     }


     // added kids withdraw the fund after the maaturity
     function withdraw() external {
         Kid storage kid = kids[msg.sender];
         require(kid.maturity <= block.timestamp, "too early");
         require(kid.amount > 0, "only kid can withdraw");
         require(kid.paid == false, "paid already");
         kid.paid = true;
         payable(msg.sender).transfer(kid.amount);
     }
  }