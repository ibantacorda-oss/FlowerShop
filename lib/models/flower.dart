class Flower {
  final String name;
  final double price;
  final String image;

  Flower({
    required this.name,
    required this.price,
    required this.image,
  });
}

class CartItem {
  final Flower flower;
  int quantity;

  CartItem({
    required this.flower,
    this.quantity = 1,
  });

  double get total {
    return flower.price * quantity;
  }
}