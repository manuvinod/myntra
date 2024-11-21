import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../UserPage/BottomBar.dart';

class OrderDetailsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  double _totalPrice = 0.0;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  double get totalPrice => _totalPrice;

  final TextEditingController districtController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController pickupPointController = TextEditingController();

  Future<void> fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }

    final cartRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('cart');

    final querySnapshot = await cartRef.get();

    _cartItems = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    _totalPrice = _cartItems.fold(
        0, (sum, item) => sum + (item['productPrice'] * item['quantity']));

    notifyListeners();
  }

  Future<void> saveOrderDetails(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in.");
    }
    if (districtController.text.isEmpty ||
        placeController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        pickupPointController.text.isEmpty) {
      throw Exception("Please fill in all address fields");
    }

    final orderRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('orders')
        .doc();

    final orderData = {
      'deliveryAddress': {
        'district': districtController.text,
        'place': placeController.text,
        'pincode': pincodeController.text,
        'pickupPoint': pickupPointController.text,
      },
      'totalPrice': _totalPrice,
      'orderDate': DateTime.now(),
      'items': _cartItems.map((item) {
        return {
          'productName': item['productName'],
          'quantity': item['quantity'],
          'productPrice': item['productPrice'],
          'imageUrl': item['imageUrl'],
        };
      }).toList(),
    };
    await orderRef.set(orderData);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('cart')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBarPage(),));
    notifyListeners();
  }
}
