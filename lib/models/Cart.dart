import 'package:tugas_uasppb/models/Product.dart';

class Cart {
  final Product product;
  int quantity;

  Cart({
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'title': product.title,
      'description': product.description,
      'images': product.images.join(','), 
      'price': product.price,
      'quantity': quantity,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      product: Product.fromMap(map),
      quantity: map['quantity'],
    );
  }
}
