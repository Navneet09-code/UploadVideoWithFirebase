import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamingvideoapp/LoginPage.dart';
import 'package:streamingvideoapp/main.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class videoPlayerScreenPage extends StatefulWidget {
  
  const videoPlayerScreenPage({super.key});

  @override
  State<videoPlayerScreenPage> createState() => _videoPlayerScreenPageState();
}

class _videoPlayerScreenPageState extends State<videoPlayerScreenPage> {
  TextEditingController videoTitle = TextEditingController();
  TextEditingController videoDisc = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Uuid uid = Uuid();
  final ImagePicker imgPicker = ImagePicker();
  double _uploadProgress = 0;

  _uploadVideosData() async {
    final XFile? videos =
        await imgPicker.pickVideo(source: ImageSource.gallery);
    if (videos != null) {
      print(videos.path);
      _uploadVideoInFirebase(File(videos.path));
    } else {
      print("Video Not Selected");
    }
  }

  void _uploadVideoInFirebase(File file) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var uuid = Uuid();
      var fileName = uuid.v1();
      var storageref =
          FirebaseStorage.instance.ref().child("videos/${fileName}");
      var uploadTask = storageref.putFile(file);
     /* uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        _uploadProgress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print(" uploading Data : ${_uploadProgress}");
        setState(() {});
      });*/
      try {
        await uploadTask.whenComplete(() => null);
        print("Video Uploaded Successfully");
        storageref.getDownloadURL().then((url) {
          FirebaseFirestore.instance.collection("videos").doc().set({
            "url": url,
            "title": videoTitle.text.toString(),
            "videoDesc": videoDisc.text.toString(),
            "timesTamp": FieldValue.serverTimestamp()
          });

          _uploadProgress = 0;
          setState(() {
            videoTitle.text = '';
          });
          print("Video Url : ${url}");
        });
      } catch (e) {
        _uploadProgress = 0;

        print("Error uploading video: $e");
        showToast("Error uploading video: $e");
      }
    } else {
      showToast("You Are Offline");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showToast("You Are Online");
      print("Online");
    } else {
      showToast("You Are Offline");
      print("offline");
    }
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: videoTitle,
                decoration: InputDecoration(
                  labelText: 'Video Title',
                ),
              ),
              TextField(
                controller: videoDisc,
                decoration: InputDecoration(
                  labelText: 'Second Field',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Perform actions based on the input data
                _uploadVideosData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnection();
  }
  void _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    void _showLogoutDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Perform logout operation
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out')),
                  );
                  var setPreferance = await SharedPreferences.getInstance();
                  setPreferance.setBool(MyHomePageState.STOREKEY, false);
                  _signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()),
                        (Route<dynamic> route) => false,);
                  setState(() {

                  });
                },
                child: const Text('Logout'),
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player Screen"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            offset: Offset(1, 5),
            surfaceTintColor: Colors.green,
            shadowColor: Colors.black38,
            onSelected: (String result) async{
              // You can perform actions based on the selected item
              // For now, we'll just print the selected item
              if(result=="Item 1"){
                print("Upload Video");
                _showDialog();
                setState(() {

                });
              }else {
                _showLogoutDialog(context);
                /*var setPreferance = await SharedPreferences.getInstance();
                setPreferance.setBool(MyHomePageState.STOREKEY, false);*/
              }
             // print(" index ${result}");
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Item 1',
                child: Text('Upload Videos'),
              ),
              const PopupMenuItem<String>(
                value: 'Item 2',
                child: Text('LogOut'),
              ),

            ],
          ),


        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              if (_uploadProgress > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: _uploadProgress / 100),
                      SizedBox(height: 8),
                      Text(
                        "Uploading: ${_uploadProgress.toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('videos').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String videoUrl = snapshot.data!.docs[index]['url'];
                            DocumentSnapshot document = snapshot.data!.docs[index];
                            String docId= document.id;
                            return Container(
                              margin: EdgeInsets.only(top: 50),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black26)
                                  ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text('${snapshot.data!.docs[index]['url']}'),
                                  Container(
                                      color: Colors.black26,
                                      child:
                                          VideoItem1(url: videoUrl.toString(),docId: docId,)),

                                  Container(
                                    margin: EdgeInsets.only(left: 30, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]['title'] != ""
                                              ? snapshot.data!.docs[index]
                                                  ['title']
                                              : "No Title",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                                      ['videoDesc'] !=
                                                  ""
                                              ? snapshot.data!.docs[index]
                                                  ['videoDesc']
                                              : "No Subtitle",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15),
                                        ),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.hasError.toString()),
                      );
                    } else {
                      return Center(
                        child: Text("No Data Found"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItem1 extends StatefulWidget {
  final String url;
  final String docId;

  VideoItem1({required this.url,required this.docId});

  @override
  _VideoItemState1 createState() => _VideoItemState1();
}

class _VideoItemState1 extends State<VideoItem1> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _controller.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }
  void _deleteVideo(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('videos').doc(docId).delete();
      showToast("Video Deleted Successfully");
    } catch (e) {
      showToast("Error deleting video: $e");
    }
  }
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        // alignment: Alignment.center,
        children: [
          _isLoading
              ? Positioned(
                  left:
                      0.4 * MediaQuery.of(context).size.width, // 10% from left
                  top: 0.1 * MediaQuery.of(context).size.height,
                  child: Center(child: Text("Please Wait...")))
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                      height: 200, // Fixed height for the video player
                      width: double.infinity,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                              color: Colors.black.withOpacity(0.5),
                              width: _controller.value.size?.width ?? 0,
                              height: _controller.value.size?.height ?? 0,
                              child: VideoPlayer(_controller)))),
                ),
          _isLoading
              ? Positioned.fill(
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.2), // Adjust opacity and color as needed
                  ),
                )
              : Container(),
          Positioned(
            height: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _togglePlayPause,
                ),
              ],
            ),
          ),
          Positioned(
            height: 350,
            width: MediaQuery.of(context).size.width*1.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.delete,color: Colors.black45,size: 18,),
                  onPressed: () {
                    _deleteVideo(widget.docId);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.4, // 10% from left
            top: MediaQuery.of(context).size.height * 0.12, // 10% from top
            child: Center(
                child: _isLoading
                    ? Container(
                        width: 100,
                        child: VideoProgressIndicator(_controller,
                            allowScrubbing: true))
                    : Container()),
          ),
        ],
      ),
    );
  }
}
