import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final double productPrice;
  final String productDescription;

  ProductDetailsPage({
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });
  Future<void> addToCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }
      final cartRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('cart');
      await cartRef.add({
        'imageUrl': imageUrl,
        'productName': productName,
        'productPrice': productPrice,
        'productDescription': productDescription,
        'quantity': 1, // Add quantity if needed
        'addedAt': Timestamp.now(),
      });

      print("Item added to cart successfully!");
    } catch (e) {
      print("Failed to add item to cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 25,
              child: Image.asset("assets/images/myntra icon.webp"),
            ),
            Text(
              productName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹$productPrice',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFB8860B),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                productDescription.isNotEmpty
                    ? productDescription
                    : 'No description available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await addToCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Item added to cart!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent[400],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(400, 60),
                ),
                child: Text(
                  "Add to Bag",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
