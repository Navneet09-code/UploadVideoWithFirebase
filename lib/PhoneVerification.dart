import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streamingvideoapp/OTPVerificationPage.dart';

import 'VideoPlayerScreenPage.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  TextEditingController _phoneVerification = TextEditingController();
   final String countryCode ="+91";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sentOTP() async {
    _auth.verifyPhoneNumber(
      phoneNumber: countryCode + _phoneVerification.text,

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) async {
          if(e.code =="invalid-phone-number "){
            SetMessage("provided phone number in not valid");
          }
        },

        codeSent: (verificationId, token) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OTPVerificationPage(verificationId: verificationId)));
        },

        codeAutoRetrievalTimeout: (verificationId) {});
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
        title: Text("Phone Verification"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 0, top: 20),
              height: 60,
              child: TextFormField(
                controller: _phoneVerification,
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
                    hintText: 'Verify Phone No',
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
                  sentOTP();
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
                    "Login",
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
