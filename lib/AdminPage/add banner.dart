import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'MangeProducts.dart';

class AddBannerPage extends StatefulWidget {
  @override
  _AddBannerPageState createState() => _AddBannerPageState();
}

class _AddBannerPageState extends State<AddBannerPage> {
  final _formKey = GlobalKey<FormState>();
  String? _bannerName;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _addBanner() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      _formKey.currentState!.save();
      String imageUrl = await _uploadImage(_imageFile!);
      await FirebaseFirestore.instance.collection('Banners').add({
        'name': _bannerName,
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Banner added successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and fill out the form')),
      );
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('banners/$fileName');
    await ref.putFile(imageFile);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
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
        title: Text('Add Banner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: Text('Tap to select an image')),
                )
                    : Image.file(
                  _imageFile!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Banner Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bannerName = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBanner,
                child: Text('Add Banner'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
