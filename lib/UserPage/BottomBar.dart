import 'package:flutter/material.dart';

import 'CartPage.dart';
import 'HomePage.dart';
import 'New.dart';

class BottomNavBarPage extends StatefulWidget {
  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    NewPage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildImageIcon("assets/images/myntra icon.webp"),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "New",
          ),
        ],
        selectedItemColor: Colors.pinkAccent[400],
        unselectedItemColor: Colors.pinkAccent[100],
        showUnselectedLabels: true,
      ),
    );
  }
}
Widget _buildImageIcon(String imagePath) {
  return Container(
    padding: EdgeInsets.all(4.0),
    child: Image.asset(
      imagePath,
      width: 24,
      height: 24,
    ),
  );
}
