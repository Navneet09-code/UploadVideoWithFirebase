import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamingvideoapp/VideoPlayerScreenPage.dart';
import 'package:streamingvideoapp/firebase_options.dart';
import 'package:streamingvideoapp/newApi.dart';

import 'LoginPage.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  String? token = await FirebaseMessaging.instance.getToken();
  print("Token :- $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
 @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
static const String STOREKEY ="isLogin";
void navigateScreen()async{
  var sharedPreference =  await SharedPreferences.getInstance();
  var _isLogin = sharedPreference.getBool(STOREKEY);
  Timer(Duration(seconds: 3), () {
    if(_isLogin!=null){
      if(_isLogin){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>videoPlayerScreenPage()),
              (Route<dynamic> route) => false,);
        setState(() {

        });
      }else {
        Route route = MaterialPageRoute(
            builder: (context) =>LoginPage());
        Navigator.pushReplacement(context, route);
        setState(() {

        });
      }
    }else{
      Route route = MaterialPageRoute(
          builder: (context) =>LoginPage());
      Navigator.pushReplacement(context, route);
      setState(() {

      });
    }
  });
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [
      SystemUiOverlay.top
    ]);
    navigateScreen();
    messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('On Message Open data: ${message}');
      // Handle the message and navigate to appropriate screen
    });

    requestPermission();
}

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(image: DecorationImage(image:  AssetImage('assets/firebasevideoupload.jpeg'),fit: BoxFit.cover,),
          )),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
