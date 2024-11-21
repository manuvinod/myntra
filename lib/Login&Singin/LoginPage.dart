import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/AuthController.dart';
import 'Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 230),
        child: Consumer<Authentication>(
          builder: (context,auth,child){
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
                        controller: auth.emailController,
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
                        controller: auth.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    ElevatedButton(onPressed: ()=>auth.Login(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent[400],minimumSize: Size(350, 60)),
                        child: Text("Log IN",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                    Padding(
                      padding: const EdgeInsets.only(left: 100,top: 100),
                      child: Row(
                        children: [
                          const Text('Don\'t have an account?', style: TextStyle(color: Colors.black)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
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
