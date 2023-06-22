import 'package:flutter/material.dart';

class EarnRoomPageView extends StatelessWidget {


  final String GameName,GameDesc,GameCoin;
  final VoidCallback onpress;

  const EarnRoomPageView({
    Key? key,
    required this.GameName,
    required this.GameDesc,
    required this.GameCoin,
    required this.onpress,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:20),
      height: MediaQuery.of(context).size.height *0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.currency_bitcoin),
             Text("$GameName\n",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
            Text( GameDesc,style: TextStyle(color: Colors.grey.shade600,fontSize: 16),),
            SizedBox(height: MediaQuery.of(context).size.height *0.008,),
             Text(GameCoin,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
            GestureDetector(
              onTap: onpress,
              child: Container(
                margin: const EdgeInsets.only(left: 30,right: 30,top: 50),
                height: MediaQuery.of(context).size.height *0.068,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(child: Text("Play Now",style: TextStyle(fontSize: 25),)),
              ),
            )





          ],

        ),
      ),

    );
  }
}
