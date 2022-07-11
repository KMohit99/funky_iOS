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
        Stack(
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
                body:
                    Obx(() =>
                        (homepageController.isVideoLoading.value != true &&
                                homepageController.videoListModel != null &&
                                homepageController.isimageLoading.value != true &&
                                homepageController.imageListModel != null)
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                          GestureDetector(
                                              onDoubleTap: () async {
                                                setState(() {
                                                  isLiked = true;
                                                  isHeartAnimating = true;
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    // margin: const EdgeInsets.symmetric(vertical: 100),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: (homepageController
                                                            .imageListModel!
                                                            .data![index]
                                                            .postImage!
                                                            .isNotEmpty
                                                        ? CachedNetworkImage(
                                                            imageUrl:
                                                                'http://foxyserver.com/funky/images/${homepageController.imageListModel!.data![index].postImage!}',
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Center(
                                                              child: Container(
                                                                height: 80,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    new CircularProgressIndicator(
                                                                      color: HexColor(
                                                                          CommonColor
                                                                              .pinkFont),
                                                                      strokeWidth:
                                                                          4,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                new Icon(Icons
                                                                    .error),
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          )
                                                        : Image.asset(
                                                            AssetUtils.logo)),
                                                  ),

                                                  Opacity(
                                                    opacity: isHeartAnimating
                                                        ? 1
                                                        : 0,
                                                    child: HeartAnimationWidget(
                                                      isAnimating:
                                                          isHeartAnimating,
                                                      duration: Duration(
                                                          milliseconds: 900),
                                                      onEnd: () {
                                                        setState(() {
                                                          isHeartAnimating =
                                                              false;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: HexColor(
                                                            CommonColor
                                                                .pinkFont),
                                                        size: 100,
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          HexColor("#000000")
                                                              .withOpacity(0.9),
                                                          HexColor("#000000")
                                                              .withOpacity(0.3),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0),
                                                          HexColor("#000000")
                                                              .withOpacity(0.3),
                                                          HexColor("#000000")
                                                              .withOpacity(0.9),
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
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: SizedBox(
                                                      child: Container(
                                                        // color: Colors.red,
                                                        margin: EdgeInsets.only(
                                                            bottom: 30,
                                                            left: 21),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: SizedBox(
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 50,
                                                                  margin: EdgeInsets.only(
                                                                      bottom: 0,
                                                                      right: 21,
                                                                      left:
                                                                          20.0),
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      IconButton(
                                                                          visualDensity: VisualDensity(
                                                                              vertical:
                                                                                  -4),
                                                                          padding: EdgeInsets.only(
                                                                              left:
                                                                                  0.0),
                                                                          icon: Image
                                                                              .asset(
                                                                            AssetUtils.like_icon_filled,
                                                                            color: (homepageController.imageListModel!.data![index].likeStatus == 'false'
                                                                                ? Colors.white
                                                                                : HexColor(CommonColor.pinkFont)),
                                                                            scale:
                                                                                3,
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            await homepageController.PostLikeUnlikeApi(
                                                                                context: context,
                                                                                post_id: homepageController.imageListModel!.data![index].iD!,
                                                                                post_id_type: (homepageController.imageListModel!.data![index].likeStatus == "true" ? 'unliked' : 'liked'),
                                                                                post_likeStatus: (homepageController.imageListModel!.data![index].likeStatus == "true" ? 'false' : 'true'));
                                                                            if (homepageController.postLikeUnlikeModel!.error ==
                                                                                false) {
                                                                              print("mmmmm${homepageController.imageListModel!.data![index].likes!}");
                                                                              setState(() {
                                                                                homepageController.imageListModel!.data![index].likes = homepageController.postLikeUnlikeModel!.user![0].likes!;

                                                                                homepageController.imageListModel!.data![index].likeStatus = homepageController.postLikeUnlikeModel!.user![0].likeStatus!;
                                                                              });
                                                                              print("mmmmm${homepageController.imageListModel!.data![index].likes!}");
                                                                            }
                                                                          }),
                                                                      Container(
                                                                        child: Text(
                                                                            homepageController.imageListModel!.data![index].likes!,
                                                                            style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PR')),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      IconButton(
                                                                        visualDensity:
                                                                            VisualDensity(vertical: -4),
                                                                        iconSize:
                                                                            30.0,
                                                                        padding:
                                                                            EdgeInsets.only(left: 0.0),
                                                                        icon: Image
                                                                            .asset(
                                                                          AssetUtils
                                                                              .comment_icon,
                                                                          color:
                                                                              HexColor('#8AFC8D'),
                                                                          scale:
                                                                              3,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => PostImageCommentScreen(
                                                                                        PostID: homepageController.imageListModel!.data![index].iD!,
                                                                                      )));
                                                                          // setState(() {
                                                                          //   // _myPage.jumpToPage(0);
                                                                          // });
                                                                        },
                                                                      ),
                                                                      Container(
                                                                        child: Text(
                                                                            '${homepageController.imageListModel!.data![index].commentCount}',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 12,
                                                                                fontFamily: 'PR')),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      IconButton(
                                                                        visualDensity:
                                                                            VisualDensity(vertical: -4),
                                                                        padding:
                                                                            EdgeInsets.only(left: 0.0),
                                                                        icon: Image
                                                                            .asset(
                                                                          AssetUtils
                                                                              .share_icon,
                                                                          color:
                                                                              HexColor('#66E4F2'),
                                                                          scale:
                                                                              2,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            // _myPage.jumpToPage(0);
                                                                          });
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      IconButton(
                                                                        visualDensity:
                                                                            VisualDensity(vertical: -4),
                                                                        iconSize:
                                                                            30.0,
                                                                        padding:
                                                                            EdgeInsets.only(left: 0.0),
                                                                        icon: Image
                                                                            .asset(
                                                                          AssetUtils
                                                                              .reward_icon,
                                                                          color:
                                                                              HexColor('#F32E82'),
                                                                          scale:
                                                                              3,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            // _myPage.jumpToPage(0);
                                                                          });
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      IconButton(
                                                                        visualDensity:
                                                                            VisualDensity(vertical: -4),
                                                                        padding:
                                                                            EdgeInsets.only(left: 0.0),
                                                                        icon: Image
                                                                            .asset(
                                                                          AssetUtils
                                                                              .music_icon,
                                                                          color:
                                                                              HexColor('#F5C93A'),
                                                                          scale:
                                                                              3,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            // _myPage.jumpToPage(0);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0,
                                                                      right:
                                                                          15.0),
                                                                  child:
                                                                      Divider(
                                                                    color: HexColor(
                                                                        '#F32E82'),
                                                                    height: 10,
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            ListTile(
                                                              visualDensity:
                                                                  const VisualDensity(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          -4),
                                                              // tileColor: Colors.white,
                                                              title: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      (homepageController
                                                                              .imageListModel!
                                                                              .data![index]
                                                                              .user!
                                                                              .image!
                                                                              .isNotEmpty
                                                                          ? ClipRRect(
                                                                              borderRadius: BorderRadius.circular(50),
                                                                              child: Container(
                                                                                height: 50,
                                                                                width: 50,
                                                                                color: Colors.red,
                                                                                child: Image.network(
                                                                                  "http://foxyserver.com/funky/images/${homepageController.imageListModel!.data![index].user!.image!}",
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : (homepageController.imageListModel!.data![index].user!.profileUrl!.isNotEmpty
                                                                              ? ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: 50,
                                                                                    color: Colors.red,
                                                                                    child: Image.network(
                                                                                      homepageController.imageListModel!.data![index].user!.profileUrl!,
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
                                                                                  )))),
                                                                      const SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            homepageController.imageListModel!.data![index].fullName!,
                                                                            style: TextStyle(
                                                                                color: HexColor('#D4D4D4'),
                                                                                fontFamily: "PB",
                                                                                fontSize: 14),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 2,
                                                                            child:
                                                                                ReadMoreText(
                                                                              homepageController.imageListModel!.data![index].description!,
                                                                              trimLines: 2,
                                                                              colorClickableText: Colors.grey,
                                                                              trimMode: TrimMode.Line,
                                                                              trimCollapsedText: 'Show more',
                                                                              trimExpandedText: 'Show less',
                                                                              style: TextStyle(color: Colors.white, fontFamily: "PR", fontSize: 12),
                                                                              moreStyle: TextStyle(color: Colors.grey, fontFamily: "PR", fontSize: 10),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing:
                                                                  const SizedBox
                                                                      .shrink(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topLeft: const Radius
                                                                  .circular(5),
                                                              bottomLeft:
                                                                  const Radius
                                                                          .circular(
                                                                      5)),
                                                          color: HexColor(
                                                              '#C12265')),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8.0,
                                                                horizontal: 10),
                                                        child: Text(
                                                          'I AM here',
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  '#D4D4D4'),
                                                              fontFamily: "PR",
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : (selected_wheel == 1
                                              ?
                                              // VideoDetails(url: homepageController
                                              //         .videoListModel!.data![index].videoUrl!,);
                                              VideoWidget(
                                                  url: homepageController
                                                      .videoListModel!
                                                      .data![index]
                                                      .uploadVideo!,
                                                  comment_count: homepageController
                                                      .videoListModel!
                                                      .data![index]
                                                      .commentCount!,
                                                  play: true,
                                                  description:
                                                      homepageController
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
                                                      : homepageController
                                                          .videoListModel!
                                                          .data![index]
                                                          .userName!),
                                                  video_id: homepageController
                                                      .videoListModel!
                                                      .data![index]
                                                      .iD!,
                                                  video_like_count:
                                                      homepageController
                                                          .videoListModel!
                                                          .data![index]
                                                          .likes!,
                                                  video_like_status:
                                                      homepageController
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
                                                  description:
                                                      homepageController
                                                          .imageListModel!
                                                          .data![index]
                                                          .description!,
                                                  SocialProfileUrl:
                                                      homepageController
                                                          .imageListModel!
                                                          .data![index]
                                                          .user!
                                                          .profileUrl!,
                                                  image_like_count:
                                                      homepageController
                                                          .imageListModel!
                                                          .data![index]
                                                          .likes!,
                                                  image_id: homepageController
                                                      .imageListModel!
                                                      .data![index]
                                                      .iD!,
                                                  image_like_status:
                                                      homepageController
                                                          .imageListModel!
                                                          .data![index]
                                                          .likeStatus!,
                                                )));
                                    }),
                              )
                            : Center(
                                child: Container(
                                  child: Text('plaese wait'),
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
                          outerRadius: (animation_started
                              ? _animation_wheel!.value
                              : 80),
                          innerRadius: (animation_started
                              ? _animation_wheel2!.value
                              : 0),
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
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
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
                                          builder: (context) =>
                                              FollowersList()));
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
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
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
        ),
      ],
      // child:
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
