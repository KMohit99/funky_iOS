import 'dart:async';

import 'package:drag_ball/drag_ball.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'dart:math' as math;

// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/homepage/controller/homepage_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/custom_appbar.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../drawerScreen.dart';
import '../controller/homepage_controller.dart';
import 'better_video.dart';
import 'common_video_class.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());

  bool _onTouch = true;

  Timer? _timer;

  @override
  void initState() {
    init();
    // **
    super.initState();
  }

  init() async {
    await homepageController.getAllVideosList();
    await video_method();
  }

  video_method() {}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Dragball(
          iconPosition: IconPosition.center,
          ball: Container(),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(100),
          //     // color: Colors.pink
          //   ),
          //   child: Stack(
          //     children: [
          //       MyArc2(diameter: 100),
          //       // FlutterLogo(
          //       //   size: 50,
          //       // ),
          //     ],
          //   ),
          //   // child: const FlutterLogo(
          //   //   size: 70,
          //   // ),
          // ),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 0,
          ),
          initialPosition: const DragballPosition(
            top: 200,
            isRight: false,
            isHide: false,
          ),
          onTap: () {
            debugPrint('Dragball Tapped ${DateTime.now().microsecond}');
          },
          onPositionChanged: (DragballPosition position) {
            debugPrint(position.toString());
          },
          // scrollAndHide: false,
          // ball: Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(100),
          //     // color: Colors.pink
          //   ),
          //   child: Stack(
          //     children: [
          //       MyArc2(diameter: 100),
          //       // FlutterLogo(
          //       //   size: 50,
          //       // ),
          //     ],
          //   ),
          //   // child: const FlutterLogo(
          //   //   size: 70,
          //   // ),
          // ),
          // iconSize:20,
          // icon: Icon(
          //   Icons.arrow_back_ios,
          //   color: Colors.white,
          //   size: 0,
          // ),
          // iconPosition: IconPosition.center,
          // initialPosition: const DragballPosition(
          //   top: 200,
          //   isRight: false,
          //   isHide: false,
          // ),
          // onTap: () {
          //   debugPrint('Dragball Tapped ${DateTime.now().microsecond}');
          // },
          // onPositionChanged: (DragballPosition position) {
          //   debugPrint(position.toString());
          // },
          child: Stack(
            children: [
              Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  drawer: DrawerScreen(),
                  // appBar: CustomAppbar(
                  //   lable_tex: 'Dashboard',
                  //   // ondrawertap: () {
                  //   //   widget.scaffoldKey.currentState!.openDrawer();
                  //   // },
                  // ),
                  body: Obx(() => (homepageController.isVideoLoading != true &&
                          homepageController.videoListModel != null)
                      ? Center(
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homepageController
                                  .videoListModel!.data!.length,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return
                                    // VideoDetails(url: homepageController
                                    //         .videoListModel!.data![index].videoUrl!,);
                                    VideoWidget(
                                  url: homepageController.videoListModel!
                                      .data![index].uploadVideo!,
                                  play: true,
                                  songName: homepageController
                                      .videoListModel!.data![index].musicName!,
                                  image_url: (homepageController.videoListModel!
                                              .data![index].user!.profileUrl ==
                                          null
                                      ? ''
                                      : homepageController.videoListModel!
                                          .data![index].user!.profileUrl!),
                                  singerName: (homepageController
                                              .videoListModel!
                                              .data![index]
                                              .userName ==
                                          null
                                      ? ''
                                      : homepageController.videoListModel!
                                          .data![index].userName!),
                                );
                              }),
                        )
                      : Center(
                          child: Container(
                            child: Text('plaese wait'),
                          ),
                        ))),
              Positioned(
                  top: MediaQuery.of(context).size.height / 3,
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: MyPainter2(),
                        size: Size((animation_started ? _animation!.value : 35),
                            (animation_started ? _animation!.value : 35)),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: (animation_started
                                    ? _animation_circle!.value
                                    : 0),
                                width: (animation_started
                                    ? _animation_circle!.value
                                    : 0),
                                margin: EdgeInsets.only(bottom:(animation_started ? _animation_padding1!.value: 0), left: (animation_started ? _animation_padding2!.value: 0)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    AssetUtils.ball_icon_1,
                                    color: Colors.white,
                                    height: (animation_started
                                        ? _animation_icon!.value
                                        : 0),
                                    width: (animation_started
                                        ? _animation_icon!.value
                                        : 0),
                                  ),
                                )
                                // Icon(Icons.person,
                                //     size: (animation_started
                                //         ? _animation_icon!.value
                                //         : 0)),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        color: Colors.transparent,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          children: [
                                            Container(
                                                child: MyArc3(diameter: 100)),
                                            IconButton(
                                              padding: EdgeInsets.only(right: 10),
                                              visualDensity: VisualDensity(
                                                  horizontal: -4, vertical: -4),
                                              onPressed: () {
                                                setState(() {
                                                  if (animation_started) {
                                                    close_animation();
                                                  } else {
                                                    start_animation();
                                                  }
                                                  // (animation_started ? false : true);
                                                  print(animation_started);
                                                });
                                                // start_animation();
                                              },
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: (animation_started
                                            ? _animation_circle!.value
                                            : 0),
                                        width: (animation_started
                                            ? _animation_circle!.value
                                            : 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.pink, width: 1)),
                                        margin: EdgeInsets.only(left: (animation_started ? _animation_padding1!.value: 0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            AssetUtils.ball_icon_2,
                                            color: Colors.pink,
                                            height: (animation_started
                                                ? _animation_icon!.value
                                                : 0),
                                            width: (animation_started
                                                ? _animation_icon!.value
                                                : 0),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                  height: (animation_started
                                      ? _animation_circle!.value
                                      : 0),
                                  width: (animation_started
                                      ? _animation_circle!.value
                                      : 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  margin:
                                      EdgeInsets.only(left: (animation_started ? _animation_padding2!.value: 0), top: (animation_started ? _animation_padding1!.value: 0))
                                  ,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      AssetUtils.ball_icon_3,
                                      color: Colors.white,
                                      height: (animation_started
                                          ? _animation_icon!.value
                                          : 0),
                                      width: (animation_started
                                          ? _animation_icon!.value
                                          : 0),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ],
      // child:
    );
  }

  AnimationController? _animationController;
  Animation? _animation;
  Animation? _animation_circle;
  Animation? _animation_icon;
  Animation? _animation_padding1;
  Animation? _animation_padding2;
  bool animation_started = false;

  start_animation() {
    setState(() {
      animation_started = true;
      print(animation_started);
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController!.forward();
    _animation = Tween(begin: 40.0, end: 180.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    _animation_circle =
        Tween(begin: 0.0, end: 40.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_icon =
        Tween(begin: 0.0, end: 30.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_padding1 =
        Tween(begin: 0.0, end: 20.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_padding2 =
        Tween(begin: 0.0, end: 10.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
  }

  close_animation() {
    setState(() {
      animation_started = false;
    });
    _animationController!.reverse();
  }
}
