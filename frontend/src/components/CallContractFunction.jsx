const registerProducer = async () => {
  if (contract) {
    const tx = await contract.registerProducer("Farmer Joe");
    await tx.wait();
    alert("Producer registered!");
  }
};