import 'package:flutter/material.dart';

class OrderHistoryProvider extends ChangeNotifier {
  final List<List<Map<String, dynamic>>> _orderHistory = [];

  List<List<Map<String, dynamic>>> get orderHistory => _orderHistory;

  void addOrder(List<Map<String, dynamic>> orderDetails) {
    _orderHistory.add(orderDetails);
    notifyListeners(); // Notify listeners about the change
  }

  void clearOrderHistory() {
    _orderHistory.clear();
    notifyListeners(); // Notify listeners about the change
  }
}
