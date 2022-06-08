import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/common_buttons.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final String singerName;
  final String songName;
  final String url;
  final String image_url;

  const VideoWidget({
    Key? key,
    required this.url,
    required this.play,
    required this.singerName,
    required this.songName,
    required this.image_url,
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

  AlertBox() {
    return showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          backgroundColor: Colors.black,
          title: Container(
            // margin: EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(AssetUtils.lock_icon,
                        height: 27,
                        width: 027,
                        fit: BoxFit.fill,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Sign up for more videos",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "PR", fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10, right: 35, left: 35),
              child: common_button(
                onTap: () {
                  // openCamera();
                  // Get.toNamed(BindingUtils.signupOption);
                },
                backgroud_color: Colors.white,
                lable_text: 'Sign up',
                lable_text_color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: InkWell(
          onTap: () {
            _onTouch ? false : true;
          },
          child: Stack(
            children: [
              _controller!.value.isInitialized
                  ?
                  // Container(
                  //       color: Colors.pink,
                  //         height: MediaQuery.of(context).size.height,
                  //         child: VideoPlayer(_controller!))

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                        child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!)),
                      ),
                  )
                  : Container(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#000000"),
                      HexColor("#000000").withOpacity(0.7),
                      HexColor("#000000").withOpacity(0.3),
                      Colors.transparent
                    ],
                  ),
                ),
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height/5,
              ),
              Center(
                child: Visibility(
                  visible: _onTouch,
                  child: RaisedButton(
                    padding: EdgeInsets.all(60.0),
                    color: Colors.transparent,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        isClicked = true;
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      });
                    },
                    child: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 25.0,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(bottom: 20, left: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 0.0, right: 60.0),
                              child: Divider(
                                color: HexColor('#F32E82'),
                                height: 0,
                              )),
                        ),
                        SizedBox(height: 10,),
                        ListTile(
                          visualDensity:
                              VisualDensity(vertical: -4, horizontal: -4),
                          // tileColor: Colors.white,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (widget.image_url.length > 0
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          height: 50,width: 50,
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
                                  SizedBox(width: 15,),
                                  Column(
                                    children: [
                                      Text(
                                        widget.singerName,
                                        style: TextStyle(
                                            color: HexColor('#D4D4D4'),
                                            fontFamily: "PR",
                                            fontSize: 14),
                                      ),
                                      Text(
                                        'Original Audio',
                                        style: TextStyle(
                                            color:
                                                HexColor(CommonColor.pinkFont),
                                            fontFamily: "PR",
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
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
                          trailing: SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  child: Container(
                    color: Colors.transparent,
                    width: 50,
                    margin: EdgeInsets.only(bottom: 30, right: 21),
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
            ],
          ),
        ));
  }
}
