import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/Rooms/MainMenueRoom.dart';
import '../utils/Toast.dart';
import 'Models/QuizModel.dart';
import 'package:http/http.dart' as http;

class QuizRoom extends StatefulWidget {
  const QuizRoom({super.key});

  @override
  State<QuizRoom> createState() => _QuizRoomState();
}

class _QuizRoomState extends State<QuizRoom> {
// Data

  var _Opt1 = "Loading...",
      _Opt2 = "Loading...",
      _Opt3 = "Loading...",
      _correct = "Loading...",
      _Quiz = "Loading...";
  var _defaultopt1 = true;
  var _correctOpt1 = false;
  var _wrongOpt1 = false;

  var _defaultopt2 = true;
  var _correctOpt2 = false;
  var _wrongOpt2 = false;

  var _defaultOpt3 = true;
  var _correctOpt_3 = false;
  var _wrongOpt3 = false;

  var clicked = true;
  var QuizShow = true;

  var UNiktos = 0;

 final String _interstitial_ad_unit_id = "450bc990d365b2fb";
 final String _rewarded_ad_unit_id =  "2eda4b8d0c86c6fc";

 var _interstitialRetryAttempt = 0;
 var _rewardedAdRetryAttempt = 0;

 bool INTisReady = true;
 bool  RWDisReady = true;
 final String _ad_unit_id = "45a079225c19874b";

// Advertisement

// / Int Ad
 initializeInterstitialAds() async{
   INTisReady = (await AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id))!;

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

       print('Interstitial ad failed to load with code ' + error.code.toString() + ' - retrying in ' + retryDelay.toString() + 's');

       Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
         AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
       });
     },
     onAdDisplayedCallback: (ad) {
// Int Ad
  _DBref.child(_UAuth.currentUser!.uid).update({
          "I_ID": ServerValue.increment(1),
        });


     },
     onAdDisplayFailedCallback: (ad, error) {
       AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
     },
     onAdClickedCallback: (ad) {

     },
     onAdHiddenCallback: (ad) {

     },
   ));

   // Load the first interstitial
   AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
 }

 

// Reward Ad

void initializeRewardedAds()async {
   RWDisReady =  (await AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id))!;

   AppLovinMAX.loadRewardedAd(_rewarded_ad_unit_id);

   AppLovinMAX.setRewardedAdListener(
       RewardedAdListener(onAdLoadedCallback: (ad) {
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
                 error.code.toString() + ' - retrying in ' +
                 retryDelay.toString() + 's');

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
           onAdClickedCallback: (ad) {

           },
           onAdHiddenCallback: (ad) {

           },
           onAdReceivedRewardCallback: (ad, reward) {

              // Reward Ad
  // Giving More Chances
          _DBref.child(_UAuth.currentUser!.uid).update({
            'Quizez': 5,
          });
          // Update RWD AD in DB
          _DBref.child(_UAuth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          });

          setState(() {
            _defaultopt1 = true;
            _defaultopt2 = true;
            _defaultOpt3 = true;
            QuizShow = true;
            AdBtn = false;
            Quizez = 5;
          });
           }));
 }


         
 


// DB
  final _DBref = FirebaseDatabase.instance.ref("Workers");
  final _UAuth = FirebaseAuth.instance;
  var Quizez = 0;
  var AdBtn = false;

//QTCH
  void QTCH() {
    _DBref.child(_UAuth.currentUser!.uid).update({
      "T_Q": ServerValue.increment(1),
    });
  }

  void initState() {
    _QUIZAPI();
    initializeRewardedAds();
   initializeInterstitialAds();
    fetchdata();

    super.initState();
  }

  void fetchdata() {
    _DBref.child(_UAuth.currentUser!.uid)
        .child("Quizez")
        .onValue
        .listen((event) {
      Quizez = int.parse(event.snapshot.value.toString());
    });

    _DBref.child(_UAuth.currentUser!.uid)
        .child("Niktos")
        .onValue
        .listen((event) {
      UNiktos = int.parse(event.snapshot.value.toString());
    });
  }

  void IncrementMethod() {
    if (Quizez > 0) {
      _DBref.child(_UAuth.currentUser!.uid).update({
        "Quizez": ServerValue.increment(-1),
      });
    }
  }

  void updateOnAd() {
    if (Quizez <= 0) {
      initializeRewardedAds();

                          if (RWDisReady) {
                            AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);
                          }
    }
  }

  void refresh() {
    setState(() {
      _defaultopt1 = true;
      _defaultopt2 = true;
      _defaultOpt3 = true;
      QuizShow = true;
    });
  }

  List<QuizModel> _QUIZLIST = [];

  Future<List<QuizModel>> _QUIZAPI() async {
    final response =
        await http.get(Uri.parse("https://the-trivia-api.com/v2/questions"));
    var data = jsonDecode(response.body.toString());
    if (Quizez <= 0) {
      setState(() {
        _defaultopt1 = false;
        _defaultopt2 = false;
        _defaultOpt3 = false;
        QuizShow = false;
        AdBtn = true;
      });
    } else {
      AdBtn = false;
    }
    if (response.statusCode == 200) {
      _QUIZLIST.clear();
      for (Map i in data) {
        _QUIZLIST.add(QuizModel.fromJson(i));
      }

      setState(() {
        _correct = _QUIZLIST[0].correctAnswer.toString();
        _Quiz = _QUIZLIST[0].question!.text.toString();
      });
      setState(() {
        // RandomOptions Showing Strategy
        Random rnd = Random();
        var rnds = rnd.nextInt(6) * 2;
        print("$rnds");
        if (rnds <= 3) {
          setState(() {
            _Opt3 = _QUIZLIST[0].incorrectAnswers!.first.toString();
            _Opt2 = _QUIZLIST[0].incorrectAnswers!.last.toString();
            _Opt1 = _QUIZLIST[0].correctAnswer.toString();
          });
        } else if (rnds <= 6 && rnds >= 3) {
          setState(() {
            _Opt1 = _QUIZLIST[0].incorrectAnswers!.first.toString();
            _Opt2 = _QUIZLIST[0].incorrectAnswers!.last.toString();
            _Opt3 = _QUIZLIST[0].correctAnswer.toString();
          });
        } else if (rnds <= 8 && rnds >= 6) {
          setState(() {
            _Opt3 = _QUIZLIST[0].incorrectAnswers!.first.toString();
            _Opt1 = _QUIZLIST[0].incorrectAnswers!.last.toString();
            _Opt2 = _QUIZLIST[0].correctAnswer.toString();
          });
        } else if (rnds <= 10 && rnds >= 8) {
          setState(() {
            _Opt2 = _QUIZLIST[0].incorrectAnswers!.first.toString();
            _Opt3 = _QUIZLIST[0].incorrectAnswers!.last.toString();
            _Opt1 = _QUIZLIST[0].correctAnswer.toString();
          });
        } else if (rnds <= 12 && rnds >= 10) {
          setState(() {
            _Opt2 = _QUIZLIST[0].incorrectAnswers!.first.toString();
            _Opt1 = _QUIZLIST[0].incorrectAnswers!.last.toString();
            _Opt3 = _QUIZLIST[0].correctAnswer.toString();
          });
        }
      });

      print('${_QUIZLIST[0].question!.text.toString()}');
      print('${_QUIZLIST[0].correctAnswer}');
      print('${_QUIZLIST[0].incorrectAnswers!.first}');
      print('${_QUIZLIST[0].incorrectAnswers!.last}');

      return _QUIZLIST;
    } else {
      return _QUIZLIST;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  MaxAdView(
          adUnitId:_ad_unit_id,
          adFormat: AdFormat.banner,
          listener: AdViewAdListener(onAdLoadedCallback: (ad) {

          }, onAdLoadFailedCallback: (adUnitId, error) {

          }, onAdClickedCallback: (ad) {

          }, onAdExpandedCallback: (ad) {

          }, onAdCollapsedCallback: (ad) {

          }),
        ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainMenueRoom(),
                    ));
              },
              child: Icon(
                Icons.cancel_outlined,
                size: 38,
              )),
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "$Quizez",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          )
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Image.network(
                  "https://res.cloudinary.com/dghloo9lv/image/upload/v1689243113/n_qkqov0.png",
                  height: 160,
                ),
              )),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        initState();
                      });
                    },
                    child: Visibility(
                        visible: QuizShow,
                        child: Text(
                          "$_Quiz",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ))),
              ),

              // OPTION 1
              // Default
              InkWell(
                onTap: clicked
                    ? () {
                      initializeInterstitialAds();

                          if (INTisReady) {
                            AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
                          }
                        if (_Opt1 == _correct) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("You Won 5 Coins")));

                          setState(() {
                            _DBref.child(_UAuth.currentUser!.uid).update({
                              "Niktos": ServerValue.increment(5),
                              "QT": ServerValue.increment(1)
                            });
                            IncrementMethod();
                            clicked = false;
                            _correctOpt1 = true;
                            _defaultopt1 = false;
                          });
                          Timer.periodic(Duration(seconds: 1), (timer) {
                            setState(() {
                              _correctOpt1 = false;
                              _defaultopt1 = true;
                              clicked = true;
                              initState();
                            });
                          });
                        } else {
                          setState(() {
                            IncrementMethod();
                            clicked = false;
                            _defaultopt1 = false;
                            _wrongOpt1 = true;
                          });

                          Timer.periodic(Duration(seconds: 1), (timer) {
                            setState(() {
                              _wrongOpt1 = false;
                              _defaultopt1 = true;
                              clicked = true;
                              initState();
                            });
                          });
                        }
                      }
                    : () {},
                child: Visibility(
                  visible: _defaultopt1,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "$_Opt1",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              // For Correct
              Visibility(
                visible: _correctOpt1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "$_Opt1",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              // For Wrong
              Visibility(
                visible: _wrongOpt1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "$_Opt1",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                height: 12,
              ),

              // OPTION 2

              // Default
              InkWell(
                onTap: clicked
                    ? () {
                          initializeInterstitialAds();

                          if (INTisReady) {
                            AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
                          }
                        if (_Opt2 == _correct) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("You Won 8 Coins")));

                          setState(() {
                            _DBref.child(_UAuth.currentUser!.uid).update({
                              "Niktos": ServerValue.increment(8),
                              "QT": ServerValue.increment(1)
                            });
                            IncrementMethod();
                            clicked = false;
                            _correctOpt2 = true;
                            _defaultopt2 = false;
                          });
                          Timer.periodic(Duration(seconds: 1), (timer) {
                            setState(() {
                              _correctOpt2 = false;
                              _defaultopt2 = true;
                              clicked = true;
                              initState();
                            });
                          });
                        } else {
                          setState(() {
                            IncrementMethod();

                            _defaultopt2 = false;
                            _wrongOpt2 = true;
                            clicked = false;
                          });

                          Timer.periodic(Duration(seconds: 1), (timer) {
                            setState(() {
                              _wrongOpt2 = false;
                              _defaultopt2 = true;
                              clicked = true;
                              initState();
                            });
                          });
                        }
                      }
                    : () {},
                child: Visibility(
                  visible: _defaultopt2,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "$_Opt2",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              // For Correct
              Visibility(
                visible: _correctOpt2,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "$_Opt2",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              // For Wrong
              Visibility(
                visible: _wrongOpt2,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "$_Opt2",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                height: 12,
              ),

              // Option 3
              // For Default
              InkWell(
                onTap: clicked
                    ? () {
                            initializeInterstitialAds();

                          if (INTisReady) {
                            AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
                          }
                        if (_Opt3 == _correct) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("You Won 8 Coins")));

                          _DBref.child(_UAuth.currentUser!.uid).update({
                            "Niktos": ServerValue.increment(8),
                            "QT": ServerValue.increment(1)
                          });
                          setState(() {
                            IncrementMethod();
                            clicked = false;
                            _correctOpt_3 = true;
                            _defaultOpt3 = false;
                          });
                          Timer.periodic(Duration(seconds: 1), (timer) {
                            setState(() {
                              IncrementMethod();
                              _correctOpt_3 = false;
                              _defaultOpt3 = true;
                              clicked = true;
                              initState();
                            });
                          });
                        } else {
                          setState(() {
                            IncrementMethod();
                            clicked = false;
                            _defaultOpt3 = false;
                            _wrongOpt3 = true;
                          });

                          Timer.periodic(Duration(seconds: 1), (timer) {
                            setState(() {
                              _wrongOpt3 = false;
                              _defaultOpt3 = true;
                              clicked = true;
                              initState();
                            });
                          });
                        }
                      }
                    : () {},
                child: Visibility(
                  visible: _defaultOpt3,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "$_Opt3",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              // For Correct
              Visibility(
                visible: _correctOpt_3,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "$_Opt3",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              //For Wrong
              Visibility(
                visible: _wrongOpt3,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "$_Opt3",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                height: 12,
              ),

              Visibility(
                visible: AdBtn,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.redAccent)),
                    onPressed: () {
                      setState(() {
                        if (UNiktos >= 1000) {
                          ERNLMT();
                        } else {
                          updateOnAd();
                        }
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "Get More Quizez",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        IconButton(onPressed: () {}, icon: Icon(Icons.quiz))
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> ERNLMT() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("Limit Exccessed")),
          content: Text(
              "You are Level 1 User. So Level 1 User Cannot send withdraw of more than 1000 Coins. Keep Earning Daily and Increase your Level and Earn More Money."),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(fontSize: 16, color: Colors.red.shade900),
                  )),
            )
          ],
        );
      },
    );
  }
}
