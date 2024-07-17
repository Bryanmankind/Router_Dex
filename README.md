## DEX on Router Blockchain

This project involves deploying a decentralized exchange (DEX) on the Router blockchain. The DEX enables users to seamlessly swap tokens, providing a secure, efficient, and user-friendly platform for trading digital assets. By leveraging the Router blockchain's advanced capabilities, the DEX aims to enhance liquidity and facilitate smooth, decentralized transactions.

## Project Setup

1. Clone the repository:

    ```sh
    git clone https://github.com/Bryanmankind/Router_Dex.git
    cd router-dex
    ```

2. Install the necessary dependencies:

    ```sh
    npm install
    ```

3. Configure the Router blockchain settings in the `hardhat.config.js` file:

    ```js
    module.exports = {
      networks: {
        router: {
          url: 'https://rpc.routerchain.dev',
          accounts: ['<YOUR_PRIVATE_KEY>']
        }
      },
      solidity: '0.8.4',
    };
    ```

## Deployment

1. Compile the smart contracts:

    ```sh
    npx hardhat compile
    ```

2. Deploy the smart contracts to the Router blockchain:

    ```sh
    npx hardhat run scripts/deploy.js --network router
    ```

    This will output the addresses of the deployed contracts. Note them down for future reference.

## Interacting with the DEX

You can interact with the deployed DEX using a frontend application or directly via Hardhat scripts.

### Using Hardhat scripts

1. To check the status of the DEX, run:

    ```sh
    npx hardhat run scripts/status.js --network router
    ```

2. To perform trades, run:

    ```sh
    npx hardhat run scripts/trade.js --network router
    ```

### Using a Frontend Application

1. Navigate to the `frontend` directory:

    ```sh
    cd frontend
    ```

2. Install the frontend dependencies:

    ```sh
    npm install
    ```

3. Start the development server:

    ```sh
    npm start
    ```

    The application should now be running on `http://localhost:3000`.

## Testing

1. To run the tests, execute:

    ```sh
    npx hardhat test
    ```

    Ensure all tests pass before deploying to the live network.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements.

