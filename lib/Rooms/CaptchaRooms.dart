import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/utils/Toast.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class Captcha extends StatefulWidget {
  const Captcha({Key? key}) : super(key: key);

  @override
  State<Captcha> createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  var RndNo;
  TextEditingController _validatorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Random rnd = Random();

  final _DBref = FirebaseDatabase.instance.ref("Workers");
  final _UAuth = FirebaseAuth.instance;

  var UNiktos = 0;
  var TCaptcha = 0;
  var Level = 0;

  // Hide and Seek

  bool validatebtn = true;
  bool Adbtn = false;
  bool captchaWriter = true;




  //INT

  loadAdRINT(){
  UnityAds.load(

  placementId: 'Interstitial_Android',
  onComplete: (placementId) => print('Load Complete $placementId'),
  onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
);
}

showAdINT(){
    UnityAds.showVideoAd(
      serverId: "",
  placementId: 'Interstitial_Android',
  onStart: (placementId) => print('Video Ad $placementId started'),
  onClick: (placementId) => print('Video Ad $placementId click'),
  onSkipped: (placementId) => print('Video Ad $placementId skipped'),
  onComplete: (placementId) => {
    _DBref.child(_UAuth.currentUser!.uid).update({
          "I_ID": ServerValue.increment(1),
        })
  },
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}



// Reward Ad


loadAdRW(){
  UnityAds.load(

  placementId: 'Rewarded_Android',
  onComplete: (placementId) => print('Load Complete $placementId'),
  onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
);
}

showAdRW(){
    UnityAds.showVideoAd(
      serverId: "",
  placementId: 'Rewarded_Android',
  onStart: (placementId) => print('Video Ad $placementId started'),
  onClick: (placementId) => print('Video Ad $placementId click'),
  onSkipped: (placementId) => print('Video Ad $placementId skipped'),
  onComplete: (placementId) => {
    // Giving More Chances
          _DBref.child(_UAuth.currentUser!.uid).update({
            'Captchas': 5,
          }),
          // Update RWD AD in DB
          _DBref.child(_UAuth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          }),
  },
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}


  @override
  void initState() {
    loadAdRINT();
    loadAdRW();
    RndGeneratorMethod();
    getUserData();
    super.initState();
  }

  //Firebase Data Update

  updateUserData() {
    if(TCaptcha == 2){

      showAdINT();
    }else if(TCaptcha == 1){
      showAdINT();
    }
    // Coins Update
    _DBref.child(_UAuth.currentUser!.uid).update({
      'Niktos': ServerValue.increment(4),
    });

    try {
      if (TCaptcha > 0) {
        _validatorController.clear();

        _DBref.child(_UAuth.currentUser!.uid).update({
          'Captchas': ServerValue.increment(-1),
        });
      }
    } catch (exception) {}
  }

  // AdReward

  AdRewardinCaptcha() {
   
    

    if (TCaptcha >= 0) {
      // In this method we are using if else if captcha are greater than 0 all hidden widgets will show
      getUserData();
    }
  }

  // Firebase Getting Method

  getUserData() async {
    // Get Niktos
    _DBref.child(_UAuth.currentUser!.uid)
        .child("Niktos")
        .onValue
        .listen((event) {
      UNiktos = int.parse(event.snapshot.value.toString());
      setState(() {});
    });
    // Get Levels
    _DBref.child(_UAuth.currentUser!.uid)
        .child("Level")
        .onValue
        .listen((event) {
      Level = int.parse(event.snapshot.value.toString());
      setState(() {});
    });
    // Get Captcha
    _DBref.child(_UAuth.currentUser!.uid)
        .child("Captchas")
        .onValue
        .listen((event) {
      TCaptcha = int.parse(event.snapshot.value.toString());
      setState(() {
        if (TCaptcha <= 0) {
          RndNo = "No More Captcha.";
          Adbtn = true;
          captchaWriter = false;
          validatebtn = false;
        } else {
          RndNo = rnd.nextInt(
                1000000,
              ) +
              1;
          Adbtn = false;
          captchaWriter = true;
          validatebtn = true;
        }
      });
    });
  }

  RndGeneratorMethod() {
    RndNo = rnd.nextInt(
          1000000,
        ) +
        1;
    setState(() {});
  }

  schek() {
    _DBref.child(_UAuth.currentUser!.uid)
        .update({"T_CP": ServerValue.increment(1)});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [Colors.green.shade700, Colors.green.shade200])),
      child: Scaffold(
       //AD
      bottomNavigationBar:  UnityBannerAd(
  placementId: 'Banner_Android',
  onLoad: (placementId) => print('Banner loaded: $placementId'),
  onClick: (placementId) => print('Banner clicked: $placementId'),
  onShown: (placementId) => print('Banner shown: $placementId'),
  onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green[700],
          title: Row(
            children: [
              Icon(Icons.adb_rounded),
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
              ),
              const Text("Captchas")
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black38),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/coin.png",
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Niktos",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text("$UNiktos",
                              style: TextStyle(color: Colors.yellowAccent)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/captcha.png",
                            height: 35,
                            width: 35,
                          ),
                          const Text("Captcha",
                              style: TextStyle(color: Colors.white)),
                          Text("$TCaptcha",
                              style: TextStyle(color: Colors.yellow)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/rank.png",
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("Level", style: TextStyle(color: Colors.white)),
                          Text("$Level",
                              style: TextStyle(color: Colors.yellowAccent)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .025,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Write the Captcha you see on the screen.",
                        style: TextStyle(color: Colors.black),
                      ),
                    )),
                    Material(
                      color: Colors.transparent,
                      elevation: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .13,
                        width: MediaQuery.of(context).size.width * .81,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: Text(
                          "$RndNo",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Visibility(
                      visible: captchaWriter,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Wrong Entry");
                            }
                          },
                          controller: _validatorController,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Type Captcha...",
                              suffixIcon: InkWell(
                                  onTap: () {
                                    _validatorController.clear();
                                  },
                                  child: Icon(Icons.clear_outlined)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    InkWell(
                        onTap: () {
                          var UserCaptcha =
                              _validatorController.text.toString();
                          if (_formKey.currentState!.validate() &&
                              UserCaptcha == RndNo.toString()) {
                           
                            Utils().message("You Won 4 Coins");
                            schek();

                            setState(() {
                              RndGeneratorMethod();
                              updateUserData();
                            });
                          } else {
                            Utils().message("Wrong Captcha");
                          }
                        },
                        child: Visibility(
                          visible: validatebtn,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .06,
                            width: MediaQuery.of(context).size.width * .51,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.amber,
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.check_circle),
                                Text(
                                  "Validate",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Visibility(
                      visible: Adbtn,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black38),
                          onPressed: () {
                            AdRewardinCaptcha();
                            
                            showAdRW();
                            
                          },
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "More Captcha",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Image.asset(
                                  "assets/images/WatchAds.png",
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
