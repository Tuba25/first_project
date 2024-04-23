import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'expand.dart'; // Import ExpandPage.dart
import 'cart_page.dart'; // Import CartPage.dart
import 'models/categories.dart';
import 'models/menu_option.dart';
import 'order_history.dart'; // Import OrderHistoryPage.dart

class MenuOptions {
  static const home = MenuOption(Icons.home, "Home");
  static const cart = MenuOption(Icons.shopping_cart, "My Cart");
  static const order = MenuOption(Icons.today, "Order History");
  static const promo = MenuOption(Icons.description, "Enter Promo Code");
  static const wallet = MenuOption(Icons.account_balance_wallet, "Wallet");
  static const favorite = MenuOption(Icons.star, "Favorites");
  static const faq = MenuOption(Icons.help, "FAQs");
  static const support = MenuOption(Icons.phone, "Help");
  static const setting = MenuOption(Icons.settings, "Setting");
  static const logout = MenuOption(Icons.logout, "Logout");

  static const allOptions = [
    home,
    cart,
    order,
    promo,
    wallet,
    favorite,
    faq,
    support,
    setting,
    logout,
  ];
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[400],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Builder(
              builder: (context) {
                return InkWell(
                  onTap: () {
                    if (ZoomDrawer.of(context) != null) {
                      ZoomDrawer.of(context)!.close();
                    }
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: const [
                    Text(
                      "Hello,",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Justin",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...MenuOptions.allOptions.map((option) {
            if (option == MenuOptions.cart) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
                leading: Icon(
                  option.icon,
                  color: Colors.black,
                ),
                title: Text(option.title),
                minLeadingWidth: 10,
              );
            } else if (option == MenuOptions.order) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHistoryPage(orderDetails: [],)),
                  );
                },
                leading: Icon(
                  option.icon,
                  color: Colors.black,
                ),
                title: Text(option.title),
                minLeadingWidth: 10,
              );
            } else if (option == MenuOptions.home) {
              return ListTile(
                onTap: () {
                  // Navigate to Home or any other page
                },
                leading: Icon(
                  option.icon,
                  color: Colors.black,
                ),
                title: Text(option.title),
                minLeadingWidth: 10,
              );
            } else {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpandPage(category: Categories(text: option.title, image: ''))),
                  );
                },
                leading: Icon(
                  option.icon,
                  color: Colors.black,
                ),
                title: Text(option.title),
                minLeadingWidth: 10,
              );
            }
          }).toList(),
        ],
      ),
    );
  }
}
