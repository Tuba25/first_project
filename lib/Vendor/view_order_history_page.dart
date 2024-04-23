import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrderHistoryPage extends StatefulWidget {
  const ViewOrderHistoryPage({Key? key}) : super(key: key);

  @override
  _ViewOrderHistoryPageState createState() => _ViewOrderHistoryPageState();
}

class _ViewOrderHistoryPageState extends State<ViewOrderHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var order = snapshot.data!.docs[index];
                    var orderDateTime = order['order_datetime'] as Timestamp;
                    var orderDate = orderDateTime.toDate();

                    return Card(
                      child: ListTile(
                        title: Text('Order ID: ${order.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Date: ${orderDate.toString()}'),
                            Text('Item ID: ${order['item_id']}'),
                            Text('User ID: ${order['user_id']}'),
                            Text('Item Name: ${order['item_name']}'),
                            Text('Quantity: ${order['quantity']}'),
                            Text('Unit Price: ${order['unit_price']}'),
                            Text('Total Price: ${order['total_price']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
