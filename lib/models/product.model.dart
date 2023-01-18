class Product {
  int min;
  int max;
  String id;
  double price;

  Product({this.id, this.max, this.min, this.price});

  factory Product.fromDoc(Map<String, dynamic> doc) {
    return Product(
      id: doc["id"],
      min: doc["min"],
      max: doc["max"],
      price: doc["price"],
    );
  }
}
