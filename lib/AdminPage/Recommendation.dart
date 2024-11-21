import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'MangeProducts.dart';

class AddRecommendationPage extends StatefulWidget {
  @override
  _AddRecommendationPageState createState() => _AddRecommendationPageState();
}

class _AddRecommendationPageState extends State<AddRecommendationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _pickedImage;
  bool _isUploading = false;
  final picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }
  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recommendations')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  Future<void> _addRecommendation() async {
    final String name = _nameController.text.trim();
    final double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    if (name.isEmpty || price <= 0 || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and add an image.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });
    final imageUrl = await _uploadImage(_pickedImage!);

    if (imageUrl != null) {
      await FirebaseFirestore.instance.collection('recommendation').add({
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
      });
      _nameController.clear();
      _priceController.clear();
      setState(() {
        _pickedImage = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added to recommendations!')),
      );
    } else {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageStore(),));
            },
          ),
          title: Text('Add Recommended Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[300],
                child: _pickedImage == null
                    ? Center(child: Text('Tap to add image'))
                    : Image.file(_pickedImage!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            _isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _addRecommendation,
              child: Text('Add Recommendation'),
            ),
          ],
        ),
      ),
    );
  }
}
