import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'BottomBar.dart';
import 'Orderpage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  int currentStep = 0;


  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

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

    setState(() {
      cartItems = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> removeFromCart(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final cartRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("cart");
    await cartRef.doc(id).delete();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBarPage(),
              ),
            );
          },
        ),
        title: Text("My Cart"),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : Column(
            children: [
              // Stepper(
              //   type: StepperType.horizontal,
              //     currentStep: currentStep,
              //     onStepTapped: (step) {
              //       if(step<currentStep){
              //         setState(() {
              //           currentStep=step;
              //         });
              //       }
              //     },
              //     steps: [
              //       Step(
              //           title: Text("cart"),
              //           content: SizedBox(),
              //           isActive: true
              //       ),
              //       Step(
              //           title: Text("order"),
              //           content: SizedBox(),
              //           isActive: false
              //       ),
              //     ]),
              Expanded(
                child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                final item = cartItems[index];

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                            image: item['imageUrl'] != null
                                ? DecorationImage(
                              image: NetworkImage(item['imageUrl']),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: Colors.grey[200],
                          ),
                          child: item['imageUrl'] == null
                              ? Icon(Icons.image, size: 50)
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['productName'] ?? 'No Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '₹${item['productPrice']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.pink.shade700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                item['productDescription'] ??
                                    'No description available',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          children: [
                            Text(
                              'Qty: ${item['quantity'] ?? 1}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 30),
                            IconButton(
                              onPressed: () async {
                                await removeFromCart(item['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text("1 item removed"))
                                );
                              },
                              icon: Icon(Icons.leave_bags_at_home),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
                },
                ),
              ),
              ElevatedButton(onPressed: (){
                setState(() {
                  currentStep = 1;
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(),));
              },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent[400],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(400, 60),
                  ),
                  child: Text("NEXT",style: TextStyle(color: Colors.white,fontSize: 18),))
            ],
          ),
    );
  }
}
