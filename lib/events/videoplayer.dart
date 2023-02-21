import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class VideoPlayerPage extends StatefulWidget {
  final String videourl;


  const VideoPlayerPage({Key? key,

  required this.videourl,

  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
 late VideoPlayerController  _controller;

   @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.videourl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.close,color: Colors.white,), onPressed: (){
            Navigator.pop(context);
          },),
          backgroundColor: Colors.transparent),
        backgroundColor: Colors.black,
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          backgroundColor: kPrimary,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
