// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:niktobonanza/utils/Toast.dart';

// import '../utils/earn_room_pageview.dart';
// import 'ScratchRoom.dart';
// class EarnRoom extends StatefulWidget {
//   const EarnRoom({Key? key}) : super(key: key);

//   @override
//   State<EarnRoom> createState() => _EarnRoomState();
// }
// class _EarnRoomState extends State<EarnRoom> {

//   late PageController _pageController;
//   final _authUID=  FirebaseAuth.instance.currentUser!.uid;

//   // User Data
//   var Coins;
//   var Level;
//   var Cash;
//   var Name;
//   var Email;
//   @override


//   final reference = FirebaseDatabase.instance.ref("Workers");



//   void initState() {
//     super.initState();
//     GettingFirebaseData();
//     setState(() {

//     });

//     _pageController = PageController(
//       initialPage: 0,

//     );
//   }


//   GettingFirebaseData(){

    
//     reference.child(_authUID).child("Coins").onValue.listen((event) {

//       var CoinsFromDB = event.snapshot.value;
//       setState(() {
//         Coins = CoinsFromDB;

//       });
//     });
//     reference.child(_authUID).child("Level").onValue.listen((event) {

//       var LevelFromFirebase = event.snapshot.value;
//       setState(() {
//         Level = LevelFromFirebase;

//       });
//     });

//     reference.child(_authUID).child("Cash").onValue.listen((event) {

//       var CashFromDB = event.snapshot.value;
//       setState(() {

//         Cash = CashFromDB;

//       });

//     });
//   }



//   Widget build(BuildContext context) {
//     return Container(

//       decoration: BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomLeft,
//               colors: [Colors.blue.shade700,Colors.blue.shade200]

//           )
//       ),


//       // App bar

//      child: Scaffold(
//        backgroundColor: Colors.transparent,
//        appBar: AppBar(
//          elevation: 0,
//          backgroundColor: Colors.blue[700],
//          title: Row(children: [Icon(Icons.line_weight_rounded),SizedBox(width: MediaQuery.of(context).size.width *.02,),Text("Earn Room")],),
//        ),
//        body: SingleChildScrollView(
//          child: Column(
//            children: [






//              SizedBox(height: MediaQuery.of(context).size.height * .06,),

//              Center(
//                child: Container(

//                  height: MediaQuery.of(context).size.height *0.15,
//                  width: MediaQuery.of(context).size.width *0.9,

//                  decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(15),
//                    color: Colors.black38),

//                  child:

//                      Row(

//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        crossAxisAlignment:CrossAxisAlignment.center,
//                        children: [
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Image.asset("assets/images/coin.png",height: 30,width: 30,),
//                              const   SizedBox(height: 5,),
//                              const  Text("Coins",style: TextStyle(color: Colors.white),),

//                                  Text("$Coins",style: TextStyle(color: Colors.yellowAccent)),

//                            ],
//                          ),
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Image.asset("assets/images/rank.png",height: 35,width: 35,),
//                              const   Text("Levels",style: TextStyle(color: Colors.white)),
//                                   Text("$Level",style: TextStyle(color: Colors.yellow)),
//                            ],
//                          ),
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Image.asset("assets/images/btc.png",height: 30,width: 30,),
//                              const   SizedBox(height: 2,),


//                                Text("Cash",style: TextStyle(color: Colors.white)),

//                                Text("\ $Cash",style: TextStyle(color: Colors.yellowAccent)),
//                            ],
//                          ),
//                        ],

//                  ),

//                ),
//              ),
//              SizedBox(height: MediaQuery.of(context).size.height *0.04,),
//              SizedBox(
//                height: MediaQuery.of(context).size.height *0.445,
//                child: PageView(
//                  controller: _pageController,
//                  children:  [

//                     EarnRoomPageView(GameName: "Guess Game", GameDesc: 'Play this Game and Earn 80,000 Coins',GameCoin: "80,000 Coins",onpress: (){
//                       setState(() {

//                       });
//                     },),
//                     EarnRoomPageView(GameName: "Scratch Room",GameDesc: "Play Guess Game and Earn 10,000 Coins",GameCoin: "20,000 Coins",onpress: (){
//                       // Scratch Screen
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => const ScratchRoom(),));
//                     },),
//                     EarnRoomPageView(GameName: "Lucky Quest",GameDesc: "Play Guess Game and Earn 50,000 Coins",GameCoin: "10,000 Coins",onpress: (){},),



//                  ],
//                ),
//              ),


//            ],
//          ),
//        ),
//      ),
//     );
//   }
// }

