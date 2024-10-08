import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class VideoUploadScreen extends StatefulWidget {
  @override
  _VideoUploadScreenState createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _videoFile;
  bool _isUploading = false;
  double _uploadProgress = 0;

  final TextEditingController videoTitleController = TextEditingController();
  final TextEditingController videoDescController = TextEditingController();

  final picker = ImagePicker();

  Future<void> _pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVideoInFirebase(File file) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var uuid = Uuid();
      var fileName = uuid.v1();
      var storageRef = FirebaseStorage.instance.ref().child("videos/$fileName");

      var uploadTask = storageRef.putFile(
        file,
        SettableMetadata(contentType: 'video/mp4'),
      );

      // Track upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
        print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
      });

      setState(() {
        _isUploading = true;
        _uploadProgress = 0;
      });

      try {
        await uploadTask;

        // Get download URL
        String downloadURL = await storageRef.getDownloadURL();

        // Save video details to Firestore
        await FirebaseFirestore.instance.collection("videos").add({
          "url": downloadURL,
          "title": videoTitleController.text,
          "videoDesc": videoDescController.text,
          "timestamp": FieldValue.serverTimestamp(),
        });

        setState(() {
          _isUploading = false;
        });

        print("Video uploaded successfully. Download URL: $downloadURL");

        // Show success message or navigate to next screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully')),
        );
      } catch (e) {
        print("Error uploading video: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video')),
        );
        setState(() {
          _isUploading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are offline')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_videoFile != null) ...[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.file(_videoFile!), // Replace with VideoPlayer if using videos
              ),
              SizedBox(height: 20),
              _isUploading
                  ? Column(
                children: [
                  CircularProgressIndicator(
                    value: _uploadProgress,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${(_uploadProgress * 100).toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _uploadVideoInFirebase(_videoFile!),
                    child: Text('Upload Video'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: videoTitleController,
                    decoration: InputDecoration(labelText: 'Video Title'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: videoDescController,
                    decoration: InputDecoration(labelText: 'Video Description'),
                  ),
                ],
              ),
            ] else
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Pick a Video'),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VideoUploadScreen(),
  ));
}
