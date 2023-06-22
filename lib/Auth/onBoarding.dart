import 'package:flutter/material.dart';
import 'package:niktobonanza/Auth/LoginSignup/signup.dart';


class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}


class _OnBoardState extends State<OnBoard> {




  late PageController _pageController;
     @override
  void initState() {
    _pageController = PageController(

      initialPage: 0
    );    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              height: MediaQuery.of(context).size.height *.85,
              child: PageView(

                controller: _pageController,
                    children: [
                     // SC 1
                      Container(


                           child: SingleChildScrollView(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 40),
                                 child: Image.asset("assets/images/boardone.png"),
                               ),

                                 const Padding(
                                   padding:  EdgeInsets.only(top: 25),
                                   child:  Text("Smart Work!",style: TextStyle(fontWeight: FontWeight. bold,fontSize: 20),),
                                 ),
                                 const Padding(
                                   padding:  EdgeInsets.all(13),
                                   child: Text("Work smarter and earn more money than hard work, Special Opportunity For You to Earn Money."
                                       "Collect dollars and Once You reached threshold than submit the withdrawal request",style: TextStyle(fontSize: 15),),
                                 ),

                                 Container(
                                      margin: EdgeInsets.only(top: 80),
                                   child:const  Row(

                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.circle,size: 10,),
                                       Icon(Icons.circle,size: 8,color: Colors.grey,),
                                       Icon(Icons.circle,size: 8,color: Colors.grey),
                                     ],
                                   ),
                                 )

                             ],),
                           )
                         ),
                      // SC 2
                      Container(


                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Image.asset("assets/images/boardtwo.png"),
                                ),

                                const Text("How to?",style: TextStyle(fontWeight: FontWeight. bold,fontSize: 20),),
                                const Padding(
                                  padding:  EdgeInsets.all(13),
                                  child: Text("Just Use Scratch Cards, Play Guessing Games, Solve Captcha And Collect dollars these all games are so easy and simple. So With"
                                      "Little Hard work you will Earn Alot of Money",style: TextStyle(fontSize: 15),),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 80),
                                  child:const  Row(

                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.circle,size: 8,color: Colors.grey,),
                                      Icon(Icons.circle,size: 10,),
                                      Icon(Icons.circle,size: 8,color: Colors.grey),
                                    ],
                                  ),
                                )

                              ],),
                          )
                      ),
                      // SC 3
                      Container(


                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Image.asset("assets/images/boardthree.png"),
                                ),

                               const Padding(
                                  padding:  EdgeInsets.only(top: 55),
                                  child:  Text("Ready To Earn!",style: TextStyle(fontWeight: FontWeight. bold,fontSize: 20),),
                                ),
                                const Padding(
                                  padding:  EdgeInsets.all(13),
                                  child: Text("Now Once you submit the Withdrawal request we will pay you instantly. We are also offer daily prizes "
                                      "so Keep earning. Your all Sensitive information are Secured. We allow you to delete your account anytime",style: TextStyle(fontSize: 15),),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 80),
                                  child:const  Row(

                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.circle,size: 8,color: Colors.grey,),
                                      Icon(Icons.circle,size: 8,color: Colors.grey),
                                      Icon(Icons.circle,size: 10,),
                                    ],
                                  ),
                                ),


                                InkWell(
                                  onTap: (){


                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 80),
                                   height: MediaQuery.of(context).size.height *.06,
                                   width: MediaQuery.of(context).size.width *.6,
                                    decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.redAccent,width: 4),

                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => signup(),));

                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.white,width: 4)
                                              ),

                                              child: Image.asset("assets/images/email.png",height: MediaQuery.of(context).size.height *.1,width:MediaQuery.of(context).size.height *.045,)),
                                        const  SizedBox(width: 14,),
                                          const Text('Login With Email',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Text(_googleSignin.currentUser.email.toString()),
                              ],),
                          )
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
