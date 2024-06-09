import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../utils/Toast.dart';

class Dicer extends StatefulWidget {
  const Dicer({Key? key}) : super(key: key);

  @override
  State<Dicer> createState() => _DicerState();
}

class _DicerState extends State<Dicer> with TickerProviderStateMixin {
  @override
  late AnimationController _animationController;
  late Animation<double> animation;
  var shouldAbsorb = true;

  // FirebaseJB

  final _fAuth = FirebaseAuth.instance;
  final _rDb = FirebaseDatabase.instance.ref("Workers");
  var Niktos = 0;
  var Dices = 0;
  var Level = 0;

  // Hide and seek

  bool diceshow = true;
  bool adBtnshow = false;



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
     _rDb.child(_fAuth.currentUser!.uid).update({
          "I_ID": ServerValue.increment(1),
        })
  },
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}


//Reward Ad
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
          _rDb.child(_fAuth.currentUser!.uid).update({
            'Dice': 5,
          }),
          // Update RWD AD in DB
          _rDb.child(_fAuth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          })
           },
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
}


  // Reward Ad
// Giving More Chances
  // _rDb.child(_fAuth.currentUser!.uid).update({
  //   'Dice': 5,
  // });
  // // Update RWD AD in DB
  // _rDb.child(_fAuth.currentUser!.uid).update({
  //   'R_ID': ServerValue.increment(1),
  // });

  void initState() {
// Ads load

   loadAdRINT();
   loadAdRW();

    // Firebase Method
    getUserData();
    // Declare Animation Controller

    // I initialize animations also in Init state to remove the error of initializations
    _animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    // Create Animation variable

    animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastEaseInToSlowEaseOut);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  animate() {
    // make this Controller late so 'this(context) error will removed'

    // For starting Animation
    // In this case We are starting this animation in Roll method because when roll Method call than we start animation(Rolling the dice)
    //_animationController.forward(); // Use to Start the animation duration
    //_animationController.reverse(); //This will reverse the animation like jaisy ap video ko back krty khty kay 2:40 say 1:20 tk video reverse hu mean 1:20 sa movie dekhni

    // This is the Listener jb animation chal rha hay tb kia krna ha vo decide krty
    // _animationController.addListener(() {
    //
    // });

    // Status Listener main hmary pass kuch Options hoty like, Jb Animation Complete hogya, Jb Dismissed hogya wagera tu kia krna ha
    // _animationController.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //
    //   }
    // });
  }

  // Random Generator Method
  Random rnds = Random();
  var diceRandomNo = 1;
  void Roll() {
    // Starting Animation
    // Declare Animation Controller

    _animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    // Create Animation variable

    animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastEaseInToSlowEaseOut);
    _animationController.forward();
    setState(() {
      diceRandomNo = rnds.nextInt(6) + 1;
      updateData();

      Utils().message("You Won $diceRandomNo Niktos");

      if (
          diceRandomNo == 4 ||
          diceRandomNo == 6 ) {
       
            showAdINT();

        
      }
    });
    // Animation setting
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          shouldAbsorb = true;
        });
      }
    });
  }

  // Getting User Data

  getUserData() {
    // Setting Niktos
    _rDb.child(_fAuth.currentUser!.uid).child("Niktos").onValue.listen((event) {
      Niktos = int.parse(event.snapshot.value.toString());

      setState(() {});
    });
    // Levels
    _rDb.child(_fAuth.currentUser!.uid).child("Level").onValue.listen((event) {
      Level = int.parse(event.snapshot.value.toString());

      setState(() {});
    });
    // Setting Dices
    _rDb.child(_fAuth.currentUser!.uid).child("Dice").onValue.listen((event) {
      Dices = int.parse(event.snapshot.value.toString());
      setState(() {
        //HideAnd Seek

        if (Dices <= 0) {
          diceshow = false;
          adBtnshow = true;
        } else {
          diceshow = true;
          adBtnshow = false;
        }
      });
    });
  }

  // update User data

  updateData() {
    // Coin Update
    _rDb.child(_fAuth.currentUser!.uid).update({
      'Niktos': ServerValue.increment(diceRandomNo),
    });

    if (Dices > 0) {
      // Dices Update

      _rDb.child(_fAuth.currentUser!.uid).update({
        'Dice': ServerValue.increment(-1),
      });
    }
  }

  // AdReward
  AdRewardinDice() {
   showAdRW();
  }

  schek() {
    _rDb
        .child(_fAuth.currentUser!.uid)
        .update({"T_D": ServerValue.increment(1)});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [Colors.blue.shade700, Colors.blue.shade200])),
      child: Scaffold(
          bottomNavigationBar:  //AD
      UnityBannerAd(
  placementId: 'Banner_Android',
  onLoad: (placementId) => print('Banner loaded: $placementId'),
  onClick: (placementId) => print('Banner clicked: $placementId'),
  onShown: (placementId) => print('Banner shown: $placementId'),
  onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.blue[700],
            title: Row(
              children: [
                Icon(Icons.casino),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .02,
                ),
                const Text("Dice Game")
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
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
                          Text("$Niktos",
                              style: TextStyle(color: Colors.yellowAccent)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 6,
                          ),
                          Image.asset(
                            "assets/images/dice.png",
                            height: 35,
                            width: 32,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          const Text("Dices",
                              style: TextStyle(color: Colors.white)),
                          Text("$Dices",
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
                          Text(" $Level",
                              style: TextStyle(color: Colors.yellowAccent)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tap to Roll",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              RotationTransition(
                  turns: animation,
                  child: GestureDetector(
                      onTap: () {
                        schek();
                        setState(() {
                          if (shouldAbsorb) {
                            shouldAbsorb = false;
                            Roll();
                          } else {}
                        });
                      },
                      child: Visibility(
                          visible: diceshow,
                          child: Center(
                              child: Image.asset(
                            "assets/images/d$diceRandomNo.png",
                            height: 280,
                            width: 280,
                          ))))),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: adBtnshow,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black38),
                    onPressed: () {
                      AdRewardinDice();
                    },
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "More Dice",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Image.asset(
                            "assets/images/WatchAds.png",
                          )
                        ],
                      ),
                    )),
              ),
            ]),
          )),
    );
  }
}
