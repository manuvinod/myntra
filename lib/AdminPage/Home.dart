import 'package:flutter/material.dart';

import '../Login&Singin/LoginPage.dart';
import 'MangeProducts.dart';
import 'User_order.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pinkAccent[400],
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
          }, icon: Icon(Icons.power_settings_new_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Admin Panel",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            AdminOption(
              icon: Icons.people,
              label: "Manage Users",
              onTap: () {
              },
            ),
            AdminOption(
              icon: Icons.category,
              label: "Manage Products",
              onTap: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageStore(),));
              },
            ),
            AdminOption(
              icon: Icons.analytics,
              label: "View Reports",
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminOrderDetailsPage(),));
              },
            ),
            AdminOption(
              icon: Icons.notifications,
              label: "Manage Notifications",
              onTap: () {
              },
            ),
            AdminOption(
              icon: Icons.settings,
              label: "Settings",
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AdminOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  AdminOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30.0,
          color: Colors.pinkAccent[400],
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
