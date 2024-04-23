import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'update_food_item_page.dart'; // Import the UpdateFoodItemPage

class AddFoodItemPage extends StatefulWidget {
  const AddFoodItemPage({Key? key}) : super(key: key);

  @override
  _AddFoodItemPageState createState() => _AddFoodItemPageState();
}

class _AddFoodItemPageState extends State<AddFoodItemPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedCategory = ''; // To store the selected category
  String foodName = '';
  String foodDescription = '';
  double unitPrice = 0.0;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Item'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Category:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildCategoryDropdown(),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter food name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      foodName = value;
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
                      foodDescription = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter unit price';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      unitPrice = double.parse(value);
                    });
                  },
                ),
                SizedBox(height: 20),
                _image == null
                    ? ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text('Add Image'),
                )
                    : Image.file(_image!),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addFoodItem();
                    }
                  },
                  child: Text('Add Food Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Set primary color to amber accent
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateFoodItemPage()),
                    );
                  },
                  child: Text('Update Food Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Set primary color to amber accent
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('food_categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<DropdownMenuItem<String>> items = [];
        final categories = snapshot.data!.docs;
        for (var category in categories) {
          final categoryName = category.get('name');
          items.add(
            DropdownMenuItem(
              child: Text(categoryName),
              value: categoryName,
            ),
          );
        }
        return DropdownButtonFormField<String>(
          value: selectedCategory.isNotEmpty ? selectedCategory : null,
          items: items,
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select category',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        );
      },
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _addFoodItem() {
    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    // Get the selected category ID based on the category name
    String selectedCategoryId = '';
    _firestore.collection('food_categories').where('name', isEqualTo: selectedCategory).get().then((value) {
      if (value.docs.isNotEmpty) {
        selectedCategoryId = value.docs.first.id;
        // Generate a unique item ID (you can use UUID package or Firebase auto-generated IDs)
        String itemId = UniqueKey().toString();
        // Upload image if available
        if (_image != null) {
          final storageRef = FirebaseStorage.instance.ref().child('food_item_images').child(itemId);
          final uploadTask = storageRef.putFile(_image!);
          uploadTask.then((taskSnapshot) async {
            final imageUrl = await taskSnapshot.ref.getDownloadURL();
            // Add the food item with additional fields
            _firestore.collection('food_items').add({
              'item_id': itemId,
              'cat_id': selectedCategoryId,
              'item_name': foodName,
              'unit_price': unitPrice,
              'image': imageUrl,
              'item_des': foodDescription,
              // Add additional fields here as needed
            }).then((_) {
              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('Food Item added successfully'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          _formKey.currentState?.reset(); // Clear form
                          setState(() {
                            _image = null; // Clear image
                            foodName = '';
                            unitPrice = 0.0;
                            foodDescription = '';
                          });
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }).catchError((error) {
              print('Error adding food item: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add food item')),
              );
            });
          }).catchError((error) {
            print('Error uploading image: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload image')),
            );
          });
        } else {
          // If no image is selected, add the food item without image
          _firestore.collection('food_items').add({
            'item_id': itemId,
            'cat_id': selectedCategoryId,
            'item_name': foodName,
            'unit_price': unitPrice,
            'image': '',
            'item_des': foodDescription,
            // Add additional fields here as needed
          }).then((_) {
            // Show success dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Food Item added successfully'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        _formKey.currentState?.reset(); // Clear form
                        setState(() {
                          _image = null; // Clear image
                          foodName = '';
                          unitPrice = 0.0;
                          foodDescription = '';
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }).catchError((error) {
            print('Error adding food item: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add food item')),
            );
          });
        }
      }
    });
  }
}
