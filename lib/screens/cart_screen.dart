import 'package:flutter/material.dart';
import '../models/flower.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double get total {
    return widget.cart.fold(
      0,
      (sum, item) => sum + item.flower.price * item.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Your Cart 🛒"),
      ),

      body: Column(
        children: [

          /// CART ITEMS
          Expanded(
            child: widget.cart.isEmpty
                ? const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {

                      final item = widget.cart[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(10),

                          child: Row(
                            children: [

                              /// FLOWER IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.flower.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// FLOWER INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      item.flower.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "\$${item.flower.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Subtotal: \$${(item.flower.price * item.quantity).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              /// QUANTITY CONTROLS
                              Row(
                                children: [

                                  IconButton(
                                    icon: const Icon(Icons.remove),

                                    onPressed: () {
                                      setState(() {

                                        if (item.quantity > 1) {
                                          item.quantity--;
                                        } else {
                                          widget.cart.removeAt(index);
                                        }

                                      });
                                    },
                                  ),

                                  Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.add),

                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// CHECKOUT SECTION
          Container(

            padding: const EdgeInsets.all(16),

            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
              ),
            ),

            child: Column(
              children: [

                /// TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15),

                /// CHECKOUT BUTTON
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: widget.cart.isEmpty
                        ? null
                        : () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  cart: widget.cart,
                                ),
                              ),
                            );

                          },

                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(fontSize: 16),
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