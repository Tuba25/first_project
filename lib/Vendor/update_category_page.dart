import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCategoryPage extends StatefulWidget {
  const UpdateCategoryPage({Key? key}) : super(key: key);

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedCategory = '';
  String categoryName = '';
  String categoryDescription = '';
  File? _image;

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Food Category'),
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
                  controller: categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      categoryName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: categoryDescriptionController,
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
                      categoryDescription = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                _image == null ? Container() : _buildImagePreview(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
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
                        if (_formKey.currentState!.validate()) {
                          _updateCategory();
                        }
                      },
                      child: Text('Update Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        _deleteCategory();
                      },
                      child: Text('Delete Category'),
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
          final categoryId = category.id;
          final categoryName = category.get('name');
          items.add(
            DropdownMenuItem(
              child: Text(categoryName),
              value: categoryId,
            ),
          );
        }
        return DropdownButtonFormField<String>(
          value: selectedCategory.isNotEmpty ? selectedCategory : null,
          items: items,
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
              _fetchCategoryDetails(selectedCategory);
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

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image of the selected Category:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: _image != null ? Image.file(_image!, fit: BoxFit.cover) : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _fetchCategoryDetails(String categoryId) {
    _firestore.collection('food_categories').doc(categoryId).get().then((categorySnapshot) async {
      setState(() {
        categoryName = categorySnapshot.get('name');
        categoryDescription = categorySnapshot.get('description');
      });

      categoryNameController.text = categoryName;
      categoryDescriptionController.text = categoryDescription;

      final imageUrl = categorySnapshot.get('image_url');
      if (imageUrl != null) {
        _loadImage(imageUrl);
      }
    }).catchError((error) {
      print('Error fetching category details: $error');
    });
  }

  void _loadImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/temp_image.png');
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _image = file;
        });
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading image: $error');
    }
  }

  void _updateCategory() {
    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    _firestore.collection('food_categories').doc(selectedCategory).update({
      'name': categoryName,
      'description': categoryDescription,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food Category updated successfully')),
      );
    }).catchError((error) {
      print('Error updating food category: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update food category')),
      );
    });
  }

  void _deleteCategory() {
    if (selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category to delete')),
      );
      return;
    }

    _firestore.collection('food_categories').doc(selectedCategory).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food Category deleted successfully')),
      );
      setState(() {
        selectedCategory = '';
        categoryName = '';
        categoryDescription = '';
        _image = null;
      });
    }).catchError((error) {
      print('Error deleting food category: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete food category')),
      );
    });
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    categoryDescriptionController.dispose();
    super.dispose();
  }
}
