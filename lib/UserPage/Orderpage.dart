import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/order_controller.dart';
import 'CartPage.dart';

class OrderDetailsPage extends StatefulWidget {
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => Provider.of<OrderDetailsProvider>(context, listen: false).fetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsProvider>(
      builder: (context, orderDetailsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
            ),
            title: Text(
              "Order Details",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Order",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: orderDetailsProvider.cartItems.isEmpty
                      ? Center(
                    child: Text(
                      "Your cart is empty.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    itemCount: orderDetailsProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = orderDetailsProvider.cartItems[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: item['imageUrl'] != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Icon(Icons.image,
                              size: 60, color: Colors.grey),
                          title: Text(item['productName'] ?? 'No Name',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Price: ₹${item['productPrice']}',
                                  style:
                                  TextStyle(color: Colors.black54)),
                              Text('Qty: ${item['quantity'] ?? 1}',
                                  style:
                                  TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                TextField(
                  controller: orderDetailsProvider.districtController,
                  decoration: InputDecoration(labelText: "District"),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: orderDetailsProvider.placeController,
                  decoration: InputDecoration(labelText: "Place"),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: orderDetailsProvider.pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Pincode"),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: orderDetailsProvider.pickupPointController,
                  decoration: InputDecoration(labelText: "Pickup Point"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await orderDetailsProvider.saveOrderDetails(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Order placed successfully")),
                      );
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => PaymentPage()),
                      // );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
