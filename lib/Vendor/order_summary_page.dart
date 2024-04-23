import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({Key? key}) : super(key: key);

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todays Order'),
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

          // Calculate total quantity of each item
          Map<String, int> itemQuantities = {};
          snapshot.data!.docs.forEach((order) {
            String itemId = order['item_id'];
            int quantity = order['quantity'];
            itemQuantities.update(itemId, (value) => value + quantity, ifAbsent: () => quantity);
          });

          // Build the DataTable with item IDs and quantities
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Item ID')),
                DataColumn(label: Text('Item Name')),
                DataColumn(label: Text('Total Quantity')),
              ],
              rows: itemQuantities.entries.map((entry) {
                String itemId = entry.key;
                int totalQuantity = entry.value;

                // Get the item name from the order document
                String itemName = snapshot.data!.docs.firstWhere((doc) => doc['item_id'] == itemId)['item_name'];

                return DataRow(cells: [
                  DataCell(Text(itemId)),
                  DataCell(Text(itemName)),
                  DataCell(Text(totalQuantity.toString())),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
