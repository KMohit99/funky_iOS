import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/homepage/ui/common_image_class.dart';
import 'package:funky_new/homepage/ui/post_image_commet_scren.dart';

// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/homepage/controller/homepage_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

// import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../drawerScreen.dart';
import '../../news_feed/heart_animation_widget.dart';
import '../../profile_screen/followers_screen.dart';
import '../controller/homepage_controller.dart';
import 'common_video_class.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
    await homepageController.getAllImagesList();
    await video_method();
  }

  video_method() {}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<String> wheel_icons = [
    AssetUtils.ball_icon_1,
    AssetUtils.ball_icon_2,
    AssetUtils.ball_icon_3,
    AssetUtils.ball_icon_3,
    AssetUtils.ball_icon_2,
  ];
  int selected_wheel = 1;

  int _currentPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLiked = false;
  bool isHeartAnimating = false;

  // VideoPlayerController? controller_last;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            drawer: DrawerScreen(),
            // appBar: CustomAppbar(
            //   lable_tex: 'Dashboard',
            //   // ondrawertap: () {
            //   //   widget.scaffoldKey.currentState!.openDrawer();
            //   // },
            // ),
            body: Obx(() => (homepageController.isVideoLoading.value != true &&
                    // homepageController.videoListModel != null &&
                    homepageController.isimageLoading.value != true
                // && homepageController.imageListModel != null
                )
                ? Center(
                  child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (selected_wheel == 0
                            ? homepageController.imageListModel!.data!.length
                            : homepageController
                                .videoListModel!.data!.length),
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return (selected_wheel == 0
                              ?
                              // ImageWidget(
                              //         useerName: homepageController
                              //             .imageListModel!
                              //             .data![index]
                              //             .fullName!,
                              //         Imageurl: homepageController
                              //             .imageListModel!
                              //             .data![index]
                              //             .postImage!,
                              //         ProfileUrl: homepageController
                              //             .imageListModel!
                              //             .data![index]
                              //             .user!
                              //             .image!,
                              //         description: homepageController
                              //             .imageListModel!
                              //             .data![index]
                              //             .description!,
                              //         SocialProfileUrl: homepageController
                              //             .imageListModel!
                              //             .data![index]
                              //             .user!
                              //             .profileUrl!,
                              //         image_like_count: homepageController
                              //             .imageListModel!.data![index].likes!,
                              //         image_id: homepageController
                              //             .imageListModel!.data![index].iD!,
                              //         image_like_status: homepageController
                              //             .imageListModel!
                              //             .data![index]
                              //             .likeStatus!,
                              //       )
                              ImageWidget(
                                  useerName: homepageController
                                      .imageListModel!.data![index].fullName!,
                                  Imageurl: homepageController.imageListModel!
                                      .data![index].postImage!,
                                  ProfileUrl: homepageController
                                      .imageListModel!
                                      .data![index]
                                      .user!
                                      .image!,
                                  description: homepageController
                                      .imageListModel!
                                      .data![index]
                                      .description!,
                                  SocialProfileUrl: homepageController
                                      .imageListModel!
                                      .data![index]
                                      .user!
                                      .profileUrl!,
                                  image_like_count: homepageController
                                      .imageListModel!.data![index].likes!,
                                  image_id: homepageController
                                      .imageListModel!.data![index].iD!,
                                  image_like_status: homepageController
                                      .imageListModel!
                                      .data![index]
                                      .likeStatus!,
                                )
                              : (selected_wheel == 1
                                  ?
                                  // VideoDetails(url: homepageController
                                  //         .videoListModel!.data![index].videoUrl!,);
                                  VideoWidget(
                                    videoListModel: homepageController.videoListModel!
                                        .data![index],
                                      url: homepageController.videoListModel!
                                          .data![index].uploadVideo!,
                                      comment_count: homepageController
                                          .videoListModel!
                                          .data![index]
                                          .commentCount!,
                                      play: true,
                                      description: homepageController
                                          .videoListModel!
                                          .data![index]
                                          .description!,
                                      songName: homepageController
                                          .videoListModel!
                                          .data![index]
                                          .musicName!,
                                      image_url: (homepageController
                                                  .videoListModel!
                                                  .data![index]
                                                  .user!
                                                  .profileUrl ==
                                              null
                                          ? ''
                                          : homepageController
                                              .videoListModel!
                                              .data![index]
                                              .user!
                                              .profileUrl!),
                                      singerName: (homepageController
                                                  .videoListModel!
                                                  .data![index]
                                                  .userName ==
                                              null
                                          ? ''
                                          : homepageController.videoListModel!
                                              .data![index].userName!),
                                      video_id: homepageController
                                          .videoListModel!.data![index].iD!,
                                      video_like_count: homepageController
                                          .videoListModel!
                                          .data![index]
                                          .likes!,
                                      video_like_status: homepageController
                                          .videoListModel!
                                          .data![index]
                                          .likeStatus!,
                                    )
                                  : ImageWidget(
                                      useerName: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .fullName!,
                                      Imageurl: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .postImage!,
                                      ProfileUrl: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .user!
                                          .image!,
                                      description: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .description!,
                                      SocialProfileUrl: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .user!
                                          .profileUrl!,
                                      image_like_count: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .likes!,
                                      image_id: homepageController
                                          .imageListModel!.data![index].iD!,
                                      image_like_status: homepageController
                                          .imageListModel!
                                          .data![index]
                                          .likeStatus!,
                                    )));
                        }),
                )
                : Center(
                    child: Container(
                      child: Text(
                        'plaese wait',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  ))),
        Positioned(
            top: MediaQuery.of(context).size.height / 3,
            child: Container(
              child: Stack(
                children: [
                  CustomPaint(
                    painter: MyPainter2(),
                    size: Size((animation_started ? _animation!.value : 35),
                        (animation_started ? _animation!.value : 35)),
                    child: CircleList(
                      outerRadius:
                          (animation_started ? _animation_wheel!.value : 80),
                      innerRadius:
                          (animation_started ? _animation_wheel2!.value : 0),
                      gradient: (animation_started
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                HexColor('#000000').withOpacity(0.7),
                                HexColor('#C12265').withOpacity(0.7),
                                HexColor('#C12265').withOpacity(0.7),
                                HexColor('#ffffff').withOpacity(0.7),
                              ],
                            )
                          : LinearGradient(colors: [
                              Colors.transparent,
                              Colors.transparent,
                            ])),
                      origin: Offset(-60, 0),
                      centerWidget: Container(
                        height: 35,
                        width: 35,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(child: MyArc3(diameter: 100)),
                            IconButton(
                              padding: EdgeInsets.only(right: 20),
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onPressed: () {
                                setState(() {
                                  close_animation();

                                  // (animation_started ? false : true);
                                  print(animation_started);
                                });
                                // start_animation();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: (animation_started ? 15 : 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            print(index);
                            setState(() {
                              selected_wheel = index;
                            });
                            if (selected_wheel == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FollowersList()));
                              // Get.to(FollowersList());
                            }
                          },
                          child: Container(
                              height: (animation_started
                                  ? _animation_circle!.value
                                  : 0),
                              width: (animation_started
                                  ? _animation_circle!.value
                                  : 0),
                              // margin: EdgeInsets.only(
                              //     bottom: (animation_started
                              //         ? _animation_padding1!.value
                              //         : 0),
                              //     left: (animation_started
                              //         ? _animation_padding2!.value
                              //         : 0)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: (selected_wheel == index
                                          ? Colors.pink
                                          : Colors.white),
                                      width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  wheel_icons[index],
                                  color: (selected_wheel == index
                                      ? Colors.pink
                                      : Colors.white),
                                  height: (animation_started
                                      ? _animation_icon!.value
                                      : 0),
                                  width: (animation_started
                                      ? _animation_icon!.value
                                      : 0),
                                ),
                              )),
                        );
                      }),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: (animation_started ? 0 : 35),
                        width: (animation_started ? 0 : 35),
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                                child: MyArc3(
                                    diameter: (animation_started
                                        ? _animation_arrow!.value
                                        : 80))),
                            IconButton(
                              padding: EdgeInsets.only(right: 20),
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              onPressed: () {
                                start_animation();
                                Future.delayed(Duration(seconds: 5), () {
                                  close_animation();
                                });
                                // (animation_started ? false : true);
                                print(animation_started);
                                // start_animation();
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: (animation_started ? 0 : 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  AnimationController? _animationController;
  Animation? _animation;
  Animation? _animation_wheel;
  Animation? _animation_wheel2;
  Animation? _animation_arrow;
  Animation? _animation_circle;
  Animation? _animation_icon;
  bool animation_started = false;

  start_animation() {
    setState(() {
      animation_started = true;
      print(animation_started);
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController!.forward();
    _animation = Tween(begin: 40.0, end: 180.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    _animation_wheel =
        Tween(begin: 0.0, end: 80.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_wheel2 =
        Tween(begin: 0.0, end: 20.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_arrow =
        Tween(begin: 100.0, end: 00.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_circle =
        Tween(begin: 0.0, end: 35.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
    _animation_icon =
        Tween(begin: 0.0, end: 30.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });
  }

  close_animation() {
    setState(() {
      animation_started = false;
    });
    _animationController!.repeat();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
