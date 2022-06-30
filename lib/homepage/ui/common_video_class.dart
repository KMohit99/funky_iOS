import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/common_buttons.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final String singerName;
  final String description;
  final String songName;

  final String url;
  final String image_url;

  const VideoWidget({
    Key? key,
    required this.url,
    required this.play,
    required this.singerName,
    required this.songName,
    required this.image_url, required this.description,
  }) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
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

  // an arbitrary value, this can be whatever you need it to be
  double videoContainerRatio = 0.5;

  double getScale() {
    double videoRatio = _controller!.value.aspectRatio;

    if (videoRatio < videoContainerRatio) {
      ///for tall videos, we just return the inverse of the controller aspect ratio
      return videoContainerRatio / videoRatio;
    } else {
      ///for wide videos, divide the video AR by the fixed container AR
      ///so that the video does not over scale

      return videoRatio / videoContainerRatio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: InkWell(
          onTap: () {},
          child: _controller!.value.isInitialized
              ? Stack(
            children: [
              GestureDetector(
                onTap: () {
                  print('hello');
                  isClicked = isClicked ? false : true;
                  print(isClicked);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!)),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HexColor("#000000").withOpacity(0.9),
                      HexColor("#000000").withOpacity(0.3),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(0.3),
                      HexColor("#000000").withOpacity(0.9),
                    ],
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
              Center(
                child: ButtonTheme(
                    height: 50.0,
                    minWidth: 50.0,
                    child: AnimatedOpacity(
                      opacity: isClicked ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 100),
                      // how much you want the animation to be long)
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            isClicked = true;
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              _controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30.0,
                              color: HexColor(CommonColor.pinkFont),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(bottom: 30, left: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            child: Container(
                              color: Colors.transparent,
                              width: 50,
                              margin: EdgeInsets.only(bottom: 0, right: 21),
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: IconButton(
                                        padding: EdgeInsets.only(left: 28.0),
                                        icon: Image.asset(
                                          AssetUtils.like_icon,
                                          color: Colors.white,
                                          height: 30,
                                          width: 30,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  Container(
                                    child: IconButton(
                                      iconSize: 30.0,
                                      padding: EdgeInsets.only(left: 28.0),
                                      icon: Image.asset(
                                        AssetUtils.comment_icon,
                                        color: HexColor('#8AFC8D'),
                                        height: 30,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // _myPage.jumpToPage(0);
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      iconSize: 30.0,
                                      padding: EdgeInsets.only(left: 28.0),
                                      icon: Image.asset(
                                        AssetUtils.share_icon,
                                        color: HexColor('#66E4F2'),
                                        height: 30,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // _myPage.jumpToPage(0);
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      iconSize: 30.0,
                                      padding: EdgeInsets.only(left: 28.0),
                                      icon: Image.asset(
                                        AssetUtils.reward_icon,
                                        color: HexColor('#F32E82'),
                                        height: 30,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // _myPage.jumpToPage(0);
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      iconSize: 30.0,
                                      padding: EdgeInsets.only(left: 28.0),
                                      icon: Image.asset(
                                        AssetUtils.music_icon,
                                        color: HexColor('#F5C93A'),
                                        height: 30,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // _myPage.jumpToPage(0);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Divider(
                                color: HexColor('#F32E82'),
                                height: 0,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          visualDensity:
                          VisualDensity(vertical: 4, horizontal: -4),
                          // tileColor: Colors.white,
                          leading: (widget.image_url.length > 0
                              ? ClipRRect(
                            borderRadius:
                            BorderRadius.circular(50),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.red,
                              child: Image.network(
                                "${widget.image_url}",
                              ),
                            ),
                          )
                              : Container(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                icon: Image.asset(
                                  AssetUtils.user_icon3,
                                  fit: BoxFit.fill,
                                ),
                                onPressed: () {},
                              ))),
                          title: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(minWidth: 100, maxWidth: 220),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            widget.singerName,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: HexColor('#ffffff'),
                                                fontFamily: "PR",
                                                fontSize: 14),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              AssetUtils.music_icon,
                                              height: 15.0,
                                              width: 15.0,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              width: 4.75,
                                            ),
                                            Text(
                                              widget.songName,
                                              style: TextStyle(
                                                  color: HexColor('#FFFFFF')
                                                      .withOpacity(0.55),
                                                  fontFamily: "PR",
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width/4,
                                    child: ReadMoreText(
                                      widget.description,
                                      trimLines: 2,
                                      colorClickableText: Colors.grey,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Show more',
                                      trimExpandedText: 'Show less',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PR",
                                          fontSize: 12),
                                      moreStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "PR",
                                          fontSize: 10),
                                    ),
                                  ),
                                  Text(
                                    'Original Audio',
                                    style: TextStyle(
                                        color: HexColor(
                                            CommonColor.pinkFont),
                                        fontFamily: "PR",
                                        fontSize: 10),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          trailing: SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          )
              : Container(),
        ));
  }
}
