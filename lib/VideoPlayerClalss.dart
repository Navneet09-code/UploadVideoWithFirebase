import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoPlayerPage extends StatefulWidget {
  String url="";
  videoPlayerPage({required url,super.key});

  @override
  State<videoPlayerPage> createState() => _videoPlayerPageState();
}

class _videoPlayerPageState extends State<videoPlayerPage> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController=VideoPlayerController.networkUrl(Uri.parse(widget.url));
    videoPlayerController.initialize().then((value) =>{
      setState(() {
        videoPlayerController.play();
        videoPlayerController.setLooping(true);
      })
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player'),centerTitle: true,),
      body: Container(
        child: Stack(
          children: [
            IconButton(onPressed: (){
              if(videoPlayerController.value.isPlaying){
                videoPlayerController.pause();
              }else{
                videoPlayerController.play();
              }
            }, icon: Icon(Icons.play_arrow_sharp)),
            Center(
              child: Container(
                height: 500,
                width: 500,
                child: VideoPlayer(videoPlayerController),
              ),
            )
          ],
        ),
      ),
    );
  }
}
