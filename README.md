# How to run the project
To run the project, first you need to compile both decentralized_finance.sol and nft.sol.
After they are compiled you need to deploy them using the Sepolia network through the Remix IDE, this way you can use your own sepolia tokens.
Don't forget that you need to change both the ```abi_decentralized_finance.js``` and ```abi_nft.js``` to the corresponding abi of each contract and the contract addresses in the main.js file to the corresponding addresses of the deployed contracts.


# Inside de index.html file
Inside this file you will find all the functions you can call as well as the connect to Metamask button.
To run each function, you need to vace connected your metamask account in the Sepolia network.

# Important notes/formulas
The following formulas are the ones used in our contract and are as follow:
 	
 	rateWEItoDEX = 50 // 1 Wei is equal to 50 DEX
 	
 	interestRate = rateWEItoDEX + (5*(loanAux.deadline/86400));
    dexAmountWithInterest = msg.value*interestRate;
    Interest rate will decrease the value of dex by each day that the loan is created, this way by each day of the deadline, the interest rate will increase by 5
      
# How do we punish who doesn't pay the loans when you use NFT's as collateral?
When the deadline is due past the established, the lender will permanently be the owner of the NFT, and the contract will remove DEX from the borrower account and give it to the lender. The amount of DEX removed depends on the contract, but it will remove the amount of DEX borrowed if the borrower has that amount on its account, otherwise, will remove all of the DEX it has. 
