// import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final List<String> images;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: int.parse(map['id']),
      title: map['title'],
      description: map['description'] ?? '',
      images: List<String>.from(map['images']),
      price: double.parse(map['price'].toString().replaceAll('.', '').replaceAll(',', '.')),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images.join(','),
      'price': price,
    };
  }
}
