import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:niktobonanza/Rooms/Models/cuntry.dart';
import 'package:niktobonanza/utils/Toast.dart';
import 'package:niktobonanza/utils/cashout.dart';

class PMNT extends StatefulWidget {
  const PMNT({super.key});

  @override
  State<PMNT> createState() => _PMNTState();
}

class _PMNTState extends State<PMNT> {
  var money;
  var method;
  var cashLevel = "\$ 0.01";
  var paymentLevel = "Coinbase";
  TextEditingController emailEditingController = TextEditingController();

  // SV_Data

  var satoshi = 0;
  var wth;
  var locationx;
  var wthCode;
  var isNotSubmitted = true;
  final _auth = FirebaseAuth.instance;
  final _refDb = FirebaseDatabase.instance.ref("Workers");
  final _refAdmin = FirebaseDatabase.instance.ref("Admin");
  var formatter;
  final _key = GlobalKey<FormState>();

  dataget() async {
    _refDb
        .child(_auth.currentUser!.uid)
        .child("Niktos")
        .onValue
        .listen((event) {
      satoshi = int.parse(event.snapshot.value.toString());
      setState(() {});
    });

    _refDb
        .child(_auth.currentUser!.uid)
        .child("WithdrawCode")
        .onValue
        .listen((event) {
      wthCode = event.snapshot.value;

      if (wthCode == 1) {
        isNotSubmitted = false;
        setState(() {});
      } else if (wthCode == 0) {
        isNotSubmitted = true;

        setState(() {});
      }
    });

    // TD
    final now = new DateTime.now();
    formatter = DateFormat('yMd').format(now); // Format => 28/03/2020
  }

  //SRSide
  Sside() {
    _refAdmin.child("WithdrawRequest").child(_auth.currentUser!.uid).set({
      'Coins': satoshi,
      'Email': emailEditingController.text.toString(),
      'Date': formatter,
      'Country': locationx["country"],
      'PaymentMethod': method,
      'Money': money,
    });

    _refDb.child(_auth.currentUser!.uid).update({
      'Niktos': 0,
      'WithdrawCode': 1,
    });
  }

  //LSide

  Future<String> getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    locationx = jsonDecode(locationSTR);
    print(locationx);

    return locationx["country"];
  }

  @override
  void initState() {
    dataget();
    getCountry();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        centerTitle: true,
        title: Text("Cashout"),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Balance",
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "𝝱 $satoshi",
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
              ],
            ),

            const SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Visibility(
                visible: isNotSubmitted,
                child: Visibility(
                  visible: isNotSubmitted,
                  child: const Text(
                    "Choose Amount that you want to cashout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: isNotSubmitted,
                  child: Column(
                    children: [
                      btns(
                          onpress: () {
                            setState(() {
                              cashLevel = "\$ 0.01";
                              if (satoshi >= 800 && satoshi < 1000) {
                                money = "0.01";
                              } else {
                                Utils().message("Minimum 800 Coins Required");
                              }
                            });
                          },
                          title: "\$ 0.01",
                          value: "\$ 0.01",
                          groupvalue: cashLevel,
                          color: Colors.grey.shade300),
                      const SizedBox(
                        height: 15,
                      ),
                      btns(
                          onpress: () {
                            setState(() {
                              cashLevel = "\$ 0.05";
                              if (satoshi >= 2000 && satoshi < 2500) {
                                money = "0.05";
                              } else {
                                Utils().message("Minimum 1800 Coins Required");
                              }
                            });
                          },
                          title: "\$ 0.05",
                          value: "\$ 0.05",
                          groupvalue: cashLevel,
                          color: Colors.grey.shade300),
                    ],
                  ),
                ),
                //Colum 2
                Visibility(
                  visible: isNotSubmitted,
                  child: Column(
                    children: [
                      btns(
                          onpress: () {
                            setState(() {
                              cashLevel = "\$ 0.5";
                              if (satoshi >= 5000 && satoshi < 7000) {
                                money = "0.5";
                              } else {
                                Utils().message("Minimum 8000 Coins Required");
                              }
                            });
                          },
                          title: "\$ 0.5",
                          value: "\$ 0.5",
                          groupvalue: cashLevel,
                          color: Colors.grey.shade300),
                      const SizedBox(
                        height: 15,
                      ),
                      btns(
                          onpress: () {
                            setState(() {
                              cashLevel = "\$ 1.00";
                              if (satoshi >= 8000) {
                                money = "1.00";
                              } else {
                                Utils()
                                    .message("Minimum 10,000 Coins Required");
                              }
                            });
                          },
                          title: "\$ 1.00",
                          value: "\$ 1.00",
                          groupvalue: cashLevel,
                          color: Colors.grey.shade300),
                    ],
                  ),
                ),
              ],
            ),

            //Payment methods
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Visibility(
                visible: isNotSubmitted,
                child: const Text(
                  "Choose Payment Method that you want to Use",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: isNotSubmitted,
                  child: Column(
                    children: [
                      btns(
                          onpress: () {
                            setState(() {
                              method = "Coinbase";
                              paymentLevel = "Coinbase";
                            });
                          },
                          value: "Coinbase",
                          groupvalue: paymentLevel,
                          title: "Coinbase",
                          color: Colors.grey.shade300),
                      const SizedBox(
                        height: 10,
                      ),
                      btns(
                          onpress: () {
                            setState(() {
                              method = "Binance";
                              paymentLevel = "Binance";
                            });
                          },
                          title: "Binance",
                          value: "Binance",
                          groupvalue: paymentLevel,
                          color: Colors.grey.shade300),
                    ],
                  ),
                ),
                //Colum 2
                Visibility(
                  visible: isNotSubmitted,
                  child: Column(
                    children: [
                      btns(
                          onpress: () {
                            setState(() {
                              method = "PayPal";
                              paymentLevel = "PayPal";
                            });
                          },
                          title: "PayPal",
                          value: "PayPal",
                          groupvalue: paymentLevel,
                          color: Colors.grey.shade300),
                      const SizedBox(
                        height: 10,
                      ),
                      btns(
                          onpress: () {
                            setState(() {
                              method = "Faucet";
                              paymentLevel = "Faucet";
                            });
                          },
                          title: "Faucet",
                          value: "Faucet",
                          groupvalue: paymentLevel,
                          color: Colors.grey.shade300),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Visibility(
                visible: isNotSubmitted,
                child: const Text(
                  "Enter Wallet Email very Carefully",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Form(
              key: _key,
              child: Visibility(
                visible: isNotSubmitted,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Incorrect Email!";
                    }
                    if (!value!.endsWith(".com")) {
                      return "Incorrect Email!";
                    }
                  },
                  controller: emailEditingController,
                  decoration: InputDecoration(
                      hintText: "Enter Wallet Email",
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Visibility(
              visible: isNotSubmitted,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      if (satoshi >= 800) {
                        setState(() {
                          isNotSubmitted = false;
                        });
                        Sside();
                      } else if (satoshi < 800) {
                        Utils().message("Collect Minimum 800 Satoshi");
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Submit Request",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Visibility(
                visible: isNotSubmitted == true ? false : true,
                child: Text(
                  "Your Withdraw Request has been received. After completing the Security clearance. We will release your payouts this process usually takes less than 4 hours. So Please Stay With us and Keep Earning :)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
