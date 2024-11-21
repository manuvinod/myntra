import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'MangeProducts.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

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
        .child('category_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _addCategoryToCollection(String collectionName) async {
    final String name = _nameController.text.trim();

    if (name.isNotEmpty && _imageFile != null) {
      setState(() {
        _isLoading = true;
      });

      final imageUrl = await _uploadImage(_imageFile!);

      if (imageUrl != null) {
        final newCategory = {
          'name': name,
          'imageUrl': imageUrl,
        };
        await FirebaseFirestore.instance
            .collection('Categories')
            .doc(collectionName)
            .collection('items')
            .add(newCategory);

        _nameController.clear();
        setState(() {
          _imageFile = null;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully to $collectionName!')),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text('Add Category', style: TextStyle(color: Colors.pinkAccent[400], fontSize: 18))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageStore(),));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF3F6C)),
                  ),
                ),
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
              // Pick Image Button
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
                onPressed: () => _addCategoryToCollection('category1'),
                child: Text(
                  'Main Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              _isLoading ? Center(child: CircularProgressIndicator()) : ElevatedButton(
                onPressed: () => _addCategoryToCollection('category2'),
                child: Text(
                  'Addiontional Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}