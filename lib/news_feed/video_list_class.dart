import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Videonews extends StatefulWidget {
  final String url;

  const Videonews({Key? key, required this.url}) : super(key: key);

  @override
  State<Videonews> createState() => _VideonewsState();
}

class _VideonewsState extends State<Videonews> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network("http://foxyserver.com/funky/video/${widget.url}")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller!.play();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller!.value.isInitialized
          ? Stack(children: [
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              Center(
                  child: GestureDetector(
                      onTap: _playPause, child: Icon(Icons.play_circle)))
            ])
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  _playPause() {
    print('video Tapped');
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }
}
