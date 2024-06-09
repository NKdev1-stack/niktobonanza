import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:niktobonanza/Rooms/MainMenueRoom.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WallRoom extends StatefulWidget {
  const WallRoom({super.key});

  @override
  State<WallRoom> createState() => _WallRoomState();
}

class _WallRoomState extends State<WallRoom> {
  final controller0 = WebViewController()
    ..loadRequest(Uri.parse("https://fastsvr.com/list/518315"))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('market')) {
          AndroidIntent intent = AndroidIntent(
                    action: 'android.intent.action.VIEW',
                    data: request.url,
                  );
                  intent.launch();
        }
        return NavigationDecision.navigate;
      },
    ),
  );
   
    

    final controller1 = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..runJavaScript(AutofillHints.email)
    ..loadRequest(Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLSemPf77AUnO6L2DRh_9YGXg3fxWmBB0N1-7WJiyY8mi4QSkkQ/viewform"));

    int tt = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: UnityBannerAd(
  placementId: 'Banner_Android',
  onLoad: (placementId) => print('Banner loaded: $placementId'),
  onClick: (placementId) => print('Banner clicked: $placementId'),
  onShown: (placementId) => print('Banner shown: $placementId'),
  onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: tt==0?Text("OfferWall",style: TextStyle(color: Colors.white),):Text("Submission Form",style: TextStyle(color: Colors.white)),
            actions: [
              InkWell(
                onTap: (){
                        tt==0?controller0.goBack():controller1.goBack();

                },
                child: Icon(Icons.arrow_back,color: Colors.amber,)),
              SizedBox(width: 14,),
             tt==0? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                    onTap: () {
                      HelpInfo();
                    },
                    child: Icon(Icons.info,color: Colors.white,)),
              ): Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        tt=0;
                      });
                    },
                    child: Icon(Icons.cancel,color: Colors.white,)),
              )
            ],
            leading: InkWell(
                onTap: () {

                 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenueRoom(),));
                },
                child: Icon(Icons.arrow_back,color: Colors.white,)),
          ),
          body: tt==0?WebViewWidget(controller: controller0):WebViewWidget(controller: controller1)),
    );
  }

  Future<void> HelpInfo() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(child: Text("Must Read!")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              SizedBox(
                height: 20,
              ),
              Text(
                "Complete The Offer and Must Take ScreenShot of your Completed Offers "
                "Click on Submit Now Button Signin in with Google *Your Signin is Safe and Secure by Google* and Submit Complete Details to us Like "
                "Your Completed Offers and Registered Email ID "
                "We Will Automatically Fund Coins in your Account "
                "Our System will Verify your Offers and than within minutes you will receive Your Coins "
                "We pay 0.5\$ to 50\$ for Offers.",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(onPressed: (){
                      Navigator.pop(context);
                      
                      setState(() {
                      tt = 1;  
                      });
              },
               icon: Icon(Icons.send), label: Text("Submit Now",style: TextStyle(fontSize: 18),))
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
