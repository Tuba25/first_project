import 'package:flutter/material.dart';
import 'package:first_project/Vendor/vendor_food_page.dart';
import 'package:first_project/Vendor/add_food_item_page.dart';
import 'package:first_project/Vendor/view_order_history_page.dart';
import 'package:first_project/Vendor/order_summary_page.dart';
import 'package:first_project/Vendor/vendor_login_page.dart';
import 'package:first_project/Vendor/vendor_menu_page.dart'; // Import vendor_menu_page.dart

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key? key}) : super(key: key);

  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Vendor Home Page'),
        backgroundColor: Colors.amberAccent[400],
      ),
      drawer: MenuDrawer(), // Use MenuDrawer instead of Drawer
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'lib/Vendor/asset/food_app_front.jpg',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome, Vendor",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Text(
                "Manage Your Foods and Orders",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  HomeCardButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VendorFoodPage()),
                      );
                    },
                    label: 'Add Food Category',
                    icon: Icons.fastfood,
                    color: Colors.amberAccent[400]!,
                  ),
                  HomeCardButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddFoodItemPage()),
                      );
                    },
                    label: 'Add Food Item',
                    icon: Icons.add,
                    color: Colors.amberAccent[400]!,
                  ),
                  HomeCardButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewOrderHistoryPage()),
                      );
                    },
                    label: 'View Order History',
                    icon: Icons.history,
                    color: Colors.amberAccent[400]!,
                  ),
                  HomeCardButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
                      );
                    },
                    label: "View Today's Orders",
                    icon: Icons.calendar_today,
                    color: Colors.amberAccent[400]!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCardButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final IconData icon;
  final Color color;

  const HomeCardButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amberAccent[400],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  "Hello, Vendor",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ...VendorMenuOptions.allOptions.map((option) { // Use VendorMenuOptions instead of MenuOptions
            return ListTile(
              onTap: () {
                if (option.title == 'Logout') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => VendorLoginPage()),
                        (route) => false,
                  );
                } else {
                  // Navigate to VendorMenuPage when other options are clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorMenuPage()),
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
