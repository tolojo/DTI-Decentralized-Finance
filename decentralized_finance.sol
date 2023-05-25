// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract DecentralizedFinance is ERC20{
    address owner;
    uint256 rateWEItoDEX;
    uint256 maxLoanDate;
    uint256 counter;
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
    mapping(address => uint256) public numTokensPerWallet;
    event loanCreated(address indexed borrower, uint256 amount, uint256 deadline);


    constructor() ERC20("DEX", "DEX") {
        _mint(address(this), 10**30);
        rateWEItoDEX = 50;
        maxLoanDate = 2592000 seconds; // 30 days
        owner=msg.sender;
        counter = 0;
        // TODO: initialize
    }

    function buyDex() external payable {
        uint256 dexAmount = msg.value * rateWEItoDEX;
        require(totalSupply()>=dexAmount, "not enough DEX for that buy");
        _transfer(address(this),msg.sender,dexAmount);

    }

    function sellDex(uint256 dexAmount) external {
        uint256 weiAmount = dexAmount / rateWEItoDEX;
        require(address(this).balance >= weiAmount, "Insufficient ETH balance in the contract");
        _transfer(msg.sender, address(this), dexAmount);
        payable(msg.sender).transfer(weiAmount);
    }

    function loan(uint256 dexAmount, uint256 deadline) external {
        require(balanceOf(msg.sender)>=dexAmount);
        require(deadline<=maxLoanDate);
        uint256 interestRate = rateWEItoDEX + (5*(deadline/86400)); // Interest rate will decrease the value of dex by each day that the loan is created;
        uint256 loanAmount = dexAmount/interestRate;
        Loan memory loanAux;
        loanAux.amountEth=loanAmount;
        loanAux.borrower=msg.sender;
        loanAux.deadline=deadline;
        loanAux.lender=address(this);
        loanAux.isBaseNft=false;
        loans[counter] = loanAux;
        counter++;
        emit loanCreated(msg.sender, loanAmount, deadline);
        _transfer(msg.sender, address(this), dexAmount);
        payable(msg.sender).transfer(loanAmount/2);
    }

    function returnLoan(uint256 loanId, uint256 ethAmount) external {
        
        
    }

    function getEthTotalBalance() public view returns (uint256) {
       return address(this).balance;
    }

    function setRateEthToDex(uint256 rate) external {
        require(msg.sender==owner);
        rateWEItoDEX = rate;
    }

    function getDex() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function makeLoanRequestByNft(IERC721 nftContract, uint256 nftId, uint256 loanAmount, uint256 deadline) external {
        // TODO: implement this
    }

    function cancelLoanRequestByNft(IERC721 nftContract, uint256 nftId) external {
        // TODO: implement this
    }

    function loanByNft(IERC721 nftContract, uint256 nftId) external {
        // TODO: implement this

       // emit loanCreated(msg.sender, loanAmount, deadline);
    }

    function checkLoan(uint256 loanId) external {
       //require(msg.sender == owner, "Only the contract owner can check the loan");

        Loan storage loan = loans[loanId];
        require(loan.borrower != address(0), "Loan does not exist");

        if (block.timestamp > loan.deadline) {  // temos de ver como fazemos a validação de tempo
            // Loan repayment deadline has passed
            if (balanceOf(loan.borrower) >= loan.amountEth) {
                // Borrower has enough DEX tokens to repay the loan
                // Punish the borrower by transferring the loan amount from the borrower's address to the contract owner
                _transfer(loan.borrower, owner, loan.amountEth);
            } else {
                // Borrower does not have enough DEX tokens to repay the loan
                // Take necessary steps to punish the borrower (e.g., flag the loan as defaulted, initiate a penalty, etc.)
                // Add your custom punishment logic here
            }
        }

    }
}