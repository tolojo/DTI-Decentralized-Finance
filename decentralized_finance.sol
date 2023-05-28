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
        uint256 dateCreated; 
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
    event loanCreated(uint256 id ,address indexed borrower, uint256 amount, uint256 deadline);


    constructor() ERC20("DEX", "DEX") {
        _mint(address(this), 10**30);
        rateWEItoDEX = 50;
        maxLoanDate = 2592000 seconds; // 30 days
        owner=msg.sender;
        counter = 0;
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

    function loan(uint256 dexAmount, uint256 deadline) external returns (uint256){
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
        loanAux.dateCreated = block.timestamp;
        loans[counter] = loanAux;
        counter++;
        emit loanCreated(counter,msg.sender, loanAmount, deadline);
        _transfer(msg.sender, address(this), dexAmount);
        payable(msg.sender).transfer(loanAmount/2);
        return counter - 1;
    }

    function returnLoan(uint256 loanId) external payable {
        Loan storage loanAux = loans[loanId];
        uint256 interestRate = rateWEItoDEX + (5*(loanAux.deadline/86400)); // Interest rate will decrease the value of dex by each day that the loan is created;
        uint256 dexAmountWithInterest = msg.value*interestRate;
        require(loanAux.amountEth >= msg.value,"You returning more then the loan accepts");
        uint256 ethAmountLeft = loanAux.amountEth-msg.value;
        loanAux.amountEth = ethAmountLeft;
        loans[loanId] = loanAux;
        _transfer(address(this), msg.sender, dexAmountWithInterest);
        if (ethAmountLeft == 0){
            if(loans[loanId].isBaseNft){
                loans[loanId].nftContract.safeTransferFrom(loans[loanId].lender, loans[loanId].borrower, loans[loanId].nftId);
            }
            delete loans[loanId];
        }
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
       Loan memory loanAux;
        loanAux.amountEth=loanAmount;
        loanAux.borrower=msg.sender;
        loanAux.deadline=deadline;
        loanAux.lender=address(0);
        loanAux.isBaseNft=true;
        loanAux.nftContract = nftContract;
        loanAux.nftId = nftId;
        loanAux.dateCreated = block.timestamp;
        loans[counter] = loanAux;
        counter++;
        nftContract.safeTransferFrom(msg.sender, address(this), nftId);
    }

    function cancelLoanRequestByNft(IERC721 nftContract, uint256 nftId) external {
        for (uint256 i = 0; i<counter; i++) 
        {
            Loan storage loanAux = loans[i];
            if(msg.sender==loanAux.borrower){
                if(nftContract == loanAux.nftContract){
                    if(nftId == loanAux.nftId){
                        require(nftContract.ownerOf(nftId)==address(this));
                        delete loans[counter];
                        return;
                    }
                }
            }
        }
    }

    function loanByNft(IERC721 nftContract, uint256 nftId) external {
        for (uint256 i = 0; i<counter; i++) {
            if(loans[i].nftContract == nftContract && loans[i].nftId == nftId && loans[i].isBaseNft == true){
                require(msg.sender != loans[i].borrower);
                require(balanceOf(msg.sender) >= loans[i].amountEth);
                nftContract.transferFrom(address(this), msg.sender, nftId);
                uint256 loanAmount = loans[i].amountEth*rateWEItoDEX;
                _transfer(msg.sender, loans[i].borrower, loanAmount);
                emit loanCreated(counter, msg.sender, loanAmount, loans[i].deadline);
            }
        }

    
    }

    function checkLoan(uint256 loanId) external {
        Loan storage loanAux = loans[loanId];
        require(msg.sender == loans[loanId].lender, "You are not the owner");
        if (loanAux.dateCreated+loanAux.deadline > block.timestamp) {
            uint256 dexBalanceBorrower = balanceOf(loans[loanId].borrower);
            if (dexBalanceBorrower > loans[loanId].amountEth*rateWEItoDEX){
                _transfer(msg.sender, address(this), loans[loanId].amountEth*rateWEItoDEX);
            }
            else{
                _transfer(msg.sender, address(this), dexBalanceBorrower);
            }
            delete loans[loanId];
        }

    }

    function getRateEthToDex() public view returns (uint256) {
        return rateWEItoDEX;
    }

    function getTotalBorrowedAndNotPaidBackEth() public view returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i<counter; i++) {
            Loan storage loanAux = loans[i];
            if(loanAux.borrower == msg.sender) {
                total += loanAux.amountEth;
            }
        }
        return total;
    }
}


