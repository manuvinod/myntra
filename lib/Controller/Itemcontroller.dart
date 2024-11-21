import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Itemcontroller extends ChangeNotifier{
  void removeFromCart(id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final cartCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('cart');
    await cartCollection.doc(id).delete();
  }
}