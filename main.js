const web3 = new Web3(window.ethereum);

// the part is related to the DecentralizedFinance smart contract
const defi_contractAddress = "0xA9921E85494EF7aF77570E71a5d185CbeB8400F8";
import { defi_abi } from "./abi_decentralized_finance.js";
const defi_contract = new web3.eth.Contract(defi_abi, defi_contractAddress);

// the part is related to the the SimpleNFT smart contract
const nft_contractAddress = "0x6Be201FB7a6a5392282787a6A948753f2D948Be6";
import { nft_abi } from "./abi_nft.js";
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

async function setRateEthToDex() {
    // TODO: implement this
}

async function listenToLoanCreation() {
    // TODO: implement this
}

async function checkLoanStatus() {
    // TODO: implement this
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
    // TODO: implement this
}

async function sellDex() {
    // TODO: implement this
}

async function loan() {
    // TODO: implement this
}

async function returnLoan() {
    // TODO: implement this
}

async function getEthTotalBalance() {
    // TODO: implement this
}

async function getRateEthToDex() {
    // TODO: implement this
}

async function getAvailableNfts() {
    // TODO: implement this
}

async function getTotalBorrowedAndNotPaidBackEth() {
    // TODO: implement this
}

async function makeLoanRequestByNft() {
    // TODO: implement this
}

async function cancelLoanRequestByNft() {
    // TODO: implement this
}

async function loanByNft() {
    // TODO: implement this
}

async function checkLoan() {
    // TODO: implement this
}

async function getAllTokenURIs() {
    // TODO: implement this
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
