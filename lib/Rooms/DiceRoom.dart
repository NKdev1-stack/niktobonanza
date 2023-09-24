import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

  final String _interstitial_ad_unit_id = "450bc990d365b2fb";
  final String _rewarded_ad_unit_id = "2eda4b8d0c86c6fc";

  var _interstitialRetryAttempt = 0;
  var _rewardedAdRetryAttempt = 0;

  bool INTisReady = true;
  bool RWDisReady = true;
  final String _ad_unit_id = "45a079225c19874b";
  // / Int Ad
  initializeInterstitialAds() async {
    INTisReady =
        (await AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id))!;

    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) will now return 'true'

        // Reset retry attempt
        _interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        _interstitialRetryAttempt = _interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, _interstitialRetryAttempt)).toInt();

        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {
        // Advertisement
// Int Ad
        _rDb.child(_fAuth.currentUser!.uid).update({
          "I_ID": ServerValue.increment(1),
        });
      },
      onAdDisplayFailedCallback: (ad, error) {
        AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
      },
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
    ));

    // Load the first interstitial
    AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
  }

  void initializeRewardedAds() async {
    RWDisReady = (await AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id))!;

    AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id);

    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
        onAdLoadedCallback: (ad) {
          // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'

          // Reset retry attempt
          _rewardedAdRetryAttempt = 0;
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          // Rewarded ad failed to load
          // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
          _rewardedAdRetryAttempt = _rewardedAdRetryAttempt + 1;

          int retryDelay = pow(2, min(6, _rewardedAdRetryAttempt)).toInt();
          print('Rewarded ad failed to load with code ' +
              error.code.toString() +
              ' - retrying in ' +
              retryDelay.toString() +
              's');

          Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
            AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id);
          });
        },
        onAdDisplayedCallback: (ad) {
          Utils().message("Watch Ad to Get More Chance");
        },
        onAdDisplayFailedCallback: (ad, error) {
          Utils().message("Please Wait! Or try Again After Some Time");
        },
        onAdClickedCallback: (ad) {},
        onAdHiddenCallback: (ad) {},
        onAdReceivedRewardCallback: (ad, reward) {
          // Reward Ad
// Giving More Chances
          _rDb.child(_fAuth.currentUser!.uid).update({
            'Dice': 5,
          });
          // Update RWD AD in DB
          _rDb.child(_fAuth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          });
        }));
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

    initializeRewardedAds();
    initializeInterstitialAds();

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

      if (diceRandomNo == 1 ||
          diceRandomNo == 4 ||
          diceRandomNo == 6 ||
          diceRandomNo == 2) {
        initializeInterstitialAds();

        if (INTisReady) {
          AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
        }
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
    initializeRewardedAds();

    if (RWDisReady) {
      AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);
    }
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
          bottomNavigationBar: MaxAdView(
            adUnitId: _ad_unit_id,
            adFormat: AdFormat.banner,
            listener: AdViewAdListener(
                onAdLoadedCallback: (ad) {},
                onAdLoadFailedCallback: (adUnitId, error) {},
                onAdClickedCallback: (ad) {},
                onAdExpandedCallback: (ad) {},
                onAdCollapsedCallback: (ad) {}),
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
