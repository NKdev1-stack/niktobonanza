import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/Auth/LoginSignup/Login.dart';

import '../../Rooms/MainMenueRoom.dart';
import '../../utils/Toast.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override

  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  late bool _passwordVisible;
  late String UserIDs;
  // Login User
  final databaseref = FirebaseDatabase.instance.ref("Workers");


  final FirebaseAuth _auth = FirebaseAuth.instance;

  void Login() {

    if(_formKey.currentState!.validate()){

      _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString())
          .then((value) => {

        // Once User Data saved in Authentication than we will save all other data in FireStore

        
        databaseref.child(_auth.currentUser!.uid)
            .set({
          'id':_auth.currentUser!.uid,
          'Niktos': 0,
          'Name': nameController.text.toString(),
          'Password': passwordController.text.toString(),
          'Email': emailController.text.toString(),
          'Level': 1,
          'Scratch':5,
          'Guesses': 5,
          'Captchas': 5,
          'Dice': 5,
          'R_ID': 0,
          'I_ID': 0,
          'WithdrawCode': 0,
          'APP_VERSION':"1.56.1"

        }).then((value) => {
          Utils().message("Welcome "+nameController.text.toString()),
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenueRoom(),)),

        }
        ).onError((error, stackTrace) => {

          Utils().message("Sorry Please Try Again Later!")

        })













          // FireStore

      // fireStore.doc(_auth.currentUser!.uid).set({
      //   'Name':nameController.text.toString(),
      //   'EmailID':emailController.text.toString(),
      //   'Password':passwordController.text.toString(),
      //   'Coins': 0,
      //   'T_int':0,
      //   'T_Rwd':0,
      //   'Scratches':5,
      //   'Guess_Chance':5,
      //   'Lottery':5,
      //   'Levels':1,
      //
      // }).then((value) => {
      //
      //   Utils().message("Account Created!"),
      // }).onError((error, stackTrace) => {
      //   Utils().message(error.toString()),
      //
      // }),
      //
      //



    }).onError((error, stackTrace) => {

      });

    }else{
      print("Incorrect Data");
    }


  }

  void initState() {
  // Using this password Visible Bool in hiding or showing password
   _passwordVisible = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
       body: SingleChildScrollView(
         child: Container(
           margin: EdgeInsets.symmetric(horizontal: 20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Image.asset("assets/images/signup.png",
                    height: MediaQuery.of(context).size.height *0.3,
                    width: MediaQuery.of(context).size.width *1,),
                ),

                SizedBox(height: MediaQuery.of(context).size.height *0.04,),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text("Sign Up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),)),

                SizedBox(height: MediaQuery.of(context).size.height *0.04,),

                Form(
                key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Incorrect Name';
                          }else if(value.length < 4){
                            return 'Name is Too Short';
                          }
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          prefixIcon: Icon(Icons.person_2_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.01,),

                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){

                            return ("Invalid Email ID");
                          }else if(!value.endsWith("@gmail.com")){
                            return("Use Official Gmail Account");

                          }
                        },
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email ID",
                            prefixIcon: Icon(Icons.alternate_email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height *0.01,),

                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return("Invalid Password");
                          }else if(value.length<8){
                            return("Password is Too Short");
                          }
                        },
                          controller: passwordController,
                          // _passwordVisible is true so passowrd text will be hidden
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock_outline_sharp),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              // Using IconButton
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Condition by default _passwordVisible is true
                                  _passwordVisible?Icons.visibility
                                      : Icons.visibility_off,),
                                onPressed: (){
                                  // using ! NOT Operator this will change reverse the values (True to false, false to true)
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;

                                  });
                                },
                              )
                          )
                      ),

                      SizedBox(height: 15,),

                      SizedBox(
                        height: MediaQuery.of(context).size.height *0.05,
                        width: MediaQuery.of(context).size.width *0.7,
                        child: ElevatedButton(
                          onPressed: (){


                             Login();



                          }, child: Text("Sign Up",style: TextStyle(fontSize: 16),),style: ElevatedButton.styleFrom(
                            shadowColor: Colors.blue.shade700,
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),),
                      ),
                      SizedBox(height: 10,),
                      Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginArea(),));
                            },
                            child: RichText(
                              text: const TextSpan(
                                  text: "Already Have an Account! ",style: TextStyle(color: Colors.black),

                                  children: [

                                    TextSpan(text: "Login Here!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
                                  ]
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                )


              ],
            ),
         ),
       )
      ),
    );
  }
}
