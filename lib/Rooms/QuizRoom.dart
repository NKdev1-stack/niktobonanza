import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/Rooms/MainMenueRoom.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
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
  final String _rewarded_ad_unit_id = "2eda4b8d0c86c6fc";

  var _interstitialRetryAttempt = 0;
  var _rewardedAdRetryAttempt = 0;

  bool INTisReady = true;
  bool RWDisReady = true;
  final String _ad_unit_id = "45a079225c19874b";

// Advertisement



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
     /// Int Ad
        _DBref.child(_UAuth.currentUser!.uid).update({
          "I_ID": ServerValue.increment(1),
        }),
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
            'Quizez': 5,
          }),
          // Update RWD AD in DB
          _DBref.child(_UAuth.currentUser!.uid).update({
            'R_ID': ServerValue.increment(1),
          }),

          setState(() {
            _defaultopt1 = true;
            _defaultopt2 = true;
            _defaultOpt3 = true;
            QuizShow = true;
            AdBtn = false;
            Quizez = 5;
          })
           },
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
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
    loadAdRINT();
    loadAdRW();
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
    
    showAdRW();
      
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
                       
                        if (_Opt2 == _correct) {
                          showAdINT();
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
                       
                        if (_Opt3 == _correct) {
                          showAdINT();
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
                        updateOnAd();
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
}
