import "package:connectivity_plus/connectivity_plus.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";


class DemoLogInPage extends StatefulWidget {
  const DemoLogInPage({super.key});

  @override
  State<DemoLogInPage> createState() => _DemoLogInPageState();
}

class _DemoLogInPageState extends State<DemoLogInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();

  void LogInPage()async{
    var checkConnectivity = await (Connectivity().checkConnectivity());
    if(checkConnectivity==ConnectivityResult.wifi || checkConnectivity==ConnectivityResult.mobile){
      try{
        _auth.signInWithEmailAndPassword
          (
            email: _userName.text,
            password: _password.text);
      }catch(e){
        print(e);
      }
    }else{
      print("You are offline");
    }
  }
  void registerdUser()async{
     var checkResult = await (Connectivity().checkConnectivity());
     if(checkResult == ConnectivityResult.wifi || checkResult ==ConnectivityResult.mobile){
       _auth.createUserWithEmailAndPassword(email: _userName.text, password: _password.text);
     }else{
       print("Your are offline");
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
