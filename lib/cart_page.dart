import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'OrderHistoryProvider.dart';
import 'order_history.dart';
import 'cart_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeItem(index);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return BottomAppBar(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logic to confirm order
                      List<Map<String, dynamic>> orderDetails = [];
                      for (var item in cart.items) {
                        orderDetails.add({
                          "name": item.name,
                          "price": item.price,
                        });
                      }
                      // Show confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Order Confirmed'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      // Add order details to history
                      Provider.of<OrderHistoryProvider>(context, listen: false)
                          .addOrder(orderDetails);
                      // Clear the cart
                      Provider.of<CartProvider>(context, listen: false)
                          .clearCart();
                    },
                    child: Text('Confirm Order'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

