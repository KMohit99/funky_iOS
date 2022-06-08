import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:funky_new/Authentication/authentication_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/common_buttons.dart';

class video_class extends StatefulWidget {
  final bool play;
  final String singerName;
  final String songName;
  final String url;

  const video_class(
      {Key? key,
      required this.play,
      required this.singerName,
      required this.songName,
      required this.url})
      : super(key: key);

  @override
  State<video_class> createState() => _video_classState();
}

class _video_classState extends State<video_class> {
  VideoPlayerController? _controller;

  bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    _controller = VideoPlayerController.network("http://foxyserver.com/funky/video/${widget.url}");

    _controller!.setLooping(true);
    _controller!.initialize().then((_) {
      setState(() {});
    });
    _controller!.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _timer?.cancel();

    super.dispose();
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
                GestureDetector(
                  onTap: (){
                  },
                  child: Text(
                    "Sign up for more videos",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "PR", fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10, right: 35, left: 35),
              child: common_button(
                onTap: () {
                  Get.to(AuthenticationScreen());
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
                  ? VideoPlayer(_controller!)
                  : Container(),
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
                                  left: 10.0, right: 60.0),
                              child: Divider(
                                color: HexColor('#F32E82'),
                                height: 0,
                              )),
                        ),
                        ListTile(
                          // tileColor: Colors.white,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.singerName,
                                style: TextStyle(
                                    color: HexColor('#D4D4D4'),
                                    fontFamily: "PR",
                                    fontSize: 14),
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
                          subtitle: Text(
                            'Original Audio',
                            style: TextStyle(
                                color: HexColor(CommonColor.pinkFont),
                                fontFamily: "PR",
                                fontSize: 10),
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
                    margin: EdgeInsets.only(bottom: 60, right: 21),
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
                              onPressed: () {
                                AlertBox();
                              }),
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
                              AlertBox();
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
                              AlertBox();
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
                              AlertBox();
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
                              AlertBox();
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
