// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MyContract {
    // Producer list
    mapping(address => string) public producers;

    // Products
    uint256 public totalProduct = 0;
    struct Product {
        uint256 id;
        uint256 price;
        uint256 quantity;
        string name;
        address producerAddress;
    }
    mapping(uint256 => Product) public products;

    // Orders
    uint256 public totalOrder = 0;
    struct Order {
        uint256 id;
        uint256 productId;
        uint256 quantity;
        string customerName;
        string status;
        string deliveryAddress;
        address customerAddress;
    }
    mapping(uint256 => Order) public orders;

    // Events
    event ProducerRegistered(address indexed producer, string name);
    event ProductAdded(uint256 productId, string name, uint256 price, address producer);
    event OrderPlaced(uint256 orderId, address customer);

    // Modifiers
    modifier onlyUnregisteredProducer() {
        require(bytes(producers[msg.sender]).length == 0, "Already registered");
        _;
    }

    modifier onlyRegisteredProducer() {
        require(bytes(producers[msg.sender]).length > 0, "Not registered");
        _;
    }

    // Register producer
    function registerProducer(string memory _name) public onlyUnregisteredProducer {
        producers[msg.sender] = _name;
        emit ProducerRegistered(msg.sender, _name);
    }

    // Add product
    function addProduct(string memory _name, uint256 _price, uint256 _quantity) public onlyRegisteredProducer {
        totalProduct += 1;
        products[totalProduct] = Product(
            totalProduct,
            _price,
            _quantity,
            _name,
            msg.sender
        );
        emit ProductAdded(totalProduct, _name, _price, msg.sender);
    }

    // Place order
    function placeOrder(
        string memory _customerName,
        string memory _deliveryAddress,
        uint256 _productId,
        uint256 _quantity
    ) public {
        Product storage product = products[_productId];
        require(product.quantity >= _quantity, "Insufficient stock");

        product.quantity -= _quantity;
        totalOrder += 1;
        orders[totalOrder] = Order(
            totalOrder,
            _productId,
            _quantity,
            _customerName,
            "Placed",
            _deliveryAddress,
            msg.sender
        );
        emit OrderPlaced(totalOrder, msg.sender);
    }

    // Get product by ID
    function getProductById(uint256 _productId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            string memory,
            address
        )
    {
        Product memory p = products[_productId];
        return (p.id, p.price, p.quantity, p.name, p.producerAddress);
    }

    // Get order by ID
    function getOrderById(uint256 _orderId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            string memory,
            string memory,
            string memory,
            address
        )
    {
        Order memory o = orders[_orderId];
        return (o.id, o.productId, o.quantity, o.customerName, o.status, o.deliveryAddress, o.customerAddress);
    }

    // Update order status
    function updateOrderStatus(uint256 _orderId, string memory _status) public {
        Order storage o = orders[_orderId];
        Product storage p = products[o.productId];

        require(p.producerAddress == msg.sender, "Only producer can update status");

        if (keccak256(bytes(_status)) == keccak256(bytes("Rejected"))) {
            p.quantity += o.quantity;
        }

        o.status = _status;
    }
}