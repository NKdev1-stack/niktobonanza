import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:niktobonanza/Rooms/QuizRoom.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'Auth/Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await Firebase.initializeApp();
  String? token = await FirebaseMessaging.instance.getToken();
  print(token);



UnityAds.init(
  gameId: '5399804',
  testMode: true,
  onComplete: () => print('Initialization Complete'),
  onFailed: (error, message) => print('Initialization Failed: $error $message'),
);


  runApp(const Nikto());
}

class Nikto extends StatefulWidget {
  const Nikto({Key? key}) : super(key: key);

  @override
  State<Nikto> createState() => _NiktoState();
}

class _NiktoState extends State<Nikto> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MaterialApp(
            themeMode: ThemeMode.light,
            title: "BitEarn",
            debugShowCheckedModeBanner: false,
            home: SplashSc()));
  }
}
