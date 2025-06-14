const { expect } = require("chai");

describe("MyContract", function () {
  let myContract;
  let owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    const MyContract = await ethers.getContractFactory("MyContract");
    myContract = await MyContract.deploy();
    await myContract.waitForDeployment();
  });

  it("Should register a producer", async function () {
    await myContract.connect(addr1).registerProducer("Farmer Joe");
    expect(await myContract.producers(addr1.address)).to.equal("Farmer Joe");
  });

  it("Should allow producer to add product", async function () {
    await myContract.connect(addr1).registerProducer("Organic Farm");
    await myContract.connect(addr1).addProduct("Apple", 100, 50);
    const product = await myContract.products(1);
    expect(product.name).to.equal("Apple");
    expect(product.price).to.equal(100);
    expect(product.quantity).to.equal(50);
  });

  it("Should allow customer to place order", async function () {
    await myContract.connect(addr1).registerProducer("Organic Farm");
    await myContract.connect(addr1).addProduct("Apple", 100, 50);

    await myContract.connect(addr2).placeOrder("Alice", "123 Main St", 1, 5);
    const order = await myContract.orders(1);
    expect(order.customerName).to.equal("Alice");
    expect(order.quantity).to.equal(5);
  });
});