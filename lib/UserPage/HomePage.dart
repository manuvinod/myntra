import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myntra/Controller/AuthController.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'CartPage.dart';
import 'Category.dart';
import 'product_RC.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Transform.scale(
            scale: 3,
            child: Image.asset(
              "assets/images/Myntra-Logo-2015.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }, icon: Icon(Icons.shopping_bag_outlined)),
          IconButton(onPressed: (){
            Provider.of<Authentication>(context,listen: false).logout(context);
            },icon: Icon(Icons.power_settings_new_outlined))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for products, brands and more',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage('assets/images/Myntra_TryAndBuy2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Categories Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 125,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Categories')
                    .doc('category1')
                    .collection('items')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final itemList = snapshot.data!.docs;

                  if (itemList.isEmpty) {
                    return Center(child: Text('No items available in category1'));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      final item = itemList[index].data() as Map<String, dynamic>;
                      final String name = item['name'] ?? 'No Name';
                      final String imageUrl = item['imageUrl'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(category: name),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              ClipPath(
                                clipper: StarClipper(8),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    image: imageUrl.isNotEmpty
                                        ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                    color: imageUrl.isEmpty ? Colors.grey[300] : null,
                                  ),
                                  child: imageUrl.isEmpty
                                      ? Icon(Icons.image, color: Colors.grey)
                                      : null,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
            ),
            // Product Grid Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Recommended for You",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('recommendation').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching recommendations.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No recommendations available.'));
                }

                final products = snapshot.data!.docs.where((doc) {
                  final productName = (doc['name'] ?? '').toString().toLowerCase();
                  return productName.contains(searchQuery);
                }).toList();

                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl = product['imageUrl'] ?? '';
                    final productName = product['name'] ?? 'No Name';
                    final productPrice = product['price'] ?? 0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                              imageUrl: imageUrl,
                              productName: productName,
                              productPrice: productPrice,
                              productDescription:
                              "Myntra offers a diverse range of fashion and lifestyle products, from trendy clothing and footwear to premium accessories, beauty essentials, and home decor, ensuring a seamless shopping experience for all.",
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
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
                                style: TextStyle(color: Color(0xFFB8860B),),
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
          ],
        ),
      ),
    );
  }
}

// Star Clipper Class
class StarClipper extends CustomClipper<Path> {
  final int points;

  StarClipper(this.points);

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    final double radius = min(width, height) / 2;
    final double angle = (pi * 2) / points;

    final Offset center = Offset(width / 2, height / 2);

    for (int i = 0; i < points; i++) {
      final double x = center.dx + radius * cos(i * angle);
      final double y = center.dy + radius * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
