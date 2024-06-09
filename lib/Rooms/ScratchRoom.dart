import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../utils/Toast.dart';

class ScratchRoom extends StatefulWidget {
  const ScratchRoom({Key? key}) : super(key: key);

  @override
  State<ScratchRoom> createState() => _ScratchRoomState();
}

class _ScratchRoomState extends State<ScratchRoom> {
  final _authUID = FirebaseAuth.instance;
  final _ref = FirebaseDatabase.instance.ref("Workers");



// Advertisement

// Int Ad

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
    _ref.child(_authUID.currentUser!.uid).update({
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
         // Giving More Chances
          _ref.child(_authUID.currentUser!.uid).update({
            'Scratch': 5,
          }),
          // Update RWD AD in DB
          _ref.child(_authUID.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          })
  },
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}

  



  var Niktos = 0;
  var rnds = 0;
  var Scratch = 0;
  var Level = 0;

  @override
  initState() {
    GettingdataFirebase();
    loadAdRINT();
    loadAdRW();
    super.initState();
  }

  // Firebase

  GettingdataFirebase() {
    _ref
        .child(_authUID.currentUser!.uid)
        .child("Niktos")
        .onValue
        .listen((event) {
      var CoinsByFirebase = event.snapshot.value;
      setState(() {
        Niktos = int.parse(CoinsByFirebase.toString());
      });

      _ref
          .child(_authUID.currentUser!.uid)
          .child("Scratch")
          .onValue
          .listen((event) {
        var ScratchByFirebase = event.snapshot.value;
        setState(() {
          Scratch = int.parse(ScratchByFirebase.toString());
        });
      });
    });
// Levels
    _ref
        .child(_authUID.currentUser!.uid)
        .child("Level")
        .onValue
        .listen((event) {
      Level = int.parse(event.snapshot.value.toString());

      setState(() {});
    });
  }

  schek() {
    _ref
        .child(_authUID.currentUser!.uid)
        .update({"T_ST": ServerValue.increment(1)});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [Colors.green.shade700, Colors.green.shade200])),

        // App bar

        child: Scaffold(
         bottomNavigationBar: UnityBannerAd(
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
                Icon(Icons.line_weight_rounded),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .02,
                ),
                const Text("Scratch Game")
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Center(
                  // Menue
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.14,
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
                            Text(
                              "Niktos",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text("$Niktos",
                                style: TextStyle(color: Colors.yellowAccent)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/scratches.png",
                              height: 35,
                              width: 35,
                            ),
                            const Text("Scratch",
                                style: TextStyle(color: Colors.white)),
                            Text("$Scratch",
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
                            const Text("Level",
                                style: TextStyle(color: Colors.white)),
                            Text("$Level",
                                style: TextStyle(color: Colors.yellowAccent)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Scratchers

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.008,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // Scratch Cards

                                setState(() {
                                  if (Scratch <= 0) {
                                    Utils().message(
                                        "Watch Ad to Get More Chances");
                                  } else {
                                    ScratchDialog(context);
                                  }
                                });
                              },
                              child: Image.asset("assets/images/star.png"),
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  shadowColor: Colors.black,
                                  elevation: 1)),
                          Center(
                              child: const Text(
                            textAlign: TextAlign.center,
                            "Punch Me \n👊",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),

                // Using Turnary Operator to set Condition if Scratch are greater than 0 don't show ads button otherwise show this

                Scratch <= 0
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black38),
                        onPressed: () {
                          showAdRW();
                        },
                        child: Container(
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "More Scratch",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Image.asset(
                                "assets/images/WatchAds.png",
                              )
                            ],
                          ),
                        ))
                    : Text(""),
              ],
            ),
          ),
        ));
  }

  // Method of Scratch
  Future<void> ScratchDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text("Scratch the Card"),
                  Divider(
                    color: Colors.black,
                  )
                ],
              )),
          content: Scratcher(
              color: Colors.black,
              threshold: 5,
              onThreshold: () {
                Random rnd = Random();
                rnds = rnd.nextInt(10);
                final _authUID = FirebaseAuth.instance;
                final ref = FirebaseDatabase.instance.ref("Workers");

                if (rnds == 10 ||
                    rnds == 8 ||   
                    rnds == 3) {
                 
                 showAdINT();
                }

                ref.child(_authUID.currentUser!.uid).update({
                  'Niktos': ServerValue.increment(rnds),
                });

                try {
                  if (Scratch > 0) {
                    schek();
                    ref
                        .child(_authUID.currentUser!.uid)
                        .update({'Scratch': ServerValue.increment(-1)});
                  }
                } catch (exception) {
                  exception.toString();
                }

                setState(() {});
              },
              image: Image.asset("assets/images/sct.PNG"),
              accuracy: ScratchAccuracy.low,
              brushSize: 50,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment.center,
                child: Container(
                  color: Colors.greenAccent,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/images/trophy.png",
                          height: MediaQuery.of(context).size.height * 0.18,
                        ),
                      ),
                      Center(
                          child: Text(
                        "You Won $rnds ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }
}
