import  'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/AuthController.dart';
import 'LoginPage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Consumer<Authentication>(
          builder: (context,Auth,child){
            return Form(
                key: _formKey,
                child: Column(
                  children: [
                   Image(image: AssetImage("assets/images/Myntra-Logo-2015.png"),
                     width: 180,
                     height: 180,
                   ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: Auth.UsernameController,
                        decoration: InputDecoration(
                          hintText: "UserName",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: Auth.EmailComtroller,
                        decoration: InputDecoration(
                            hintText: "EMAIL",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: Auth.PasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: Auth.ConformpasswordController,
                        decoration: InputDecoration(
                            hintText: "Conform Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your Password";
                          } else if (value != Auth.PasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 50,),
                    ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate()){
                        Provider.of<Authentication>(context,listen:false).Register(context);
                        showDialog(context: context,
                            builder: (BuildContext context){
                          return AlertDialog(
                            backgroundColor: Colors.pinkAccent[100],
                            title: Text("Sign-Up Completed"),
                            content: Text("We are excited to have you join our community!"),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  },
                                  child: Text("Back to login page"),
                                ),
                              ),
                            ],
                          );
                            });
                      }
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent[400],minimumSize: Size(350, 60)),
                        child: Text("Sign UP",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                    Padding(
                      padding: const EdgeInsets.only(left: 100,top: 100),
                      child: Row(
                        children: [
                          const Text('Already have an account?', style: TextStyle(color: Colors.black)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            child: Text('Sign Up', style: TextStyle(color: Colors.pinkAccent[400])),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            );
            },
        ),
      ),
    );
  }
}
