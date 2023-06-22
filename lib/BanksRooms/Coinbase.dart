import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:niktobonanza/utils/Toast.dart';


class CoinbaseB extends StatefulWidget {
  const CoinbaseB({Key? key}) : super(key: key);

  @override
  State<CoinbaseB> createState() => _CoinbaseBState();
}

var UNiktos = 0;
var cash = 0;
bool isNotSubmitted = true;
var wthCode ;
var iA;
var  RA;
TextEditingController _emailController = TextEditingController();
Random rnd = Random();
var RNDS = rnd.nextInt(100000000)*10;

// DB
final _auth = FirebaseAuth.instance;
final _refDb = FirebaseDatabase.instance.ref("Workers");
final _refAdmin = FirebaseDatabase.instance.ref("Admin");
var formatter;
final _key = GlobalKey<FormState>();




class _CoinbaseBState extends State<CoinbaseB> {
  @override
  void initState() {

    dataget();
    super.initState();
  }

// Getting DB Data

  dataget() async {

    // Coins get/
    _refDb.child(_auth.currentUser!.uid)
        .child("Niktos")
        .onValue.listen((event) {
      UNiktos = int.parse(event.snapshot.value.toString());
     setState(() {

     });

    });

    // RA Get
    _refDb.child(_auth.currentUser!.uid)
        .child("R_ID")
        .onValue.listen((event) {
      RA = int.parse(event.snapshot.value.toString());



    });
    // IA Get
    _refDb.child(_auth.currentUser!.uid)
        .child("I_ID")
        .onValue.listen((event) {
      iA = int.parse(event.snapshot.value.toString());



    });


    // WTCODE Get
    _refDb.child(_auth.currentUser!.uid)
        .child("WithdrawCode")
        .onValue.listen((event) {
      wthCode = event.snapshot.value;

      
          if(wthCode == 1){
            isNotSubmitted = false;
            setState(() {

            });
          }else if(wthCode ==0){
            isNotSubmitted = true;
            setState(() {

            });
          }


    });

    // TD
    final now = new DateTime.now();
    formatter = DateFormat('yMd').format(now);// Format => 28/03/2020

  }
  // Wth
  submit(){

    _refAdmin.child("PaymentsDetails")
        .child("$RNDS")
        .child("Payment Histroy")
        .child(_auth.currentUser!.uid)
        .set({

      'Last Withdraw' : formatter,
      'CoinbaseEmail' : _emailController.text.toString(),
      'UNiktos' : UNiktos,

    });
    _refAdmin
        .child("WithdrawRequest")
        .child(_auth.currentUser!.uid)
        .set({

        'Coins' : UNiktos,
        'CoinbaseEmail' : _emailController.text.toString(),
        'Date' : formatter,
        'iA' : iA,
        'RA' : RA,


    });

    _refDb.child(_auth.currentUser!.uid)

                .update({

      'Niktos' : 0,
      "I_ID" : 0,
      "R_ID" :0,
      'WithdrawCode' : 1,


    });


  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: Row(children: [Icon(Icons.account_balance_wallet),SizedBox(width: MediaQuery.of(context).size.width *.02,),const Text("Wallet")],),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * .06,),

            Center(
              child: Container(

                height: MediaQuery.of(context).size.height *0.15,
                width: MediaQuery.of(context).size.width *0.9,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black38),

                child:

                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/coin.png",height: 30,width: 30,),
                        const   SizedBox(height: 5,),
                        const  Text("Niktos",style: TextStyle(color: Colors.white),),

                        Text("$UNiktos",style: TextStyle(color: Colors.yellowAccent)),

                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/coinbs.png",height: 35,width: 35,),
                        const   Text("Method",style: TextStyle(color: Colors.white)),
                        Text("Coinbase",style: TextStyle(color: Colors.yellow)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/rank.png",height: 30,width: 30,),
                        const   SizedBox(height: 2,),


                        Text("Level",style: TextStyle(color: Colors.white)),

                        Text(" 1",style: TextStyle(color: Colors.yellowAccent)),
                      ],
                    ),



                  ],

                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Column(
                children: [

                    Stack(
                      children: [

                        Material(
                          color: Colors.transparent,
                          elevation: 20,
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.30,
                            width: MediaQuery.of(context).size.width *1.2,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)

                            ),
                            child: SingleChildScrollView(
                              child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 70,left: 8),
                                    child: Text("Get Your Withdraw",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,top: 6),
                                    child:
                                   isNotSubmitted ? Text("Enter Coinbase Email to Get Witdraw!",style: TextStyle(color: Colors.black,fontSize: 16,),)
                                    :Text("Your Latest Withdraw Request is Pending!",style: TextStyle(color: Colors.black,fontSize: 16,))),



                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                                    child: Form(
                                      key: _key,
                                      child: Visibility(
                                        visible: isNotSubmitted,
                                        child: TextFormField(
                                          controller: _emailController,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return "Incorrect Email";
                                            }
                                          },

                                          decoration: InputDecoration(
                                            hintText: "Coinbase Account Email",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.black,width: 20)
                                            ),
                                            prefixIcon: Icon(Icons.mark_email_read_rounded,color: Colors.black,),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height *0.075,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent.shade700.withRed(12),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),)
                          ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text( "Coinbase",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                            )),
                          ],
                        ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: InkWell(
                        onTap:(){
                          AndroidIntent intent = AndroidIntent(
                            action: 'android.intent.action.VIEW',
                            data: "https://sites.google.com/view/niktocoins/home",
                          );
                          intent.launch();
                        },
                        child: Text("Conversion Rates Click Here",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height *0.003),
                  InkWell(
                    onTap: (){

                      if(_key.currentState!.validate() && UNiktos >= 1200 && wthCode == 0){
                        setState(() {
                          submit();
                          dataget();
                        });
                      }else{
                        Utils().message('Not Enough Niktos for Cash!');

                      }


                    },

                    child: Material(
                      color: Colors.transparent,
                      elevation: 10,
                      child: Visibility(
                        visible: isNotSubmitted,
                        child: Container(
                          height:  MediaQuery.of(context).size.height * .06,
                          width:  MediaQuery.of(context).size.width * .54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                          ),

                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Icon(Icons.monetization_on_rounded),
                              Text("Money Request",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
