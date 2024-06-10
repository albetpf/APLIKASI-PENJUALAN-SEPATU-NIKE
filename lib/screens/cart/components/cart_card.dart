import 'package:flutter/material.dart';
import 'package:tugas_uasppb/screens/cart/cart_screen.dart';
import 'package:tugas_uasppb/models/Cart.dart';

class CartCard extends StatelessWidget {
  final Cart cart;
  final VoidCallback onIncrement;
  final VoidCallback onDelete;

  const CartCard({
    Key? key,
    required this.cart,
    required this.onIncrement,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 247, 245, 245), Color.fromARGB(255, 164, 164, 164)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 83, 83, 83).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 9,
            offset: const Offset(0, 5), 
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.product.title,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: formatRupiah(cart.product.price),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.green),
                  children: [
                    TextSpan(
                        text: " x${cart.quantity}",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: onIncrement,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
