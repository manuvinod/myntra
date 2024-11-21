import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../AdminPage/Home.dart';
import '../Login&Singin/LoginPage.dart';
import '../UserPage/BottomBar.dart';
class Authentication extends ChangeNotifier{
  final TextEditingController UsernameController =TextEditingController();
  final TextEditingController EmailComtroller =TextEditingController();
  final TextEditingController PasswordController=TextEditingController();
  final TextEditingController ConformpasswordController=TextEditingController();
  final FirebaseAuth Auth =FirebaseAuth.instance;
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Register(context)async{
    try{
      String Email=EmailComtroller.text.trim();
      String Username=UsernameController.text.trim();
      String Password=PasswordController.text.trim();
      String ConformPassword=ConformpasswordController.text.trim();
      EmailComtroller.clear();
      UsernameController.clear();
      PasswordController.clear();
      ConformpasswordController.clear();
      if(Password!= ConformPassword){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password do not match!"))
        );
        return ;
      }
      UserCredential userCredential=await Auth.createUserWithEmailAndPassword(email: Email, password: Password);
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      await firestore.collection("Users").doc(userCredential.user!.uid).set({
        "UserID":userCredential.user!.uid,
        'Email': Email,
        'UserName': Username,

      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registeration Sucssefull")),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    }
    notifyListeners();
  }
  notifyListeners();
  Login(context)async{
    try{
      String email= emailController.text.trim();
      String password=passwordController.text.trim();
      UserCredential userCredential=await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      DocumentSnapshot userDoc= await firestore.collection("Users").doc(userCredential.user!.uid).get();
      emailController.clear();
      passwordController.clear();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData['Email'] == "admin@1123.com") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBarPage()));
        }
      }

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in: Enter your correct Email & password"))
      );
    }
    notifyListeners();
  }
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
}