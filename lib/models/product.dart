class Product {
  final int? id;
  final String marketKey;
  final String name;
  final String size;
  final double price;
  final double? wholesalePrice;
  final String imagePath;
  final String imageSignature; // بصمة رقمية للصورة للتعرف التلقائي

  Product({
    this.id,
    required this.marketKey,
    required this.name,
    required this.size,
    required this.price,
    this.wholesalePrice,
    required this.imagePath,
    required this.imageSignature,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'marketKey': marketKey,
    'name': name,
    'size': size,
    'price': price,
    'wholesalePrice': wholesalePrice,
    'imagePath': imagePath,
    'imageSignature': imageSignature,
  };

  factory Product.fromMap(Map<String, dynamic> m) => Product(
    id: m['id'],
    marketKey: m['marketKey'],
    name: m['name'],
    size: m['size'],
    price: m['price'],
    wholesalePrice: m['wholesalePrice'],
    imagePath: m['imagePath'],
    imageSignature: m['imageSignature'],
  );
}