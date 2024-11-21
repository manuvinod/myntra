import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }
  Future<void> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc('category1')
          .collection('items')
          .get();

      setState(() {
        _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }
  Future<String?> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
  Future<void> _addItem() async {
    final String name = _nameController.text.trim();
    final String price = _priceController.text.trim();
    final String description = _descriptionController.text.trim();

    if (name.isNotEmpty && price.isNotEmpty && _selectedCategory != null && _imageFile != null) {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl = await _uploadImage(_imageFile!); // Upload the image

      if (imageUrl != null) {
        final newItem = {
          'name': name,
          'price': double.tryParse(price), // Convert to double
          'description': description,
          'imageUrl': imageUrl, // Add the image URL
          'category': _selectedCategory, // Add selected category
        };

        try {
          await FirebaseFirestore.instance
              .collection('Items')
              .add(newItem);
          _nameController.clear();
          _priceController.clear();
          _descriptionController.clear();
          _selectedCategory = null;
          _imageFile = null;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item added successfully!')),
          );
        } catch (e) {
          print('Error adding item: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add item.')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  hint: Text('Select Category',style: TextStyle(color: Color(0xFFB8860B)),),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category,style: TextStyle(color: Color(0xFFB8860B)),),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
              ),
              SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(
                _imageFile!,
                height: 150,
              )
                  : Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.add_a_photo),
                label: Text(
                  'Pick Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent[400], // Customize color
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _addItem,
                child: Text('Add Item',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Customize color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// addiotional categories
class AdditionalCategory extends StatefulWidget {
  const AdditionalCategory({super.key});
  @override
  State<AdditionalCategory> createState() => _AdditionalCategoryState();
}

class _AdditionalCategoryState extends State<AdditionalCategory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }
  Future<void> _fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc('category2')
          .collection('items')
          .get();

      setState(() {
        _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }
  Future<String?> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
  Future<void> _addItem() async {
    final String name = _nameController.text.trim();
    final String price = _priceController.text.trim();
    final String description = _descriptionController.text.trim();

    if (name.isNotEmpty && price.isNotEmpty && _selectedCategory != null && _imageFile != null) {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl = await _uploadImage(_imageFile!);

      if (imageUrl != null) {
        final newItem = {
          'name': name,
          'price': double.tryParse(price),
          'description': description,
          'imageUrl': imageUrl,
          'category': _selectedCategory,
        };

        try {
          await FirebaseFirestore.instance
              .collection('Items')
              .add(newItem);
          _nameController.clear();
          _priceController.clear();
          _descriptionController.clear();
          _selectedCategory = null;
          _imageFile = null;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item added successfully!')),
          );
        } catch (e) {
          print('Error adding item: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add item.')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  hint: Text('Select Category',style: TextStyle(color: Color(0xFFB8860B)),),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category,style: TextStyle(color: Color(0xFFB8860B)),),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
              ),
              SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(
                _imageFile!,
                height: 150,
              )
                  : Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.add_a_photo),
                label: Text(
                  'Pick Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent[400],
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _addItem,
                child: Text('Add Item',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Customize color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


