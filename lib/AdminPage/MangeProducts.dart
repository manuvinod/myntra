import 'package:flutter/material.dart';

import 'Home.dart';
import 'Recommendation.dart';
import 'Topbar.dart';
import 'add banner.dart';
import 'add catogory.dart';
import 'add item.dart';

class ManageStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Store",style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage(),));
          },
        ),
        backgroundColor: Colors.pinkAccent[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.pinkAccent.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(
                    Icons.storefront,
                    color: Colors.pinkAccent[400],
                    size: 100.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _buildManageButton(
                context: context,
                icon: Icons.add_shopping_cart,
                label: "Add Product",
                color: Colors.greenAccent[700]!,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CategoryPage(),));
                },
              ),
              _buildManageButton(
                context: context,
                icon: Icons.category,
                label: "Add Category",
                color: Colors.blueAccent,
                onTap: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddCategoryPage(),));
                },
              ),
              _buildManageButton(
                context: context,
                icon: Icons.add_photo_alternate,
                label: "Add Banner",
                color: Colors.orangeAccent,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddBannerPage(),));
                },
              ),
              _buildManageButton(
                context: context,
                icon: Icons.receipt,
                label: "Add Recomandation",
                color: Colors.redAccent,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddRecommendationPage(),));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildManageButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 30.0,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: onTap,
      ),
    );
  }
}
