import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/Toast.dart';

class GuessRoom extends StatefulWidget {
  const GuessRoom({Key? key}) : super(key: key);

  @override
  State<GuessRoom> createState() => _GuessRoomState();
}

class _GuessRoomState extends State<GuessRoom> {
  var UNiktos = 0;
  var UGuesses = 0;
  var Level = 0;
  var guessNumber = 0;

  bool adBtnshow = false;
  bool checkButton = true;
  bool guessEntry = true;

  TextEditingController _guessController = TextEditingController();

  //DB
  final _auth = FirebaseAuth.instance;
  final _refDb = FirebaseDatabase.instance.ref("Workers");
  final _key = GlobalKey<FormState>();
  Random random = Random();

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
// / Int Ad

        _refDb.child(_auth.currentUser!.uid).update({
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

          // Giving More Chances
          _refDb.child(_auth.currentUser!.uid).update({
            'Guesses': 5,
          });
          // Update RWD AD in DB
          _refDb.child(_auth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          });
        }));
  }

  @override
  void initState() {
    initializeRewardedAds();
    initializeInterstitialAds();
    GuessNoGenerator();
    gettingFDB();
    super.initState();
  }

  // GuessNoGenerator
  GuessNoGenerator() {
    guessNumber = random.nextInt(20);
    setState(() {});

    print(guessNumber);
  }

  // Getting data from Db
  gettingFDB() {
    // Getting Niktos

    _refDb
        .child(_auth.currentUser!.uid)
        .child("Niktos")
        .onValue
        .listen((event) {
      UNiktos = int.parse(event.snapshot.value.toString());
      setState(() {});
    });
// Levels
    _refDb.child(_auth.currentUser!.uid).child("Level").onValue.listen((event) {
      Level = int.parse(event.snapshot.value.toString());

      setState(() {});
    });

    // Getting Guesses

    _refDb
        .child(_auth.currentUser!.uid)
        .child("Guesses")
        .onValue
        .listen((event) {
      UGuesses = int.parse(event.snapshot.value.toString());
      setState(() {
        // Hide and Seek

        if (UGuesses <= 0) {
          adBtnshow = true;
          checkButton = false;
          guessEntry = false;
        } else if (UGuesses > 0) {
          adBtnshow = false;
          checkButton = true;
          guessEntry = true;
        }
      });
    });
  }

  // GuessNoChecker

  Guessnocheck() {
    initializeInterstitialAds();

    if (INTisReady) {
      AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
    }
    if (guessNumber == int.parse(_guessController.text.toString())) {
      decreaseChance();

      GuessNoGenerator();
      // Getting Niktos
      _refDb.child(_auth.currentUser!.uid).update({
        "Niktos": ServerValue.increment(5),
      });

      Utils().message("You Won 5 Niktos");

      setState(() {});
    } else {
      setState(() {});
      Utils().message("Incorrect Guess Try Again!");
    }
  }

  // Decrease Chance

  decreaseChance() {
    if (UGuesses > 0) {
      // decrease the chance
      _refDb.child(_auth.currentUser!.uid).update({
        "Guesses": ServerValue.increment(-1),
      });
    }
  }

  // Adreward in Guess
  AdRewardinGuess() {
    initializeRewardedAds();

    if (RWDisReady) {
      AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);
    }
  }

  schek() {
    _refDb
        .child(_auth.currentUser!.uid)
        .update({"T_G": ServerValue.increment(1)});
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
              Icon(Icons.lightbulb),
              SizedBox(
                width: MediaQuery.of(context).size.width * .02,
              ),
              const Text("Guess Game")
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
                            "assets/images/guess.png",
                            height: 32,
                            width: 35,
                          ),
                          const Text("Guess",
                              style: TextStyle(color: Colors.white)),
                          Text("$UGuesses",
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
              SizedBox(
                height: MediaQuery.of(context).size.height * .025,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Guess the Number 1 to 20! That's what I'm thinking?",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .06,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _key,
                        child: Visibility(
                          visible: guessEntry,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Wrong Entry!";
                              }
                            },
                            controller: _guessController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      _guessController.clear();
                                    },
                                    child: Icon(Icons.clear_rounded)),
                                filled: true,
                                hintText: "Guess the Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    InkWell(
                      onTap: () {
                        initializeInterstitialAds();

                        if (INTisReady) {
                          AppLovinMAX.showInterstitial(
                              _interstitial_ad_unit_id);
                        }
                        setState(() {
                          if (_key.currentState!.validate()) {
                            Guessnocheck();
                            gettingFDB();
                            schek();
                          }
                        });
                      },
                      child: Visibility(
                        visible: checkButton,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.width * .51,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.save),
                              Text(
                                "Check",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Visibility(
                      visible: adBtnshow,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black38),
                          onPressed: () {
                            AdRewardinGuess();
                          },
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Guess More",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
