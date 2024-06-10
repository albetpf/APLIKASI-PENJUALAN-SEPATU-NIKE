import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_uasppb/models/Cart.dart';
import 'package:tugas_uasppb/models/Product.dart';
import 'package:tugas_uasppb/sqlite/database_helper.dart';
import 'package:tugas_uasppb/screens/cart/components/cart_card.dart';
import 'package:tugas_uasppb/screens/cart/components/check_out_card.dart';
import 'package:tugas_uasppb/screens/home/home_screen.dart';

// Function to format price to Rupiah
String formatRupiah(double price) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 2);
  return formatter.format(price);
}

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> demoCarts = [];
  bool _checkoutComplete = false;
  List<Cart> checkedOutItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final dbHelper = DatabaseHelper.instance;
    List<Cart> cartItems = await dbHelper.getCartItems();
    setState(() {
      demoCarts = cartItems;
    });
  }

  double calculateTotalPrice(List<Cart> items) {
    double total = 0.0;
    for (var cart in items) {
      total += cart.product.price * cart.quantity;
    }
    return total;
  }

  void _incrementQuantity(int index) {
    setState(() {
      demoCarts[index].quantity++;
    });
    final dbHelper = DatabaseHelper.instance;
    dbHelper.updateCartItem(demoCarts[index]);
  }

  void _addItemToCart(Product product) {
    final existingCartItemIndex = demoCarts.indexWhere((cart) => cart.product.title == product.title);
    if (existingCartItemIndex != -1) {
      _incrementQuantity(existingCartItemIndex);
    } else {
      setState(() {
        demoCarts.add(Cart(product: product));
      });
      final dbHelper = DatabaseHelper.instance;
      dbHelper.insertCartItem(Cart(product: product));
    }
  }

  void _deleteItem(int index) {
    final dbHelper = DatabaseHelper.instance;
    dbHelper.deleteCartItem(demoCarts[index].product.id);
    setState(() {
      demoCarts.removeAt(index);
    });
  }

  void _handleCheckout() {
    setState(() {
      checkedOutItems = List.from(demoCarts);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lanjutkan Pembayaran?'),
          content: const Text('Apakah Anda ingin melanjutkan pembayaran?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper.instance;
                await dbHelper.clearCart();
                setState(() {
                  demoCarts.clear();
                  _checkoutComplete = true;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pembayaran berhasil!'),
                  ),
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, demoCarts.length),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/2background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _checkoutComplete
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Pembayaran berhasil!',
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24, // Increase the font size for emphasis
                                    ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Slip Pembayaran',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22, // Increase the font size for emphasis
                                    ),
                              ),
                              const SizedBox(height: 15),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: checkedOutItems.length,
                                itemBuilder: (context, index) {
                                  final item = checkedOutItems[index];
                                  return ListTile(
                                    title: Text(item.product.title),
                                    subtitle: Text('${item.quantity} x ${formatRupiah(item.product.price)}'),
                                    trailing: Text(formatRupiah(item.product.price * item.quantity)),
                                  );
                                },
                              ),
                              const Divider(),
                              ListTile(
                                title: const Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  formatRupiah(calculateTotalPrice(checkedOutItems)),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeScreen.routeName,
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 20, 41, 98),
                          padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: ListView.builder(
                  itemCount: demoCarts.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CartCard(
                        cart: demoCarts[index],
                        onIncrement: () => _incrementQuantity(index),
                        onDelete: () => _deleteItem(index),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: demoCarts.isNotEmpty && !_checkoutComplete
          ? CheckOutCard(
              totalPrice: calculateTotalPrice(demoCarts),
              onCheckout: _handleCheckout,
            )
          : null,
    );
  }

  AppBar buildAppBar(BuildContext context, int itemCount) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Changed to white
      elevation: 2,
      title: Column(
        children: [
          const Text(
            "Keranjang Saya",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Changed to black for contrast
          ),
          Text(
            "$itemCount items",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color.fromARGB(255, 0, 0, 0)), // Changed to black for contrast
          ),
        ],
      ),
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)), // Changed to black for contrast
    );
  }
}
