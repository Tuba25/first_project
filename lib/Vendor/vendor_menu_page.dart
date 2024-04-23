import 'package:flutter/material.dart';
import '../models/menu_option.dart';
import 'vendor_home_page.dart';
import 'view_order_history_page.dart';
import 'order_summary_page.dart';
import 'update_category_page.dart';
import 'update_food_item_page.dart';

class VendorMenuPage extends StatefulWidget {
  const VendorMenuPage({Key? key}) : super(key: key);

  @override
  State<VendorMenuPage> createState() => _VendorMenuPageState();
}

class _VendorMenuPageState extends State<VendorMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      "Vendor",
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
          ...VendorMenuOptions.allOptions.map((option) {
            return ListTile(
              onTap: () {
                // Handle navigation based on the selected option
                if (option == VendorMenuOptions.home) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorHomePage()),
                  );
                } else if (option == VendorMenuOptions.orderHistory) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewOrderHistoryPage()),
                  );
                } else if (option == VendorMenuOptions.todayOrderSummary) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderSummaryPage()),
                  );
                } else if (option == VendorMenuOptions.updateCategory) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateCategoryPage()),
                  );
                } else if (option == VendorMenuOptions.updateFoodItems) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateFoodItemPage()),
                  );
                } else if (option == VendorMenuOptions.settings) {
                  // Navigate to Settings page
                } else if (option == VendorMenuOptions.logout) {
                  // Navigate to Logout
                } else {
                  // Default case: Navigate back to home page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorHomePage()),
                  );
                }
              },
              leading: Icon(
                option.icon,
                color: Colors.black,
              ),
              title: Text(option.title),
              minLeadingWidth: 10,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class VendorMenuOptions {
  static const home = MenuOption(Icons.home, "Home");
  static const orderHistory = MenuOption(Icons.history, "Order History");
  static const todayOrderSummary = MenuOption(Icons.calendar_today, "Today's Order Summary");
  static const updateCategory = MenuOption(Icons.category, "Update Category");
  static const updateFoodItems = MenuOption(Icons.fastfood, "Update Food Items");
  static const settings = MenuOption(Icons.settings, "Settings");
  static const logout = MenuOption(Icons.logout, "Logout");

  static const allOptions = [
    home,
    orderHistory,
    todayOrderSummary,
    updateCategory,
    updateFoodItems,
    settings,
    logout,
  ];
}
