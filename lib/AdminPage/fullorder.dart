import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FullOrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> billing;

  const FullOrderDetailsPage({Key? key, required this.billing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timestamp = (billing['timestamp'] as Timestamp?)?.toDate();
    final formattedDate = timestamp != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp)
        : 'No timestamp';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.amber[800]),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date/Time: $formattedDate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Username: ${billing['username']}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: billing['items'].length,
                itemBuilder: (context, index) {
                  final item = billing['items'][index];
                  return ListTile(
                    title: Text('${item['name']}'),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
