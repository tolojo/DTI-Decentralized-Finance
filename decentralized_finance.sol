// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract DecentralizedFinance is ERC20{

    uint256 rateETHtoDEX;
    uint256 maxLoadDate;
    struct Loan {         
        uint256 deadline;         
        uint256 amountEth;         
        address lender;         
        address borrower;         
        bool isBaseNft;         
        IERC721 nftContract;         
        uint256 nftId;     
        }
    mapping(uint256 => Loan) public loans;
    event loanCreated(address indexed borrower, uint256 amount, uint256 deadline);

    constructor() ERC20("DEX", "DEX") {
        _mint(address(this), 10**30);
        rateETHtoDEX = 50;
        maxLoadDate = 30 days;
        // TODO: initialize
    }

    function buyDex() external payable {
        uint256 dexAmount = msg.value * rateETHtoDEX;
        _mint(msg.sender, dexAmount);
    }

    function sellDex(uint256 dexAmount) external {
        require(balanceOf(msg.sender) >= dexAmount, "Insufficient DEX balance");
        uint256 ethAmount = dexAmount / rateETHtoDEX;
        address(this).transfer(dexAmount);
        payable(msg.sender).transfer(ethAmount);
    }

    function loan(uint256 dexAmount, uint256 deadline) external {
        // TODO: implement this

        emit loanCreated(msg.sender, loanAmount, deadline);
    }

    function returnLoan(uint256 ethAmount) external {
        // TODO: implement this
    }

    function getEthTotalBalance() public view returns (uint256) {
        // TODO: implement this
    }

    function setRateEthToDex(uint256 rate) external {
        require(msg.sender==this.);
    }

    function getDex() public view returns (uint256) {
        // TODO: implement this
    }

    function makeLoanRequestByNft(IERC721 nftContract, uint256 nftId, uint256 loanAmount, uint256 deadline) external {
        // TODO: implement this
    }

    function cancelLoanRequestByNft(IERC721 nftContract, uint256 nftId) external {
        // TODO: implement this
    }

    function loanByNft(IERC721 nftContract, uint256 nftId) external {
        // TODO: implement this

        emit loanCreated(msg.sender, loanAmount, deadline);
    }

    function checkLoan(uint256 loanId) external {
        // TODO: implement this
    }
}