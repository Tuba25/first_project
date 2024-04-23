//order_history.dart
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> orderDetails;

  OrderHistoryPage({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        itemCount: orderDetails.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              child: ListTile(
                title: Text('Date: ${DateTime.now().toString().substring(0, 10)}'), // Using current date for demonstration
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Items: ${orderDetails[index]["name"]}'),
                    Text('Total: \$${orderDetails[index]["price"]}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

