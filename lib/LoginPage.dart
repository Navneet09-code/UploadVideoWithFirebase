import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamingvideoapp/PhoneVerification.dart';
import 'package:streamingvideoapp/VideoPlayerScreenPage.dart';
import 'package:streamingvideoapp/main.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtUserName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtNewUsername = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  bool _passwordVisible=true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool value = false;

  Future asnMethod() async {

  }

  void LoginAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {

      try {
        await _auth.signInWithEmailAndPassword(
          email: txtUserName.text,
          password: txtPassword.text,
        );
        // Navigate to the home page or another page after successful login
        //ShowLoadingDialog();
        var setSrdRef = await SharedPreferences.getInstance();

      //  var key =setSrdRef.getBool(MyHomePageState.STOREKEY);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>videoPlayerScreenPage()),
              (Route<dynamic> route) => false,);


        setSrdRef.setBool(MyHomePageState.STOREKEY, true);
     //  Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneVerificationPage()));


        setState(() {

        });
      } catch (e) {
        // Handle errors here
        print(e);
      }

    } else {
      SetMessage(
          'Internet not available, please check your internet connectivity and try again.');
      return;
    }
  }
  Future<void> _registerWithEmailAndPassword() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: txtNewUsername.text,
        password: txtNewPassword.text,
      );
      var setSrdRef = await SharedPreferences.getInstance();
      setSrdRef.setBool(MyHomePageState.STOREKEY, true);
      /*var key =setSrdRef.getBool(MyHomePageState.STOREKEY);
      if(key == "false"){

      }*/
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneVerificationPage()));

    } catch (e) {
      // Handle errors here
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

  Future ShowLoadingDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                margin:
                EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                height: 80,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xff5c2511),
                    ),
                    SizedBox(
                      width: 20,
                    ), //show this if state is loading
                    Text("Please wait...",
                        style: TextStyle(
                            color: Color(0xff5c2511),
                            fontFamily: 'CM',
                            fontSize: 15)),
                  ],
                ),
              ),
            ),
          );
        });
  }
  void hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  Future<void> _showForgotPassDialog() async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          /*Future.delayed(
            Duration(seconds: 5),
                () {
              Navigator.of(context).pop(true);
            },
          );*/
          return AlertDialog(
            backgroundColor:Colors.white,
            content: Container(
              height: 160,

              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 0, bottom: 0, top: 10, right: 0),
                      child: RichText(

                        text: TextSpan(
                            text: 'Please contact.. Admin to  reset ',
                            style: TextStyle(
                                fontSize:14 ,
                                color: Colors.black,
                                fontFamily: 'PPM'),
                            children: []),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: RichText(

                        text: TextSpan(
                            text:
                            'Password..',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'PPM'),
                            children: []),
                      ),
                    ),
                   /* Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            text:
                            'More Than 5000.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'PPM'),
                            children: []),
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () {

                        Navigator.pop(context);},
                      child: Container(
                        margin: EdgeInsets.only(left: 0, top: 30),
                        height: 50,
                        width:180 ,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Color(0xff5c2511),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: 'PPB', fontSize: 16, color: Colors.white),
                            )),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
          );
        });
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: txtNewUsername,
                decoration: InputDecoration(
                  labelText: 'Enter new email',
                ),
              ),
              TextField(
                controller: txtNewPassword,
                decoration: InputDecoration(
                  labelText: 'Enter new password',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Perform actions based on the input data
                _registerWithEmailAndPassword();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      var shrdPref = await SharedPreferences.getInstance();
      shrdPref.setBool(MyHomePageState.STOREKEY, true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>videoPlayerScreenPage()));
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
Future<User?> _signinWithGoogleAccount()async{
   try{
     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
     if(googleUser==null){
       return null;
     }
     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
     final AuthCredential credential = await GoogleAuthProvider.credential(
       idToken: googleAuth.idToken,
       accessToken: googleAuth.accessToken
     );
     final UserCredential userCredential = await _auth.signInWithCredential(credential);
     final User? user = userCredential.user;
     return user;
   }catch(e){
     print(e.toString());
     return null;
   }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('SMJ PLYWOOD'),
        centerTitle: true,
      ),*/
      body: SingleChildScrollView(
        child: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 25,178,238),
                  Color.fromARGB(255, 21,236,229)
                ],
              )),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: 25,right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                  margin: EdgeInsets.only(left: 0,top: 30),
                  child: Text("Login",style: TextStyle(fontFamily: 'PPB',fontSize: 30,color: Colors.black),)),
                Container(

                    margin: EdgeInsets.only(left: 0,top: 10),
                    height: 130,width: 240,
                    child: Icon(Icons.ac_unit,size: 100,color: Colors.deepPurpleAccent,)),
                Container(
                  margin: EdgeInsets.only(left: 0,top: 20),
                  height: 60,
                  child: TextFormField(
                    controller: txtUserName,
                   /* maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],*/
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      counterText: '',
                        filled: true,
                        fillColor: Color(0xffb4fbff),
                        contentPadding: EdgeInsets.only(top: 10,bottom: 10,left: 5),
                        hintText: 'Enter Email ID',
                        isCollapsed: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red.withOpacity(0.6),width: 2)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color: Colors.red.withOpacity(0.6),width: 0),
                        ),

                        hintStyle: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'PPR',
                            fontSize: 15)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 0,top: 0),
                  height: 60,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: txtPassword,
                        obscureText: _passwordVisible,
                        maxLength: 20,
                        decoration: InputDecoration(
                            filled: true,
                            counterText: '',
                            fillColor: Color(0xffb4fbff),
                            contentPadding: EdgeInsets.only(top: 10,bottom: 10,left: 5),
                            hintText: 'Enter Password',
                            isCollapsed: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black.withOpacity(0.6),width: 2)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(color: Colors.black.withOpacity(0.6),width: 0),
                            ),

                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'PPR',
                                fontSize: 15)),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0,
                                bottom: 0,
                                left: 5,
                                right: 0),
                            height:
                            MediaQuery.of(context).size.height /
                                50,
                            width:
                            MediaQuery.of(context).size.width /
                                18,
                            child: _passwordVisible
                                ? Padding(
                              padding:
                              const EdgeInsets.all(1.0),
                              child: Icon(Icons.lock_open_outlined),
                            )
                                : Padding(
                              padding:
                              const EdgeInsets.all(1.0),
                              child: Icon(Icons.lock_outline),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                      /* Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterMobileNo()));*/
                        /*Route route = MaterialPageRoute(builder: (context) => RegisterMobileNo());
                        Navigator.pushReplacement(context, route);*/

                        _showForgotPassDialog();
                      },
                      child: Container(
                          // margin: EdgeInsets.only(left: 220,top: 0),
                          child: Text("Forgot Password?",style: TextStyle(fontFamily: 'PPB',fontSize: 15,color: Colors.blue),)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    bool emailValid = RegExp(
                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        .hasMatch(txtUserName.text.toString());
                    if (txtUserName.text.trim() == "") {
                      SetMessage("Please enter email id.");
                      return;
                    }else if(emailValid == false){
                      SetMessage("Please enter valid email id.");

                    } else if (txtUserName.text.length<10){
                      SetMessage('Mobile Number must be of 10 digit');
                      return;
                    }
                    if (txtUserName.text.isEmpty){
                      SetMessage('Mobile No. is required');
                      return ;
                    }
                    if (txtPassword.text.isEmpty){
                      SetMessage('Password is Required');
                      return ;
                    }
                    /*if (txtUserName.text.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(
                            txtUserName.text)){
                      SetMessage('Invalid Email ID');
                      return;
                    }*/
                    LoginAPI();

                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 0,top: 30),
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown),
                        color: Color(0xff5c2511),
                        borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    child: Center(child: Text("Login",style: TextStyle(fontFamily: 'PPB',fontSize: 15,color: Colors.white),)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 20,right: 5),
                        // margin: EdgeInsets.only(left: 220,top: 0),
                        child: Text("Don't have an account?",style: TextStyle(fontFamily: 'PPR',fontSize: 15,color: Colors.black),)),
                    GestureDetector(
                      onTap: (){
                        /* Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterMobileNo()));*/
                       /* Route route = MaterialPageRoute(builder: (context) => RegisterMobileNo());
                        Navigator.pushReplacement(context, route);*/
                        _showDialog();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        // margin: EdgeInsets.only(left: 220,top: 0),
                          child: Text("Register.",style: TextStyle(fontFamily: 'PPB',fontSize: 15,color: Colors.blue),)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          User? user = await _signInWithGoogle();
                          if (user != null) {
                            print('Signed in as ${user.displayName}');
                          }
                        },
                        child: Row(

                          children: [
                            Container(
                              height: 15,width: 15,
                                child: Image.asset("assets/icons8-google-96.png")),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                                child: Text('Sign in with Google')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
              ],),
          ),
        ),
      ),
    );
  }
}

