import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamingvideoapp/VideoPlayerScreenPage.dart';
import 'package:streamingvideoapp/demo.dart';
import 'package:streamingvideoapp/main.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  OTPVerificationPage({super.key, required this.verificationId});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController _verifyOTP = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: _verifyOTP.text.trim());
    try {
      _auth.signInWithCredential(credential);
      var srdPrf = await SharedPreferences.getInstance();
      srdPrf.setBool(MyHomePageState.STOREKEY, true);
      SetMessage("You Signin Successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => videoPlayerScreenPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      SetMessage(e.toString());
    }
  }

  Future SetMessage(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Varification"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 0, top: 20),
              height: 60,
              child: TextFormField(
                controller: _verifyOTP,
                /* maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],*/
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Color(0xffb4fbff),
                    contentPadding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 5),
                    hintText: 'Confrim OTP',
                    isCollapsed: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red.withOpacity(0.6), width: 2)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red.withOpacity(0.6), width: 0),
                    ),
                    hintStyle: TextStyle(
                        color: Colors.black38,
                        fontFamily: 'PPR',
                        fontSize: 15)),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  verifyOTP();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 0, top: 30),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.brown),
                      color: Color(0xff5c2511),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(
                      child: Text(
                    "Verify OTP",
                    style: TextStyle(
                        fontFamily: 'PPB', fontSize: 15, color: Colors.white),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
