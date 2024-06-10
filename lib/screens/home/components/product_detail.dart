// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:tugas_uasppb/sqlite/database_helper.dart';
import 'package:tugas_uasppb/models/Product.dart';
import 'package:tugas_uasppb/models/Cart.dart';
import 'package:tugas_uasppb/screens/cart/cart_screen.dart';

class ShoesDetail extends StatefulWidget {
  final String image;
  final String tag;
  final String title;
  final String brand;
  final String price;

  const ShoesDetail({
    Key? key,
    required this.image,
    required this.tag,
    required this.title,
    required this.brand,
    required this.price,
  }) : super(key: key);

  @override
  _ShoesDetailState createState() => _ShoesDetailState();
}

class _ShoesDetailState extends State<ShoesDetail> {
  void addToCart(BuildContext context) async {
    final dbHelper = DatabaseHelper.instance;

    // Function to convert price string to double
    double convertPrice(String price) {
      String sanitizedPrice = price.replaceAll('Rp.', '').replaceAll(',', '').replaceAll('.', '');
      return double.parse(sanitizedPrice) / 100;
    }

    double price = convertPrice(widget.price);

    // URL gambar yang digunakan
    String imageUrl = 'https://665ff4215425580055b17cbd.mockapi.io/detail_produk';
    print("Image URL used for product: $imageUrl"); // Debug print

    Product product = Product(
      id: DateTime.now().millisecondsSinceEpoch, // Using timestamp as a unique ID
      title: widget.title,
      description: widget.brand,
      images: [imageUrl], // Use the provided URL
      price: price,
    );

    Cart cartItem = Cart(product: product, quantity: 1);
    await dbHelper.insertCartItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to cart'),
        duration: Duration(seconds: 1),
      ),
    );

    // Navigate to CartScreen after adding to cart
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: widget.tag,
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.1,
                maxScale: 3.0,
                child: Image.network(
                  widget.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.brand,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color.fromARGB(255, 26, 41, 81), Color.fromARGB(255, 20, 60, 131)],
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: const Text(
                            'Check Out',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}