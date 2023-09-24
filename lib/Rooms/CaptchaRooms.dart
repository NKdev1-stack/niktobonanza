import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/utils/Toast.dart';

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
        _DBref.child(_UAuth.currentUser!.uid).update({
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
          // Giving More Chances
          _DBref.child(_UAuth.currentUser!.uid).update({
            'Captchas': 5,
          });
          // Update RWD AD in DB
          _DBref.child(_UAuth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          });
        }));
  }

  @override
  void initState() {
    initializeRewardedAds();
    initializeInterstitialAds();
    RndGeneratorMethod();
    getUserData();
    super.initState();
  }

  //Firebase Data Update

  updateUserData() {
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
    initializeRewardedAds();
    if (RWDisReady) {
      AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);
    }

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
                            initializeInterstitialAds();
                            if (INTisReady) {
                              AppLovinMAX.showInterstitial(
                                  _interstitial_ad_unit_id);
                            }
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
