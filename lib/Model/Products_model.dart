class Product {
  String title;
  String price;
  String description;
  String category;
  String image;
  String barcode;
  int stock;

  Product({
    required this.title,
    required this.barcode,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
  });
}
