import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'Category.dart';

class NewPage extends StatelessWidget {
  NewPage({super.key});

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
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "JUST",
                  style: TextStyle(fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "ARRIVED",
                  style: TextStyle(fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Banners')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No banners available"));
                    }

                    final bannerImages = snapshot.data!.docs.map((doc) {
                      final url = doc['imageUrl'];
                      return url is String ? url : null;
                    }).where((url) => url != null).toList();

                    if (bannerImages.isEmpty) {
                      return Center(
                          child: Text("No valid banner images available"));
                    }

                    return CarouselSlider(
                      items: bannerImages.map((item) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Text("Image not available"));
                              },
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: 0.85,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        enlargeCenterPage: true,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Explore more Deals",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Categories')
                .doc('category2')
                .collection('items')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No items found in category2.'));
              }

              final itemList = snapshot.data!.docs;

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1,
                ),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  final item = itemList[index].data() as Map<String, dynamic>;

                  final String itemName = item['name'] ?? 'No Name';
                  final String itemImageUrl = item['imageUrl'] ?? '';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdditioanlProducts(category: itemName),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: itemImageUrl.isNotEmpty
                                ? Image.network(itemImageUrl, height: 150, width: double.infinity, fit: BoxFit.cover)
                                : Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60,top: 10),
                            child: Text(
                              itemName,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
