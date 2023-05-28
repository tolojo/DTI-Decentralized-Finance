const web3 = new Web3(window.ethereum);

// DecentralizedFinance smart contract
const defi_contractAddress = "0xf84993Db993CE36C473F52e778f48113F848E3D1";
import {
    defi_abi
} from "./abi_decentralized_finance.js";
const defi_contract = new web3.eth.Contract(defi_abi, defi_contractAddress);

// SimpleNFT smart contract
const nft_contractAddress = "0x2264C29D03BbeAa33b864f0b5eDb03c75779D3C9";
import {
    nft_abi
} from "./abi_nft.js";
const nft_contract = new web3.eth.Contract(nft_abi, nft_contractAddress);

async function connectMetaMask() {
    if (window.ethereum) {
        try {
            const accounts = await window.ethereum.request({
                method: "eth_requestAccounts",
            });
            console.log("Connected account:", accounts[0]);
        } catch (error) {
            console.error("Error connecting to MetaMask:", error);
        }
    } else {
        console.error("MetaMask not found. Please install the MetaMask extension.");
    }

}

async function setRateEthToDex(rate) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    try {
        await defi_contract.methods.setRateEthToDex(rate).send({
            from: fromAddress,
        });
        console.log("ETH to DEX conversion rate set successfully");
    } catch (error) {
        console.error("Error setting ETH to DEX conversion rate:", error);
    }
}

async function listenToLoanCreation() {
    defi_contract.events.loanCreated((error, event) => {
        if (error) {
            console.error("Error listening to loan creation event:", error);
        } else {
            console.log("Loan created - Borrower:", event.returnValues.borrower);
            console.log("Loan amount:", event.returnValues.amount);
            console.log("Deadline:", event.returnValues.deadline);
        }
    });
}

async function checkLoanStatus(loanId) {

    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.checkLoan(loanId)
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('Loan status:', result);
        })
        .catch(error => {

            console.error('Error checking loan status:', error);
        });
}

async function buyDex() {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    try {
        await defi_contract.methods.buyDex().send({
            from: fromAddress,
            value: web3.utils.toWei("0.001", "ether"),
        });
        console.log("DEX bought successfully");
    } catch (error) {
        console.error("Error buying DEX:", error);
    }

    await defi_contract.methods.buyDex();
}

async function getDex() {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.getDex()
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('getDex result:', result);
        })
        .catch(error => {

            console.error('getDex error:', error);
        });

}

async function sellDex(dexAmount) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    try {
        await defi_contract.methods.sellDex(dexAmount).send({
            from: fromAddress,
        });
        console.log("DEX sold successfully");
    } catch (error) {
        console.error("Error selling DEX:", error);
    }
}

async function loan(dexAmount, deadline) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    const result = await defi_contract.methods.loan(dexAmount, deadline).send({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('Loan created successfully, id:', result, result.events.loanCreated.returnValues[1]);
            console.log('id:', result.events.returnValues);
        })
        .catch(error => {

            console.error('Error creating loan:', error);
        });
}

async function returnLoan(loanId) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    const result = await defi_contract.methods.returnLoan(loanId).send({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('Loan returned successfully:', result);
        })
        .catch(error => {

            console.error('Error returning loan:', error);
        });

}

async function getEthTotalBalance() {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.getEthTotalBalance()
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('ETH total balance:', result);
        })
        .catch(error => {

            console.error('Error getting ETH total balance:', error);
        });
}

async function getRateEthToDex() {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.getRateEthToDex()
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('ETH to DEX conversion rate:', result);
        })
        .catch(error => {

            console.error('Error getting ETH to DEX conversion rate:', error);
        });
}

async function getAvailableNfts() {
    //TODO
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.getAvailableNfts()
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('Available NFTs:', result);
        })
        .catch(error => {

            console.error('Error getting available NFTs:', error);
        });

}

async function getTotalBorrowedAndNotPaidBackEth() {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    const result = await defi_contract.methods.getTotalBorrowedAndNotPaidBackEth()
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('Total borrowed and not paid back ETH:', result);
        })
        .catch(error => {

            console.error('Error getting total borrowed and not paid back ETH:', error);
        });
}

async function makeLoanRequestByNft(nftId, dexAmount, deadline) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    try {
        await defi_contract.methods.makeLoanRequestByNft(nftId, dexAmount, deadline).send({
            from: fromAddress,
        });
        console.log("Loan request created successfully");
    } catch (error) {
        console.error("Error creating loan request:", error);
    }
}

async function cancelLoanRequestByNft(nftId) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    try {
        await defi_contract.methods.cancelLoanRequestByNft(nftId).send({
            from: fromAddress,
        });
        console.log("Loan request canceled successfully");
    } catch (error) {
        console.error("Error canceling loan request:", error);
    }
}

async function loanByNft(nftId, dexAmount, deadline) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];
    try {
        await defi_contract.methods.loanByNft(nftId, dexAmount, deadline).send({
            from: fromAddress,
        });
        console.log("Loan created using NFT as collateral");
    } catch (error) {
        console.error("Error creating loan by NFT:", error);
    }
}

async function checkLoan(loanId) {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.checkLoan(loanId)
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('Loan status:', result);
        })
        .catch(error => {

            console.error('Error checking loan:', error);
        });
}

async function getAllTokenURIs() {
    const fromAddress = (await window.ethereum.request({
        method: "eth_accounts",
    }))[0];

    const result = await defi_contract.methods.getAllTokenURIs()
        .call({
            from: fromAddress,
            gas: 3000000,
            gasPrice: '20000000000'
        })
        .then(result => {
            console.log('All Token URIs:', result);
        })
        .catch(error => {
            console.error('Error getting all token URIs:', error);
        });
}

window.connectMetaMask = connectMetaMask;
window.buyDex = buyDex;
window.getDex = getDex;
window.sellDex = sellDex;
window.loan = loan;
window.returnLoan = returnLoan;
window.getEthTotalBalance = getEthTotalBalance;
window.setRateEthToDex = setRateEthToDex;
window.getRateEthToDex = getRateEthToDex;
window.makeLoanRequestByNft = makeLoanRequestByNft;
window.cancelLoanRequestByNft = cancelLoanRequestByNft;
window.loanByNft = loanByNft;
window.checkLoan = checkLoan;
window.listenToLoanCreation = listenToLoanCreation;
window.getAvailableNfts = getAvailableNfts;
window.getTotalBorrowedAndNotPaidBackEth = getTotalBorrowedAndNotPaidBackEth;
window.checkLoanStatus = checkLoanStatus;
window.getAllTokenURIs = getAllTokenURIs;