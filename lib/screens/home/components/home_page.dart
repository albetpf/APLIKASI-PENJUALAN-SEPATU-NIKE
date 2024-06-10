import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../cart/cart_screen.dart';
import 'icon_btn_with_counter.dart';
import 'package:tugas_uasppb/screens/home/components/product_detail.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://665ff4215425580055b17cbd.mockapi.io/detail_produk'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _products = data;
        _isLoading = false;
      });
      print('Products fetched: $_products');
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Toko Sepatu Nike",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
        actions: <Widget>[
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            size: 22,
            press: () => Navigator.pushNamed(context, CartScreen.routeName),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildBanner(),
                  const SizedBox(height: 30),
                  ..._products.map((product) => _buildShoeItem(
                        style: const TextStyle(color: Colors.black, fontSize: 25),
                        image: product['image'],
                        tag: product['id'].toString(),
                        context: context,
                        title: product['title'],
                        brand: product['brand'],
                        price: 'Rp.${product['price']}',
                      )),
                ],
              ),
            ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 55,
        vertical: 70,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 50, 137, 152),
        borderRadius: BorderRadius.circular(40),
        image: const DecorationImage(
          image: AssetImage('lib/assets/banner2.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildShoeItem({
    required String image,
    required String tag,
    required BuildContext context,
    required String title,
    required String brand,
    required String price,
    required TextStyle style,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoesDetail(image:image, tag: tag, title: title, brand: brand, price: price)),
        );
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 50,
                  );
                },
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    brand,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 90,
              left: 20,
              child: Text(
                price,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
