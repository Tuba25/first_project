import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Vendor/vendor_home_page.dart';

class VendorLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add form key

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Check if the logged-in user is a vendor
        if (isVendor(userCredential.user!)) {
          // Navigate to vendor home page on successful login
          Navigator.pushReplacementNamed(context, '/vendor_home_page');
        } else {
          // Display error message if the user is not a vendor
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are not authorized to access the vendor portal.'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle authentication errors
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          print('Error: ${e.message}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  bool isVendor(User user) {
    // Implement logic to check if the user is a vendor
    // You can fetch user details from your database or Firebase Authentication
    // For demonstration purposes, let's assume all users with 'vendor' in their email are vendors
    return user.email!.toLowerCase().contains('vendor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Login'),
        backgroundColor: Colors.amber, // Set app bar background color to amber
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign form key to the form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign in', // Add title line
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.amber, // Set button text color to black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

