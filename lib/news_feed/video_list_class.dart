import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';

class Videonews extends StatefulWidget {
  final String url;
  final String logo;
  final String title;
  final String description;
  final String likeCount;

  const Videonews(
      {Key? key,
      required this.url,
      required this.logo,
      required this.title,
      required this.description,
      required this.likeCount})
      : super(key: key);

  @override
  State<Videonews> createState() => _VideonewsState();
}

class _VideonewsState extends State<Videonews> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  File? file;

  init() async {
    // final thumbnailFile = await VideoCompress.getFileThumbnail(
    //     videopath,
    //     quality: 50, // default(100)
    //     position: -1 // default(-1)
    // );
    // final thumbnail = await VideoThumbnail.thumbnailFile(
    //           video:
    //               "http://foxyserver.com/funky/video/${widget.url}",
    //           thumbnailPath: (await getTemporaryDirectory()).path,
    //           imageFormat: ImageFormat.WEBP,
    //           maxHeight: 100,
    //           maxWidth: 100,
    //           quality: 75);
    //       setState(() {
    //         file = File(thumbnail!);
    //       });
    print(widget.url);
    _controller = VideoPlayerController.network(
        "${URLConstants.base_data_url}video/${widget.url}")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller!.play();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            child: ListTile(
              visualDensity: VisualDensity(vertical: 0, horizontal: -4),
              dense: true,
              leading: Container(
                width: 50,
                child: CircleAvatar(
                  radius: 48, // Image radius
                  backgroundImage: NetworkImage(
                    "${URLConstants.base_data_url}images/${widget.logo}",
                  ),
                ),
              ),
              //
              // Container(
              //     height: 50,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(50),
              //       color: Colors.white,
              //     ),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(50),
              //       child: IconButton(
              //         onPressed: () {},
              //         icon: Image.asset(
              //           AssetUtils.image1,
              //           fit: BoxFit.fill,
              //         ),
              //       ),
              //     )),
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: 'PR'),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: _controller!.value.isInitialized
                ? Stack(children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    Center(
                        child: GestureDetector(
                            onTap: _playPause,
                            child: Icon(Icons.play_circle,
                                color: Colors.white, size: 50)))
                  ])
                : Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Image.asset(
                        AssetUtils.logo,
                      ),
                      Center(
                          child: GestureDetector(
                              onTap: _playPause,
                              child: Icon(
                                Icons.play_circle,
                                color: Colors.white,
                                size: 50,
                              )))
                    ],
                  ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height:
          //   MediaQuery.of(context).size.height / 2,
          //   child: Stack(
          //     children: [
          //       Container(
          //         child: Image.asset(AssetUtils.user_icon2),
          //       )
          //     ],
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(left: 16, top: 13),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.description,
              style:
                  TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
            ),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                    padding: EdgeInsets.only(left: 5.0),
                    icon: Image.asset(
                      AssetUtils.comment_icon,
                      color: Colors.white,
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {}),
                Text(
                  widget.likeCount,
                  style: TextStyle(
                      color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                ),
                IconButton(
                    padding: EdgeInsets.only(left: 5.0),
                    icon: Image.asset(
                      AssetUtils.like_icon_filled,
                      color: HexColor(CommonColor.pinkFont),
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {}),
                Text(
                  widget.likeCount,
                  style: TextStyle(
                      color: Colors.white, fontSize: 12, fontFamily: 'PR'),
                ),
                IconButton(
                    padding: EdgeInsets.only(left: 5.0),
                    icon: Image.asset(
                      AssetUtils.share_icon2,
                      color: Colors.white,
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
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
