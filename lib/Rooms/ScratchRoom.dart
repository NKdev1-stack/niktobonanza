import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

import '../utils/Toast.dart';

class ScratchRoom extends StatefulWidget {
  const ScratchRoom({Key? key}) : super(key: key);

  @override
  State<ScratchRoom> createState() => _ScratchRoomState();
}

class _ScratchRoomState extends State<ScratchRoom> {
  final _authUID = FirebaseAuth.instance;
  final _ref = FirebaseDatabase.instance.ref("Workers");

  final String _interstitial_ad_unit_id = "450bc990d365b2fb";
  final String _rewarded_ad_unit_id = "07b9f55d898bba2c";

  var _interstitialRetryAttempt = 0;
  var _rewardedAdRetryAttempt = 0;

  bool INTisReady = true;
  bool RWDisReady = true;
  final String _ad_unit_id = "45a079225c19874b";

// Advertisement

// Advertisement

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
// Int Ad

        _ref.child(_authUID.currentUser!.uid).update({
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

// Reward Ad

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
          // Reward Ad
          // Giving More Chances
          _ref.child(_authUID.currentUser!.uid).update({
            'Scratch': 5,
          });
          // Update RWD AD in DB
          _ref.child(_authUID.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          });
        }));
  }

  var Niktos = 0;
  var rnds = 0;
  var Scratch = 0;
  var Level = 0;

  @override
  initState() {
    GettingdataFirebase();
    initializeRewardedAds();
    initializeInterstitialAds();
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
                          initializeRewardedAds();

                          if (RWDisReady) {
                            AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);
                          }
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
                    rnds == 6 ||
                    rnds == 4 ||
                    rnds == 1 ||
                    rnds == 2 ||
                    rnds == 5 ||
                    rnds == 3) {
                  initializeInterstitialAds();

                  if (INTisReady) {
                    AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
                  }
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
