// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract kart {
    uint public counter = 1;
    struct Product {
        uint productId;

        string desc;
        string title;
        address payable seller;
        address buyer;
        bool delivered;
        uint price; // in ether
    }
    Product[] public products;
    //events
    event registered(string title,uint productId);
    event bought(uint productId, address buyer);
    event delivery(uint productId);
    // Seller has to register and create product
    function register(string memory _title,string memory _desc, uint _price) public {
        require(_price > 0,"Price cannot be less than equal to 0");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter;
        products.push(tempProduct);
        counter++; // counter = counter +1;
        emit registered(tempProduct.title,tempProduct.productId);
    }
    // Buyer will pay and buy the product
    function buy(uint _productId) payable public {
        // seller should not buy himself
        require(products[_productId - 1].seller != msg.sender,"Seller cannot buy");
        // buyer should transfer the price of the product
        require(msg.value == products[_productId - 1].price * 10**18);
        products[_productId - 1].buyer = msg.sender;
        emit bought(_productId,msg.sender);
    }
    // Buyer confirms delivery and contract will pay to seller
    function delivered(uint _productId) public {
        //only buyer can call this function
        Product memory tempProduct = products[_productId - 1];
        require(tempProduct.buyer == msg.sender,"Only buyer should call this");
        tempProduct.delivered = true;
        products[_productId-1]=tempProduct;
        tempProduct.seller.transfer(tempProduct.price * 10**18);
        emit delivery(_productId);
    }
}
