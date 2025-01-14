pragma solidity ^0.5.0;

contract Marketplace {
  string public name;
  uint public productCount=0;
  mapping(uint => Product) public products;
  address payable contractOwner;


struct Product {
  uint id;
  string name;
  uint price;
  address payable owner;
  bool active;
}

event ProductCreated (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool active
);

event ProductPurchased (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool active
);

event ProductEdited (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool active
);

  constructor() public {
    name = "Dapp University Marketplace";
    contractOwner = 0xE93B1c48A9dc33f0AEb5ffFA76de8A73109Ea1ca;
  }

  function createProduct(string memory _name, uint _price) public {
    //Require a name
    require(bytes(_name).length > 0, "Enter a valid name");
    //Requiere a valid price
    require(_price > 0, "Enter a valid price");
    //Increment product count
    productCount++;
    //Create the product
    products[productCount] = Product(productCount, _name, _price, msg.sender, true);
    //Trigger an event
    emit ProductCreated(productCount, _name, _price, msg.sender, true);
  }

  function purchaseProduct(uint _id) public payable {
    //Fetch the product and make a copy of it
    Product memory _product = products[_id];
    //Fetch the owner
    address payable _seller = _product.owner;
    //Make sure the product has valid id
    require(_product.id > 0 && _product.id <= productCount, "Enter valid id");
    //Require that there is enough Ether in the transaction
    require(msg.value >= _product.price,"Transfer the correct amount");
    //Require that the product has not been purchased already
    //require(!_product.purchased, "Product has been purchased");
    //Require that the buyer is not the seller
    require(msg.sender != _seller, "Buyer cannot be seller");
    require(_product.active, "Product not active");
    //Transfer ownership to the buyer
    _product.owner = msg.sender;
    //Mark as purchased
    //_product.purchased = true;
    //Update the product
    products[_id] = _product;
    //Pay the seller by sending them Ether
    //address(_seller).transfer(msg.value);
    address(_seller).transfer((msg.value * 95) / 100);
    address(contractOwner).transfer((msg.value * 5) / 100);

    //Trigger an event
    emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
  }

  function editProductPrice(uint _id, uint _price) public payable {
    //Fetch the product and make a copy of it
    Product memory _product = products[_id];
    //Fetch the owner
    address payable _seller = _product.owner;
    //Make sure the product has valid id
    require(_product.id > 0 && _product.id <= productCount, "Enter valid id");
    //Require that the buyer is not the seller
    require(msg.sender == _seller, "Product can only be edit by owner");
    //Mark as purchased
    _product.price = _price;
    //Update the product
    products[_id] = _product;

    //Trigger an event
    emit ProductEdited(productCount, _product.name, _product.price, msg.sender, true);
  }

  function editProductActive(uint _id, bool _active) public payable {
    //Fetch the product and make a copy of it
    Product memory _product = products[_id];
    //Fetch the owner
    address payable _seller = _product.owner;
    //Make sure the product has valid id
    require(_product.id > 0 && _product.id <= productCount, "Enter valid id");
    //Require that the buyer is not the seller
    require(msg.sender == _seller, "Product can only be edit by owner");
    //Mark as purchased
    _product.active = _active;
    //Update the product
    products[_id] = _product;

    //Trigger an event
    emit ProductEdited(productCount, _product.name, _product.price, msg.sender, true);
  }
}