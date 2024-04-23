import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UpdateFoodItemPage extends StatefulWidget {
  const UpdateFoodItemPage({Key? key}) : super(key: key);

  @override
  _UpdateFoodItemPageState createState() => _UpdateFoodItemPageState();
}

class _UpdateFoodItemPageState extends State<UpdateFoodItemPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedFoodItem = ''; // To store the selected food item
  String foodName = '';
  String foodDescription = '';
  double unitPrice = 0.0;
  File? _image;

  TextEditingController foodNameController = TextEditingController();
  TextEditingController foodDescriptionController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Food Item'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Food Item:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildFoodItemDropdown(),
              SizedBox(height: 20),
              TextFormField(
                controller: foodNameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    foodName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: foodDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    foodDescription = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: unitPriceController,
                decoration: InputDecoration(
                  labelText: 'Unit Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    unitPrice = double.parse(value);
                  });
                },
              ),
              SizedBox(height: 20),
              _image == null && selectedFoodItem.isNotEmpty
                  ? FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('food_items')
                    .doc(selectedFoodItem)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final foodItemImage =
                  snapshot.data!.get('image') as String?;
                  return foodItemImage != null
                      ? Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          foodItemImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Edit Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  )
                      : Container();
                },
              )
                  : _image == null
                  ? Container()
                  : Column(
                children: [
                  Image.file(_image!),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Edit Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateFoodItem();
                    },
                    child: Text('Update Food Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _deleteFoodItem();
                    },
                    child: Text('Delete Food Item'),
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
    );
  }

  Widget _buildFoodItemDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('food_items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<DropdownMenuItem<String>> items = [];
        final foodItems = snapshot.data!.docs;
        for (var foodItem in foodItems) {
          final foodItemName = foodItem.get('item_name');
          items.add(
            DropdownMenuItem(
              child: Text(foodItemName),
              value: foodItem.id,
            ),
          );
        }
        return DropdownButtonFormField<String>(
          value: selectedFoodItem.isNotEmpty ? selectedFoodItem : null,
          items: items,
          onChanged: (value) {
            setState(() {
              selectedFoodItem = value!;
              _fetchFoodItemDetails(selectedFoodItem);
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select food item',
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchFoodItemDetails(selectedFoodItem);
  }

  void _fetchFoodItemDetails(String foodItemId) {
    if (foodItemId.isNotEmpty) {
      _firestore.collection('food_items').doc(foodItemId).get().then((foodItemSnapshot) {
        setState(() {
          foodName = foodItemSnapshot.get('item_name');
          foodDescription = foodItemSnapshot.get('item_des');
          unitPrice = foodItemSnapshot.get('unit_price');
        });

        foodNameController.text = foodName;
        foodDescriptionController.text = foodDescription;
        unitPriceController.text = unitPrice.toString();
      }).catchError((error) {
        print('Error fetching food item details: $error');
      });
    } else {
      setState(() {
        foodName = '';
        foodDescription = '';
        unitPrice = 0.0;
      });
    }
  }

  void _updateFoodItem() {
    if (selectedFoodItem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a food item')),
      );
      return;
    }
    _firestore.collection('food_items').doc(selectedFoodItem).update({
      'item_name': foodName,
      'item_des': foodDescription,
      'unit_price': unitPrice,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food Item updated successfully')),
      );
      _clearForm();
    }).catchError((error) {
      print('Error updating food item: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update food item')),
      );
    });
  }

  void _deleteFoodItem() {
    if (selectedFoodItem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a food item to delete')),
      );
      return;
    }
    _firestore.collection('food_items').doc(selectedFoodItem).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food Item deleted successfully')),
      );
      setState(() {
        selectedFoodItem = '';
        foodName = '';
        foodDescription = '';
        unitPrice = 0.0;
        _image = null;
      });
    }).catchError((error) {
      print('Error deleting food item: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete food item')),
      );
    });
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

  void _clearForm() {
    setState(() {
      foodNameController.clear();
      foodDescriptionController.clear();
      unitPriceController.clear();
      _image = null;
    });
  }

  @override
  void dispose() {
    foodNameController.dispose();
    foodDescriptionController.dispose();
    unitPriceController.dispose();
    super.dispose();
  }
}
