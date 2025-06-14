# Supply chain management contract
In recent years, compared to traditional supply chain systems blockchain technology provides countless opportunities and potential to improve and develop the framework in a supply chain management model. I’v developed a supply chain management contract built using blockchain technology that provides access to services which include inventory tracking, order placement and product attribute information log. This decentralized technology is spread across many computers and records every transaction. The contract provides secure and authentic information to its users at all stages using a dApp to ensure a seamless experience for verifying and maintaining data regarding all orders. May be this solidity contract is quite universal and covers a basic supply chain or e-commerce use case with producers, products, and orders. However, additional functionalities can be added in the future with enhanced compatibility: adding NFTs for products (ERC721); storing product metadata on IPFS; building a marketplace UI; writing a whitepaper or documentation; creating a token (ERC20) for rewards.

## Setup

1. Create Project Root
``` 
mkdir farm-to-chain-dapp && cd farm-to-chain-dapp
```

2. Initialize Node.js & Install Dependencies
``` 
npm init -y
npm install --save-dev hardhat
npx hardhat
# Choose "Create an empty hardhat.config.js"
```
Install dependencies:
``` 
npm install @nomicfoundation/hardhat-toolbox
npm install dotenv
```

3. Add Contract (contracts/MyContract.sol)
Create folder:
``` 
mkdir contracts
```
Paste in the updated contract from earlier.

4. Add Deployment Script (scripts/deploy.js)
``` 
mkdir scripts
touch scripts/deploy.js
```
Paste the deploy script code from above.

5. Add Test File (test/mycontract.test.js)
```
mkdir test
touch test/mycontract.test.js
```
Paste in the test code.

6. Add Frontend App
```
npx create-react-app frontend
cd frontend
npm install ethers wagmi viem web3modal
```
Replace contents of 
src/App.jsx
 and index
.js with the React code provided earlier.

7. Configure Hardhat
Edit hardhat.config.js:
``` 
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
  goerli: {
  url: process.env.ALCHEMY_GOERLI_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
};
```

8. Add .env File
``` 
ALCHEMY_GOERLI_URL=https://eth-goerli.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=your_wallet_private_key
```

9. Compile contract:
``` 
npx hardhat compile
```

10. Deploy:
```
npx hardhat run scripts/deploy.js --network goerli
```

11. Run tests:
```
npx hardhat test
```

12. Start frontend:
```
cd frontend
npm start
```

## Deploy to Goerli Testnet

1. Get Goerli ETH
Go to a faucet like:
- https://faucets.chain.link/goerli 
- https://goerli-faucet.mudit.blog/ 
Send some ETH to your MetaMask Goerli account.

2. Set Up Alchemy / Infura
Sign up at:
- [Alchemy](https://alchemy.com) 
- [Infura](https://infura.io) 
Get a Goerli RPC URL like:
https://eth-goerli.g.alchemy.com/v2/YOUR_API_KEY
Add to `.env`:
```
1 ALCHEMY_GOERLI_URL=https://eth-goerli.g.alchemy.com/v2/YOUR_API_KEY
2 PRIVATE_KEY=your_wallet_private_key
```

3. Deploy Contract
```
npx hardhat run scripts/deploy.js --network goerli
```
Save the deployed contract address.

4. Update Frontend with Contract Address
In frontend/src/App.jsx, replace:
``` 
const contractAddress = "YOUR_CONTRACT_ADDRESS";
```
with your actual deployed address.
