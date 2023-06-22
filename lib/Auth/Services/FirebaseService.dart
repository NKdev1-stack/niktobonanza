

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/utils/Toast.dart';

import '../../Rooms/MainMenueRoom.dart';
import '../onBoarding.dart';

class LoginCheckService{


  void islogin(BuildContext context)async{
    final _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;


    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if(user!=null){

          Timer(
            const  Duration(seconds: 3),() {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainMenueRoom(),));
          },

          );
        }
        else{

          Timer(const Duration(seconds: 3), () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const OnBoard(),));
          },);
        }
      }
    } on SocketException catch (_) {

     Utils().message("No Internet Connection!");
    }}
  }
