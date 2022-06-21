import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final String url;

  const VideoViewer({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController? _controller;

  bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
    print('image urlllllllllllll ${widget.url}');
    _controller = VideoPlayerController.network(
        "http://foxyserver.com/funky/video/${widget.url}");

    _controller!.setLooping(true);
    _controller!.initialize().then((_) {
      setState(() {});
    });
    _controller!.play();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    _controller!.dispose();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () {},
            child: _controller!.value.isInitialized
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                              top: 30, left: 20,right: 20,bottom: 10),
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('hello');
                          isClicked = isClicked ? false : true;
                          print(isClicked);
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.2,
                          child: Center(
                            child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!)),
                          ),
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.red,
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       // stops: [0.1, 0.5, 0.7, 0.9],
                      //       colors: [
                      //         HexColor("#000000"),
                      //         HexColor("#000000").withOpacity(0.7),
                      //         HexColor("#000000").withOpacity(0.3),
                      //         Colors.transparent
                      //       ],
                      //     ),
                      //   ),
                      //   alignment: Alignment.topCenter,
                      //   height: MediaQuery.of(context).size.height/5,
                      // ),
                    ],
                  )
                : Container(),
          ),
        ));
  }
}
