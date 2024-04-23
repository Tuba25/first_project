import 'package:flutter/material.dart';
import 'package:first_project/models/categories.dart';
import 'package:provider/provider.dart';
import 'package:first_project/cart_provider.dart';
import 'package:first_project/cart_page.dart';

class ExpandPage extends StatelessWidget {
  final Categories category;

  ExpandPage({required this.category});

  final List<Map<String, dynamic>> categoryItems = [
    {
      'name': 'Item 1',
      'image':
      'https://c4.wallpaperflare.com/wallpaper/741/599/723/pizza-food-vegetables-fruit-wallpaper-preview.jpg',
      'price': 10.99,
    },
    {
      'name': 'Item 2',
      'image':
      'https://c4.wallpaperflare.com/wallpaper/197/854/431/fire-burger-5k-steak-wallpaper-preview.jpg',
      'price': 12.99,
    },
    {
      'name': 'Item 3',
      'image':
      'https://c4.wallpaperflare.com/wallpaper/667/1010/485/food-sausage-sandwiches-wallpaper-preview.jpg',
      'price': 8.99,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.text),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: categoryItems.length,
              itemBuilder: (context, index) {
                final item = categoryItems[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          item['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text('\$${item['price']}'),
                          ],
                        ),
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final itemCount = cart.items
                              .where((cartItem) => cartItem.name == item['name'])
                              .length;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: itemCount > 0
                                    ? () {
                                  Provider.of<CartProvider>(context,
                                      listen: false)
                                      .removeItem(item['name']);
                                }
                                    : null,
                              ),
                              Text(itemCount.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  Provider.of<CartProvider>(context,
                                      listen: false)
                                      .addItem(item['name'], item['price']);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              child: Text('View Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
