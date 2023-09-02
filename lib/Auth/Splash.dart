import 'dart:io';

import 'package:flutter/material.dart';

import 'Services/FirebaseService.dart';

class SplashSc extends StatefulWidget {


  @override
  State<SplashSc> createState() => _SplashScState();
}


class _SplashScState extends State<SplashSc> {


@override
  void initState() {

  LoginCheckService loginCheckService = LoginCheckService();

  loginCheckService.islogin(context);

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Center(child: Image.asset("assets/images/bitearn.png",height: 150,width: 150,)),
          SizedBox(height: 20,),
          CircularProgressIndicator(color: Colors.blue,strokeWidth: 5),
          
        ],
      ),
    );
  }
}
