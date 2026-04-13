import 'package:flutter/material.dart';
import '../models/flower.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CartItem> cart = [];

  final List<Flower> flowerList = [
    Flower(
      name: "Emilia",
      price: 1899.99,
      image: "lib/assets/images/emilia.webp",
    ),
    Flower(
      name: "Pixie Dream",
      price: 2199.99,
      image: "lib/assets/images/pixiedream.webp",
    ),
    Flower(
      name: "Liliana",
      price: 1599.99,
      image: "lib/assets/images/liliana.webp",
    ),
    Flower(
      name: "Love in Full Bloom (50 roses)",
      price: 2999.99,
      image: "lib/assets/images/50 roses.webp",
    ),
    Flower(
      name: "Delicate Dream",
      price: 2299.99,
      image: "lib/assets/images/Delicate Dream.webp",
    ),
    Flower(
      name: "Sunset Love",
      price: 1499.99,
      image: "lib/assets/images/Sunset Love.webp",
    ),
  ];

  void addToCart(Flower flower) {
    final index =
        cart.indexWhere((item) => item.flower.name == flower.name);

    setState(() {
      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(flower: flower));
      }
    });
  }

  int get cartCount =>
      cart.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdf6f9),

      appBar: AppBar(
        backgroundColor: const Color(0xff6A1B9A),
        elevation: 6,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "FLOWER BOUTIQUE",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Premium Collection",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 3,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

   
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount =
                constraints.maxWidth < 600 ? 1 : 2;

            return GridView.builder(
              itemCount: flowerList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.78, 
              ),
              itemBuilder: (context, index) {
                final flower = flowerList[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(12),
                          child: Image.asset(
                            flower.image,
                            fit: BoxFit
                                .contain, 
                          ),
                        ),
                      ),

                     
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 14),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              flower.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "\$${flower.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width:
                                  double.infinity,
                              child: ElevatedButton(
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      const Color(
                                          0xff6A1B9A),
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                          vertical:
                                              12),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                20),
                                  ),
                                ),
                                onPressed: () =>
                                    addToCart(
                                        flower),
                                child: const Text(
                                  "Add to Cart",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),

    
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CartScreen(cart: cart),
                ),
              );
            },
            child:
                const Icon(Icons.shopping_cart),
          ),
          if (cartCount > 0)
            Positioned(
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.all(6),
                decoration:
                    const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cartCount.toString(),
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}