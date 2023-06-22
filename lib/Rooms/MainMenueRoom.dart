import 'dart:math';
import 'package:android_intent/android_intent.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/BanksRooms/Coinbase.dart';
import 'package:niktobonanza/Rooms/CaptchaRooms.dart';
import 'package:niktobonanza/Rooms/GuessGame.dart';
import 'package:niktobonanza/Rooms/ScratchRoom.dart';

import '../utils/Toast.dart';
import 'DiceRoom.dart';
class MainMenueRoom extends StatefulWidget {
  const MainMenueRoom({Key? key}) : super(key: key);

  @override
  State<MainMenueRoom> createState() => _MainMenueRoomState();
}

class _MainMenueRoomState extends State<MainMenueRoom> {

    var UNiktos =0;
    var ULevel = 0;
    var UName = "";
    var PosterTitle1 = "";
    var PosterTitle2 = "";
    var PosterDec1 ="";
    var PosterDec2 ="";
    var PosterLink1 ="";
    var PosterLink2 ="";

    final _authID = FirebaseAuth.instance;
    final _DBref = FirebaseDatabase.instance.ref("Workers");
    final _ADref = FirebaseDatabase.instance.ref("Admin");

    // Advertisement
    // Advertisements

    final String _interstitial_ad_unit_id = "6520fe898d527766";
    final String _rewarded_ad_unit_id =  "508e2a6446c03e82";

    var _interstitialRetryAttempt = 0;
    var _rewardedAdRetryAttempt = 0;

    bool INTisReady = true;
    bool  RWDisReady = true;
    


    

    // Int Ad
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

          _DBref.child(_authID.currentUser!.uid)
              .update({

            "I_ID" : ServerValue.increment(1),
            "Niktos" : ServerValue.increment(50),
          });

        },
        onAdDisplayFailedCallback: (ad, error) {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
          Utils().message("Please Wait! Or try Again After Some Time");

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

                // Giving More Chances
                _DBref.child(_authID.currentUser!.uid)
                    .update({

                  'Niktos': ServerValue.increment(10),

                });
                // Update RWD AD in DB
                _DBref.child(_authID.currentUser!.uid)
                    .update({

                  'R_ID': ServerValue.increment(1),

                });
              }));
    }
    @override
  void initState() {
      initializeInterstitialAds();
      initializeRewardedAds();
      Getdata();
      super.initState();
  }
  
  
  // Firebase Fetch Method
    
    Getdata(){
      // C_NIKTO Getting
      _DBref.child(_authID.currentUser!.uid)
          .child("Niktos")
          .onValue.listen((event) {

            setState(() {
              UNiktos = int.parse(event.snapshot.value.toString());
            });
      });


      // NameGetting
      
      _DBref.child(_authID.currentUser!.uid)
      .child("Name")
      .onValue.listen((event) {

        setState(() {
          UName = event.snapshot.value.toString();
        });
      });

      // LevelGetting

      _DBref.child(_authID.currentUser!.uid)
          .child("Level")
          .onValue.listen((event) {

        setState(() {
          ULevel = int.parse(event.snapshot.value.toString());
        });
      });

      // Poster1
        // Title
      _ADref.child("Poster1")
          .child("Adtitle")
          .onValue.listen((event) {

        setState(() {
          PosterTitle1 = event.snapshot.value.toString();
          
        });
      });

      // Poster Description
      _ADref.child("Poster1")
          .child("Ad1")
          .onValue.listen((event) {

        setState(() {
          PosterDec1 = event.snapshot.value.toString();
        });
      });

      // Poster Button Link
      _ADref.child("Poster1")
          .child("Link")
          .onValue.listen((event) {

        setState(() {
         PosterLink1 = event.snapshot.value.toString();
        });
      });

      // Poster2
      // Title
      _ADref.child("Poster2")
          .child("Adtitle")
          .onValue.listen((event) {

        setState(() {
          PosterTitle2 = event.snapshot.value.toString();
        });
      });

      // Poster Description
      _ADref.child("Poster2")
          .child("Ad2")
          .onValue.listen((event) {

        setState(() {
          PosterDec2 = event.snapshot.value.toString();
        });
      });

      // Poster Button Link
      _ADref.child("Poster2")
          .child("Link")
          .onValue.listen((event) {

        setState(() {
          PosterLink2 = event.snapshot.value.toString();
        });
      });

    }


    // Opening URL Methods
   void _PosterLink1MethodToOpen() async {

     if(PosterLink1 != null){
       AndroidIntent intent = AndroidIntent(
         action: 'android.intent.action.VIEW',
         data: PosterLink1,
       );
       intent.launch();

     }else{
       Utils().message("No URL Found!");
     }

    }

    PosterLink2MethodToOpen() async {
      if(PosterLink2 != null){

        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: PosterLink2,
        );
        intent.launch();

      }else{
        Utils().message("No URL Found!");
      }
    }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
                onTap: (){
                  Info();
                },
                child: const Icon((Icons.help))),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const CoinbaseB(),));
                  },

                  child:const Icon((Icons.account_balance_wallet_rounded))
              ),
            ),
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade800,
          title: Text("NiktoCash"),
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

                height: MediaQuery.of(context).size.height *0.18,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: CircleAvatar(
                        maxRadius: 28,
                        backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/236/236832.png"),
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
                                Text("Name: ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),

                                Text("$UName",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
                                Icon(Icons.star,size: 10,color: Colors.white,)
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Text("Niktos: ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20),),
                                Text("$UNiktos",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:20),),




                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Text("Level: ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:18),),
                                Text("$ULevel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:18),),




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
                          onTap: ()async{
                            AndroidIntent intent = AndroidIntent(
                              action: 'android.intent.action.VIEW',
                              data: "https://play.google.com/store/apps/details?id=com.nkdevelopers.niktoearningapp",
                            );
                            intent.launch();
                          },
                          child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                          color: Colors.white,
                            border:Border.all(
                              color: Colors.grey),

                            borderRadius: BorderRadius.circular(8),
                          ),
                            child: Icon(Icons.star,color: Colors.amber,),

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),




            SizedBox(height: 20,),



            // Page View
            SizedBox(

              height: MediaQuery.of(context).size.height *0.14,
              child: PageView(
                children: [
                  // New Update Room or Notice Room
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.14,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12,right: 11),
                          child: Row(
                            children: [
                              // Game Name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("$PosterTitle1",style: TextStyle(color: Colors.white,fontSize: 18),),
                                  SizedBox(height: 5,),
                                  Text("$PosterDec1",style: TextStyle(color: Colors.white,fontSize: 18),),

                                  SizedBox(height: 8,),
                                  Text("Slide Left For More >",style: TextStyle(color: Colors.green,)),
                                ],
                              ),

                              Spacer(),
                              InkWell (
                                onTap: ()async{

                                  _PosterLink1MethodToOpen();

                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *0.065,
                                  width: MediaQuery.of(context).size.width *0.32,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(child: Text("Check Out!",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)),
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
                        height: MediaQuery.of(context).size.height *0.14,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12,right: 11),
                          child: Row(
                            children: [
                              // Game Name
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("$PosterTitle2",style: TextStyle(color: Colors.white,fontSize: 18),),
                                  SizedBox(height: 5,),
                                  Text("$PosterDec2",style: TextStyle(color: Colors.white,fontSize: 18),),

                                  SizedBox(height: 8,),
                                ],
                              ),

                              Spacer(),
                              InkWell(
                                onTap: (){PosterLink2MethodToOpen();},
                                child: Container(
                                  height: MediaQuery.of(context).size.height *0.065,
                                  width: MediaQuery.of(context).size.width *0.32,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(child: Text("Check Out",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)),
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
          child: ListView(children: [

            //Menu 1 Populars
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("Most Popular",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
            Divider(thickness: 0.9,endIndent: 1,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        initializeInterstitialAds();
                        if (INTisReady) {
                          AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
                        }
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height *0.15,
                          width: MediaQuery.of(context).size.width *0.30,
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:AssetImage("assets/images/gift.png"),
                              ),
                              Text("Gift Box",style: TextStyle(color: Colors.white,fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ScratchRoom(),));
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height *0.15,
                          width: MediaQuery.of(context).size.width *0.30,
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685626100/icons8-foreclosure-96_nlqizc.png"),
                              ),
                              Text("Scratches",style: TextStyle(color: Colors.white,fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Captcha(),));
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height *0.15,
                          width: MediaQuery.of(context).size.width *0.30,
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685626230/icons8-bot-96_f8tewf.png"),
                              ),
                              Text("Captchas",style: TextStyle(color: Colors.white,fontSize: 16),)
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
            Padding(
              padding: const EdgeInsets.only(left: 12.0,right:12,top: 20),
              child: Text("Easy Jobs",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
            Divider(thickness: 0.9,endIndent: 1,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){

                        initializeRewardedAds();
                        if (RWDisReady) {
                          AppLovinMAX.showRewardedAd(_rewarded_ad_unit_id);

                        }
                             },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height *0.15,
                          width: MediaQuery.of(context).size.width *0.30,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685626586/icons8-marketing-agency-64_h57xye.png"),
                              ),
                              Text("Videos",style: TextStyle(color: Colors.white,fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context) => const Dicer(),));
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height *0.15,
                          width: MediaQuery.of(context).size.width *0.30,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor:Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685626706/icons8-roulette-96_kk1ts7.png"),
                              ),
                              Text("Lucky Dice",style: TextStyle(color: Colors.white,fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const GuessRoom(),));
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: MediaQuery.of(context).size.height *0.15,
                          width: MediaQuery.of(context).size.width *0.30,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(15)

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685627011/icons8-woman-64_u9ckgt.png"),
                              ),
                              Text("Guess Game",style: TextStyle(color: Colors.white,fontSize: 16),)
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
              padding: const EdgeInsets.only(left: 12.0,right:12,top: 20),
              child: Text("Others",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
            Divider(thickness: 0.9,endIndent: 1,),
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
                        height: MediaQuery.of(context).size.height *0.15,
                        width: MediaQuery.of(context).size.width *0.30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15)

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap:(){
                                AndroidIntent intent = AndroidIntent(
                                  action: 'android.intent.action.VIEW',
                                  data: "https://www.facebook.com/nkdevelopers12",
                                );
                                intent.launch();
                      },
                              child: CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685627164/icons8-facebook-logo-96_ejsogj.png"),
                              ),
                            ),
                            Text("Facebook",style: TextStyle(color: Colors.white,fontSize: 16),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Material(
                      color: Colors.transparent,
                      elevation: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.15,
                        width: MediaQuery.of(context).size.width *0.30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15)

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap:(){
                                AndroidIntent intent = AndroidIntent(
                                  action: 'android.intent.action.VIEW',
                                  data: "https://www.youtube.com/channel/UCfZSGlJWrGQoHxsDS3_vTCA",
                                );
                                intent.launch();
                              },
                              child: CircleAvatar(
                                backgroundColor:Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685627266/icons8-youtube-96_r3kmyq.png"),
                              ),
                            ),
                            Text("Youtube",style: TextStyle(color: Colors.white,fontSize: 16),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Material(
                      color: Colors.transparent,
                      elevation: 10,
                      child: Container(
                        height: MediaQuery.of(context).size.height *0.15,
                        width: MediaQuery.of(context).size.width *0.30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(15)

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap:(){
                                AndroidIntent intent = AndroidIntent(
                                  action: 'android.intent.action.VIEW',
                                  data: "https://forms.gle/fHTTzR5VxZg5Tjsv7",
                                );
                                intent.launch();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white70,
                                radius: 28,
                                backgroundImage:NetworkImage("https://res.cloudinary.com/dghloo9lv/image/upload/v1685627407/icons8-emergency-96_wm2nzl.png"),
                              ),
                            ),
                            Text("Contact Us",style: TextStyle(color: Colors.white,fontSize: 16),)
                          ],
                        ),
                      ),
                    ),




                  ],
                ),
              ),
            )
          ],),
        )


          ],
        ),
      ),
    );
  }
  Future<void> Info(){

    return showDialog(context: context, builder:(context) {

      return AlertDialog(
        title: Center(child: Text("How To Use")),
        content: Text("Perform Different Tasks, Play Games and Collect NIKTOS once you reached "
            "the Minimum Threshold which is 1200 NIKTOS than submit Withdrawal Request."
            "Once System Received your Withdrawal Request than After Completing Security Checkup "
            "We will release your payouts instantly. "
            "Keep In Mind. Use Correct Coinbase Email account for Withdrawal Otherwise we are not responsible if you don't receive your money."),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10,bottom: 10),
                child: InkWell(
                    onTap: (){Navigator.pop(context);},
                    child: Text("Close",style: TextStyle(fontSize: 16,color: Colors.red.shade900),)),
              )
            ],
      );

    },);
  }


}
