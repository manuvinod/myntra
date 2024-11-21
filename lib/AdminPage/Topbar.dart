import 'package:flutter/material.dart';

import 'MangeProducts.dart';
import 'add item.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Items',style:TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageStore(),));
            },
          ),
          backgroundColor: Colors.pinkAccent[400],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Main Categories',),
              Tab(text: 'Additional Categories'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            AddItemPage(),
            AdditionalCategory(),
          ],
        ),
      ),
    );
  }
}