const metadata = {
  name: "Organic Apple",
  description: "Freshly picked apple from farm",
  image: "ipfs://Qm...",
};

const response = await fetch("https://ipfs.infura.io:5001/api/v0/add",  {
  method: "POST",
  headers: {
    Authorization: `Basic ${Buffer.from(
      `${INFURA_PROJECT_ID}:${INFURA_SECRET}`
    ).toString("base64")}`,
  },
  body: JSON.stringify(metadata),
});

const ipfsHash = response.json().Hash; // ipfs://Qm...