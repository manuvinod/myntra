import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AdminPage/Home.dart';
import 'AdminPage/MangeProducts.dart';
import 'AdminPage/Recommendation.dart';
import 'AdminPage/Topbar.dart';
import 'AdminPage/add catogory.dart';
import 'AdminPage/add item.dart';
import 'Controller/AuthController.dart';
import 'Controller/Itemcontroller.dart';
import 'Controller/order_controller.dart';
import 'Login&Singin/LoginPage.dart';
import 'Login&Singin/Signup.dart';
import 'UserPage/BottomBar.dart';
import 'UserPage/HomePage.dart';
import 'UserPage/New.dart';
import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Authentication()),
        ChangeNotifierProvider(create: (context)=>Itemcontroller()),
        ChangeNotifierProvider(create: (context)=>OrderDetailsProvider()),
        // ChangeNotifierProvider(create: (context)=>OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:LoginPage(),
      ),
    );
  }
}