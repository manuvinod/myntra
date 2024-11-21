import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myntra/UserPage/product_CG.dart';

class ProductPage extends StatelessWidget {
  final String category;

  const ProductPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Items')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching products.'));
          }

          final products = snapshot.data?.docs;

          if (products == null || products.isEmpty) {
            return Center(child: Text('No products available in this category.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final imageUrl = product['imageUrl'] ?? '';
              final productName = product['name'] ?? 'No Name';
              final productPrice = product['price'] ?? 0;

              return GestureDetector(
                onTap: (){
                  Navigator.push
                    (context,
                      MaterialPageRoute(
                        builder: (context) => CGProductDetailsPage(imageUrl2:imageUrl,productName2:productName,productPrice2:productPrice , productDescription2:""
                            "Myntra offers a diverse range of fashion and lifestyle products, from trendy clothing and footwear to premium accessories, beauty essentials, and home decor, ensuring a seamless shopping experience for all."  ),));
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            image: DecorationImage(
                              image: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '₹$productPrice',
                          style: TextStyle(color: Color(0xFFB8860B)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// additonal product page
class AdditioanlProducts  extends StatelessWidget {
final String category;
const AdditioanlProducts({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Items')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching products.'));
          }

          final products = snapshot.data?.docs;

          if (products == null || products.isEmpty) {
            return Center(child: Text('No products available in this category.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final imageUrl = product['imageUrl'] ?? '';
              final productName = product['name'] ?? 'No Name';
              final productPrice = product['price'] ?? 0;

              return GestureDetector(
                onTap: (){
                  Navigator.push
                    (context,
                      MaterialPageRoute(
                        builder: (context) => CGProductDetailsPage(imageUrl2:imageUrl,productName2:productName,productPrice2:productPrice , productDescription2:""
                            " Myntra offers a diverse range of fashion and lifestyle products, from trendy clothing and footwear to premium accessories, beauty essentials, and home decor, ensuring a seamless shopping experience for all."  ),));
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            image: DecorationImage(
                              image: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/images/placeholder.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '₹$productPrice',
                          style: TextStyle(color: Color(0xFFB8860B)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

