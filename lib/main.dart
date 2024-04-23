import 'package:flutter/material.dart';
import 'package:first_project/Vendor/vendor_home_page.dart'; // Import the vendor home page
import 'package:first_project/Vendor/vendor_login_page.dart'; // Import the vendor login page
import 'package:provider/provider.dart';
import 'package:first_project/cart_provider.dart';
import 'package:first_project/OrderHistoryProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'meal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderHistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: "Animated Drawer App",
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => VendorLoginPage(), // Define the route for the vendor login page
        '/vendor_home_page': (context) => VendorHomePage(), // Define the route for the vendor home page
      },
      //home: MealPage(),
    );
  }
}
