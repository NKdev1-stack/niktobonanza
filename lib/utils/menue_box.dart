import 'package:flutter/material.dart';

class MenueUtil extends StatelessWidget {
 final String img;
  final String title,message;
 final VoidCallback onpressed;

  const MenueUtil({
    Key? key,
    required this.img,
    required this.title,
    required this.message,
    required this.onpressed,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Expanded(

      child: GestureDetector(
        onTap: onpressed,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *.29,
              width: MediaQuery.of(context).size.height *.22,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(img, height: MediaQuery.of(context).size.height *0.1,width: 70,),
                           Padding(
                            padding: const EdgeInsets.only(left: 15,top: 4),
                            child: Text(title,style:const TextStyle(color: Colors.black54,fontSize: 25,
                                fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height *0.04),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.height *0.4,),
                              Container(
                                height: MediaQuery.of(context).size.height *0.055,
                                width: MediaQuery.of(context).size.width *0.38,
                                decoration: BoxDecoration(
                                borderRadius:const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                                  gradient:LinearGradient(
                                      colors: [Colors.blueAccent.shade400,Colors.blue.shade300]
                                  )
                                ),

                              child:  Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child:  Row(
                                  children: [

                                    const  Icon(Icons.currency_bitcoin,color: Colors.white,size: 28,),
                                    Text(message,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                                    const  SizedBox(width: 10,),
                                      Icon(Icons.arrow_forward, color: Colors.white,)
                                  ],
                                ),
                              ),
                              ),
                            ],
                          )
                        ],
                      )),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
