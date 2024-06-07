class Welcome {
  Welcome({
    required this.product,
  });

  final List<Product> product;

  factory Welcome.fromJson(Map<String, dynamic> json) {
    return Welcome(
      product: List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "product": List<dynamic>.from(product.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    required this.price,
    required this.image,
    required this.name,
    required this.offerprice,
    required this.productPrice,
  });

  final String? price;
  final String? image;
  final String? name;
  final String? offerprice;
  final String? productPrice;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      price: json["Price"],
      image: json["image"],
      name: json["name"],
      offerprice: json["offerprice"],
      productPrice: json["price"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Price": price,
    "image": image,
    "name": name,
    "offerprice": offerprice,
    "price": productPrice,
  };
}
