import React, { useState } from "react";
import { useAccount, useConnect, useDisconnect } from "wagmi";
import { injected } from "wagmi/connectors";

function App() {
  const account = useAccount();
  const { connect } = useConnect({ connector: new injected() });
  const { disconnect } = useDisconnect();

  const [producerName, setProducerName] = useState("");
  const [productName, setProductName] = useState("");
  const [productPrice, setProductPrice] = useState(0);
  const [productQuantity, setProductQuantity] = useState(0);
  const [customerName, setCustomerName] = useState("");
  const [deliveryAddress, setDeliveryAddress] = useState("");
  const [productId, setProductId] = useState(0);
  const [orderQuantity, setOrderQuantity] = useState(0);

  const [contract, setContract] = useState(null);

  const connectWallet = async () => {
    if (!account.isConnected) {
      connect();
    } else {
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const abi = [ ... ]; // Paste your ABI here
      const contractAddress = "YOUR_CONTRACT_ADDRESS"; // Replace
      const myContract = new ethers.Contract(contractAddress, abi, signer);
      setContract(myContract);
    }
  };

  const handleRegisterProducer = async () => {
    await contract.registerProducer(producerName);
  };

  const handleAddProduct = async () => {
    await contract.addProduct(productName, productPrice, productQuantity);
  };

  const handlePlaceOrder = async () => {
    await contract.placeOrder(customerName, deliveryAddress, productId, orderQuantity);
  };

  return (
    <div>
      <h1>Farm to Chain</h1>
      <button onClick={connectWallet}>
        {account.isConnected ? "Connected" : "Connect Wallet"}
      </button>

      {account.isConnected && (
        <>
          <section>
            <h2>Register as Producer</h2>
            <input value={producerName} onChange={(e) => setProducerName(e.target.value)} placeholder="Producer Name" />
            <button onClick={handleRegisterProducer}>Register</button>
          </section>

          <section>
            <h2>Add Product</h2>
            <input value={productName} onChange={(e) => setProductName(e.target.value)} placeholder="Product Name" />
            <input type="number" value={productPrice} onChange={(e) => setProductPrice(parseInt(e.target.value))} placeholder="Price" />
            <input type="number" value={productQuantity} onChange={(e) => setProductQuantity(parseInt(e.target.value))} placeholder="Quantity" />
            <button onClick={handleAddProduct}>Add Product</button>
          </section>

          <section>
            <h2>Place Order</h2>
            <input value={customerName} onChange={(e) => setCustomerName(e.target.value)} placeholder="Your Name" />
            <input value={deliveryAddress} onChange={(e) => setDeliveryAddress(e.target.value)} placeholder="Delivery Address" />
            <input type="number" value={productId} onChange={(e) => setProductId(parseInt(e.target.value))} placeholder="Product ID" />
            <input type="number" value={orderQuantity} onChange={(e) => setOrderQuantity(parseInt(e.target.value))} placeholder="Quantity" />
            <button onClick={handlePlaceOrder}>Place Order</button>
          </section>
        </>
      )}
    </div>
  );
}

export default App;