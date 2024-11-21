import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home.dart';

class AdminOrderDetailsPage extends StatefulWidget {
  @override
  _AdminOrderDetailsPageState createState() => _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState extends State<AdminOrderDetailsPage> {
  List<Map<String, dynamic>> allOrders = [];

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final usersSnapshot = await usersCollection.get();
    List<Map<String, dynamic>> orders = [];

    for (var userDoc in usersSnapshot.docs) {
      final ordersSnapshot = await userDoc.reference.collection('orders').get();
      final username = userDoc.data()['UserName'] ?? 'Unknown User';

      for (var orderDoc in ordersSnapshot.docs) {
        final orderData = orderDoc.data();
        orderData['UserName'] = username;
        orderData['userId'] = userDoc.id;
        orderData['orderId'] = orderDoc.id;

        orders.add(orderData);
      }


    setState(() {
      allOrders = orders;
    });

  }
  }
  Future<void> deleteOrder(String userId, String orderId, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .delete();
      setState(() {
        allOrders.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Order",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pinkAccent[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage(),));
          },
        ),
      ),
      body: allOrders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: allOrders.length, itemBuilder: (context, index) {final order = allOrders[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " ${order['UserName']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text("Total Price: ₹${order['totalPrice']}"),
                  Text("Order Date: ${order['orderDate'].toDate().toLocal()}"),
                  Text("Delivery Address: ${order['deliveryAddress']}"),

                  Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...order['items'].map<Widget>((item) {
                    return ListTile(
                      leading: item['imageUrl'] != null
                          ? Image.network(
                        item['imageUrl'],
                        width: 40,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image, size: 40),
                      title: Text(item['productName'] ?? 'No Name'),
                      subtitle: Text('Qty: ${item['quantity']}, Price: ₹${item['productPrice']}'),
                    );
                  }).toList(),
                  ElevatedButton(onPressed: ()async{
                    await deleteOrder(order["userId"],order["orderId"], index);
                  }, child: Text("Completed"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
