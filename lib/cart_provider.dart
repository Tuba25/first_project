// cart_provider.dart
import 'package:flutter/material.dart';
import 'package:first_project/OrderHistoryProvider.dart';

class CartItem {
  final String name;
  final double price;

  CartItem({required this.name, required this.price});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(0, (total, item) => total + item.price);

  void addItem(String name, double price) {
    _items.add(CartItem(name: name, price: price));
    notifyListeners(); // Notify listeners about the change
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners(); // Notify listeners about the change
  }

  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify listeners about the change
  }
}
