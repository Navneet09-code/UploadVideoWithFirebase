import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExerciseDemo extends StatefulWidget {
  const ExerciseDemo({super.key});

  @override
  State<ExerciseDemo> createState() => _ExerciseDemoState();
}

class _ExerciseDemoState extends State<ExerciseDemo> {
  TextEditingController _phoneNo = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
   String verificationID ='';

  void _sendCode() async {
    _auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential)async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed ${e}");
        },
        codeSent: (VerifiactionId, token) {
          verificationID =VerifiactionId;
        },
        codeAutoRetrievalTimeout: (verificationID) {});
  }

  void _getOTP()async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: _phoneNo.text);
    try{
      _auth.signInWithCredential(credential);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
