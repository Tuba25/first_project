import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'update_category_page.dart'; // Import the update category page

class VendorFoodPage extends StatefulWidget {
  const VendorFoodPage({Key? key}) : super(key: key);

  @override
  _VendorFoodPageState createState() => _VendorFoodPageState();
}

class _VendorFoodPageState extends State<VendorFoodPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Food Category Page'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Add BouncingScrollPhysics
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Food Category',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Food Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter food category name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                _image == null
                    ? Column(
                  children: [
                    Text(
                      'Add Image',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: _pickImage,
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 50,
                      color: Colors.amber,
                    ),
                  ],
                )
                    : Image.file(_image!),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addFoodCategory(name, description);
                        }
                      },
                      child: Text('Add Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdateCategoryPage()),
                        );
                      },
                      child: Text('Update Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Check if the selected file is an image
      if (pickedImage.path.endsWith('.jpg') || pickedImage.path.endsWith('.jpeg') || pickedImage.path.endsWith('.png')) {
        setState(() {
          _image = File(pickedImage.path);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please select a valid image in jpg, jpeg, or png format'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _addFoodCategory(String foodCategoryName, String foodCategoryDescription) async {
    if (_image == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select an image'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final storageRef = FirebaseStorage.instance.ref().child('food_category_images').child(name);
    final uploadTask = storageRef.putFile(_image!);

    try {
      await uploadTask.whenComplete(() async {
        final imageUrl = await storageRef.getDownloadURL();
        await _firestore.collection('food_categories').add({
          'name': foodCategoryName,
          'description': foodCategoryDescription,
          'image_url': imageUrl,
        });

        // Show success message in popup dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Food Category added successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _formKey.currentState?.reset(); // Clear form
                    setState(() {
                      _image = null;
                      name = '';
                      description = '';
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } catch (error) {
      print('Error uploading image: $error');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add food category'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
