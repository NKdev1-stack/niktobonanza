import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/Auth/LoginSignup/signup.dart';
import 'package:niktobonanza/Rooms/MainMenueRoom.dart';
import 'package:niktobonanza/utils/Toast.dart';

class LoginArea extends StatefulWidget {
  const LoginArea({Key? key}) : super(key: key);

  @override

  State<LoginArea> createState() => _LoginAreaState();
}

class _LoginAreaState extends State<LoginArea> {
  late bool _passwordVisible;
  TextEditingController  emailController = TextEditingController();
  TextEditingController  passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    // TODO: implement initState
    _passwordVisible = true;
    super.initState();
  }
  LoggingIn() async {


    _auth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString())
        .then((value) => {

          Utils().message("Welcome Back"),
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainMenueRoom(),)),

    }).onError((error, stackTrace) => {
      Utils().message("Incorrect Details! Try Again"),

    });
  }

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Image.asset("assets/images/login.png",
                    height: MediaQuery.of(context).size.height *0.3,
                    width: MediaQuery.of(context).size.width *1,),
                ),

                SizedBox(height: MediaQuery.of(context).size.height *0.04,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Log In",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),)),

                SizedBox(height: MediaQuery.of(context).size.height *0.04,),


                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email ID",
                      prefixIcon: const Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height *0.01,),

                TextFormField(
                  // _passwordVisible is true so password text will be hidden
                  controller: passwordController,
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline_sharp),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        // Using IconButton
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Condition by default _passwordVisible is true
                            _passwordVisible?Icons.visibility
                                : Icons.visibility_off,),
                          onPressed: (){
                            // using ! NOT Operator this will change reverse the values (True to false, false to true)
                            setState(() {
                              _passwordVisible = !_passwordVisible;

                            });
                          },
                        )
                    )
                ),

                const SizedBox(height: 15),

                 SizedBox(
                  height: MediaQuery.of(context).size.height *0.05,
                  width: MediaQuery.of(context).size.width *0.7,
                  child: ElevatedButton(
                    onPressed: (){

                      // Login The User
                      LoggingIn();
                    },style: ElevatedButton.styleFrom(
                      shadowColor: Colors.blue.shade700,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),  child:const Text("Login In",style: TextStyle(fontSize: 16),),),
                ),
                const SizedBox(height: 10,),
                Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => signup(),));

                      },
                      child: RichText(
                        text: const TextSpan(
                            text: "No Account Yet! ",style: TextStyle(color: Colors.black),

                            children: [

                              TextSpan(text: "Sign Up Here!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
                            ]
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}
