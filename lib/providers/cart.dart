import 'package:flutter/foundation.dart';

class CartItemData {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItemData(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});

  get toPay => price * quantity;
}

class Cart with ChangeNotifier {
  Map<String, CartItemData> _items = {};

  Map<String, CartItemData> get items {
    return {..._items};
  }

  get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    _items.putIfAbsent(
      productId,
      () => CartItemData(
        id: productId,
        title: title,
        price: price,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void removeCartItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  /// to decrement quantity of cart item
  void decrementCartItemCount(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItemData(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: --existingCartItem.quantity));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  /// to increment quantity of cart item
  void incrementCartItemCount(String productId) {
    if (!_items.containsKey(productId))
      return;
    else
      _items.update(
          productId,
          (existingCartItem) => CartItemData(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: ++existingCartItem.quantity));
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
