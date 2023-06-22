import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Auth/Splash.dart';


void main()async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  Map? sdkConfiguration = await AppLovinMAX.initialize("NfoOk1PAASVcJiybbx38USeNLyf2Dv9yI6ybSAfkfNGftEDKdCpXtrHyfGVK7RCq7NEq3RkEpM9n-omMlqyfbM");
  await Firebase.initializeApp();
final fcmtoken  = await FirebaseMessaging.instance.getToken();
print (fcmtoken);
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
    return  SafeArea(child: MaterialApp(
      title: "NIKTO",
      debugShowCheckedModeBanner: false,
      home:SplashSc(),
    ));
  }
}


