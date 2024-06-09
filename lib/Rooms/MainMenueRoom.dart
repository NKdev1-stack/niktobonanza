import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/Rooms/CaptchaRooms.dart';
import 'package:niktobonanza/Rooms/GuessGame.dart';
import 'package:niktobonanza/Rooms/QuizRoom.dart';
import 'package:niktobonanza/Rooms/ScratchRoom.dart';
import 'package:niktobonanza/Rooms/wall.dart';
import 'package:niktobonanza/pmnt.dart';
import '../utils/Toast.dart';
import 'DiceRoom.dart';

class MainMenueRoom extends StatefulWidget {
  const MainMenueRoom({Key? key}) : super(key: key);

  @override
  State<MainMenueRoom> createState() => _MainMenueRoomState();
}

class _MainMenueRoomState extends State<MainMenueRoom> {
  var UNiktos = 0;
  var ULevel = 0;
  var UName = "";
  var PosterTitle1 = "";
  var PosterTitle2 = "";
  var PosterDec1 = "";
  var PosterDec2 = "";
  var PosterLink1 = "";
  var PosterLink2 = "";
  var visit = "";

  //StatusEnd

  final _authID = FirebaseAuth.instance;
  final _DBref = FirebaseDatabase.instance.ref("Workers");
  final _ADref = FirebaseDatabase.instance.ref("Admin");
 

// Coins Adding Code
//  _DBref.child(_authID.currentUser!.uid).update({
//           "I_ID": ServerValue.increment(1),
//           "Niktos": ServerValue.increment(5),
//         });

  @override
  void initState() {
    _DBref.child(_authID.currentUser!.uid).update({"AppVersion": "1.56.0"});
   
    Getdata();

    super.initState();
  }

  // Firebase Fetch Method

  Getdata() {
    // C_NIKTO Getting
    _DBref.child(_authID.currentUser!.uid)
        .child("Niktos")
        .onValue
        .listen((event) {
      setState(() {
        UNiktos = int.parse(event.snapshot.value.toString());
      });
    });

    // NameGetting

    _DBref.child(_authID.currentUser!.uid)
        .child("Name")
        .onValue
        .listen((event) {
      setState(() {
        UName = event.snapshot.value.toString();
      });
    });

    // LevelGetting

    _DBref.child(_authID.currentUser!.uid)
        .child("Level")
        .onValue
        .listen((event) {
      setState(() {
        ULevel = int.parse(event.snapshot.value.toString());
      });
    });

    // Poster1
    // Title
    _ADref.child("Poster1").child("Adtitle").onValue.listen((event) {
      setState(() {
        PosterTitle1 = event.snapshot.value.toString();
      });
    });
// Visit
    _ADref.child("Visit").child("Link").onValue.listen((event) {
      setState(() {
        visit = event.snapshot.value.toString();
      });
    });

    // Poster Description
    _ADref.child("Poster1").child("Ad1").onValue.listen((event) {
      setState(() {
        PosterDec1 = event.snapshot.value.toString();
      });
    });

    // Poster Button Link
    _ADref.child("Poster1").child("Link").onValue.listen((event) {
      setState(() {
        PosterLink1 = event.snapshot.value.toString();
      });
    });

    // Poster2
    // Title
    _ADref.child("Poster2").child("Adtitle").onValue.listen((event) {
      setState(() {
        PosterTitle2 = event.snapshot.value.toString();
      });
    });

    // Poster Description
    _ADref.child("Poster2").child("Ad2").onValue.listen((event) {
      setState(() {
        PosterDec2 = event.snapshot.value.toString();
      });
    });

    // Poster Button Link
    _ADref.child("Poster2").child("Link").onValue.listen((event) {
      setState(() {
        PosterLink2 = event.snapshot.value.toString();
      });
    });
  }

  // Opening URL Methods
  void _PosterLink1MethodToOpen() async {
    if (PosterLink1 != null) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: PosterLink1,
      );
      intent.launch();
    } else {
      Utils().message("No URL Found!");
    }
  }

  PosterLink2MethodToOpen() async {
    if (PosterLink2 != null) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: PosterLink2,
      );
      intent.launch();
    } else {
      Utils().message("No URL Found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
                onTap: () {
                  Info();
                },
                child: const Icon(
                  (Icons.help),
                  color: Colors.white,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PMNT(),
                      ));
                },
                child: const Icon(
                  (Icons.account_balance_wallet_rounded),
                  color: Colors.white,
                ),
              ),
            ),
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade800,
          title: Text(
            "NiKto",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 1,
              height: 0.8,
              color: Colors.grey,
            ),

            Material(
              color: Colors.transparent,
              elevation: 20,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: CircleAvatar(
                        maxRadius: 28,
                        backgroundImage: NetworkImage(
                            "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                Text(
                                  "$UName!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "NiKtos: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  "$UNiktos",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () async {
                            AndroidIntent intent = AndroidIntent(
                              action: 'android.intent.action.VIEW',
                              data:
                                  "https://play.google.com/store/apps/details?id=com.nkdevelopers.niktoearningapp",
                            );
                            intent.launch();
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            // Page View
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              child: PageView(
                children: [
                  // New Update Room or Notice Room
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 11),
                          child: Row(
                            children: [
                              // Game Name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$PosterTitle1",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$PosterDec1",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Slide Left For More >",
                                      style: TextStyle(
                                        color: Colors.amber,
                                      )),
                                ],
                              ),

                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  _PosterLink1MethodToOpen();
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                    "Check Out!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Interesting Updates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 11),
                          child: Row(
                            children: [
                              // Game Name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$PosterTitle2",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$PosterDec2",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),

                              Spacer(),
                              InkWell(
                                onTap: () {
                                  PosterLink2MethodToOpen();
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                    "Check Out",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Youtube Channel
                ],
              ),
            ),

            SizedBox(height: 25),

            // ************ MENU  *************
            Expanded(
              child: ListView(
                children: [
                  //Menu 1 Populars
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Most Popular",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    thickness: 0.9,
                    endIndent: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                             Gift();
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.30,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1702399263/present_2743217_1_b6g42i.png"),
                                    ),
                                    Text(
                                      "Gift Box",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ScratchRoom(),
                                  ));
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.30,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1702399221/scratch_6027216_1_zoh7so.png"),
                                    ),
                                    Text(
                                      "Scratches",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Captcha()));
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.30,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1702399377/robot_189740_l9rr8s.png"),
                                    ),
                                    Text(
                                      "Captchas",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Menu 2 Easy to earn
                  const Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12, top: 20),
                    child: Text(
                      "Easy Jobs",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    thickness: 0.9,
                    endIndent: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WallRoom(),));

                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.30,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1702558732/discount-tag_6149117_dqfaii.png"),
                                    ),
                                    Text(
                                      "Offers",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                             

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Dicer(),
                                  ));
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.30,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1702399601/dice_8336933_bdqmxv.png"),
                                    ),
                                    Text(
                                      "Lucky Dice",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GuessRoom(),
                                  ));
                            },
                            child: Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.30,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1685627011/icons8-woman-64_u9ckgt.png"),
                                    ),
                                    Text(
                                      "Guess Game",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Menu 3 Company info
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12, top: 20),
                    child: Text(
                      "Others",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    thickness: 0.9,
                    endIndent: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            color: Colors.transparent,
                            elevation: 10,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => QuizRoom(),
                                          ));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1689243113/n_qkqov0.png"),
                                    ),
                                  ),
                                  Text(
                                    "Quiz",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 10,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      AndroidIntent intent = AndroidIntent(
                                        action: 'android.intent.action.VIEW',
                                        data: "$visit",
                                      );
                                      intent.launch();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://res.cloudinary.com/dghloo9lv/image/upload/v1702399707/instagram_3955024_nx6krq.png"),
                                    ),
                                  ),
                                  Text(
                                    "Instagram",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 10,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      AndroidIntent intent = AndroidIntent(
                                        action: 'android.intent.action.VIEW',
                                        data: "https://twitter.com/NKDev58",
                                      );
                                      intent.launch();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          "https://static.dezeen.com/uploads/2023/07/x-logo-twitter-elon-musk_dezeen_2364_col_0.jpg"),
                                    ),
                                  ),
                                  Text(
                                    "Twitter",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> Info() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("How To Use")),
          content: Text(
              "Perform Different Tasks, Play Games and Collect NiKtos once you reached "
               "the Minimum Threshold which is 1600 NiKtos than choose the wallet and submit Withdrawal Request."
              "Once System Received your Withdrawal Request than After Completing Security Checkup "
              "We will release your payouts instantly."
              "Keep In Mind. Use Correct Coinbase,Binance,Paypal and Faucet Email for Withdrawal Otherwise we are not responsible if you don't receive your money."
              "\nContact with Support Team via Twitter or Instagram for instant help. For OfferWall Once You complete the offer send Screenshot with Email on instagram. We will pay you extra Dollars for Your Work"),
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

  Future<void> Gift() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
          title: Center(child: Text("Sorry! Try Again later")),
          content: Column(
            
            mainAxisSize: MainAxisSize.min,
              children: [
                Image.network("https://res.cloudinary.com/dghloo9lv/image/upload/v1692711063/Pickle_rick_Ramen_on_a_street_food_counter_pixel_a-removebg-preview_s0whdi.png",height: 200,),
                SizedBox(height: 20,),
                Text(
              "Curretly No Gift Found For You Try Again later ",style: TextStyle(
                fontSize: 17
              ),)
              ],
          ),
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
