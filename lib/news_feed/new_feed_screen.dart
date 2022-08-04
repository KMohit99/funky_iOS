import 'package:flutter/material.dart';
import 'package:funky_new/news_feed/heart_animation_widget.dart';
import 'package:funky_new/news_feed/video_list_class.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
// import 'package:funky_project/news_feed/news_feed_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_appbar.dart';
import '../Utils/custom_textfeild.dart';
import '../drawerScreen.dart';
import 'image_list_class.dart';
import 'controller/news_feed_controller.dart';
import 'news_feed_cpmment_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final NewsFeed_screen_controller news_feed_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  bool isLiked = false;
  bool isHeartAnimating = false;

  @override
  void initState() {
    news_feed_controller.getAllNewsFeedList();
    super.initState();
  }

  init() {
    // setState(() {
    //   liked = (news_feed_controller
    //                   .newsfeedModel!
    //                   .data![index]
    //                   .feedlikeStatus! == "true" ? true : false);
    // });
    // print("liked -----$liked");
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        drawer: DrawerScreen(),
        // appBar: CustomAppbar(
        //   lable_tex: 'News Feed',
        //   // ondrawertap: () {
        //   //   _scaffoldKey.currentState!.openDrawer();
        //   // },
        // ),
        body: Container(
          margin: const EdgeInsets.only(
            top: 80,
          ),
          child: Column(
            children: [
              Container(
                color: Colors.red,
              ),
              Expanded(
                child: Obx(() => news_feed_controller.isVideoLoading.value !=
                        true
                    ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 0, top: 00),
                        shrinkWrap: true,
                        itemCount:
                            news_feed_controller.newsfeedModel!.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // liked = (news_feed_controller
                          //             .newsfeedModel!.data![index].feedlikeStatus! ==
                          //         "true"
                          //     ? true
                          //     : false);
                          return Center(
                            child: Column(
                              children: [
                                Container(
                                  child: ListTile(
                                    visualDensity: VisualDensity(
                                        vertical: 0, horizontal: -4),
                                    dense: true,
                                    leading: Container(
                                      width: 50,
                                      child: CircleAvatar(
                                        radius: 48, // Image radius
                                        backgroundImage: NetworkImage(
                                          "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel!.data![index].logo!}",
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
                                      news_feed_controller
                                          .newsfeedModel!.data![index].title!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'PB'),
                                    ),
                                    // trailing: IconButton(
                                    //   icon: Icon(
                                    //     Icons.more_vert,
                                    //     color: Colors.white,
                                    //     size: 20,
                                    //   ),
                                    //   onPressed: () {},
                                    // ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onDoubleTap: () async {
                                    setState(() {
                                      isLiked = true;
                                      isHeartAnimating = true;
                                    });
                                    await news_feed_controller
                                        .FeedLikeUnlikeApi(
                                            context: context,
                                            news_post_feedlikeStatus: 'true',
                                            news_post_id_type: 'liked',
                                            news_post_id: news_feed_controller
                                                .newsfeedModel!
                                                .data![index]
                                                .newsID!);

                                    if (news_feed_controller
                                            .feedLikeUnlikeModel!.error ==
                                        false) {
                                      print(
                                          "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");

                                      setState(() {
                                        news_feed_controller.newsfeedModel!
                                                .data![index].feedLikeCount =
                                            news_feed_controller
                                                .feedLikeUnlikeModel!
                                                .user![0]
                                                .feedLikeCount;

                                        news_feed_controller.newsfeedModel!
                                                .data![index].feedlikeStatus =
                                            news_feed_controller
                                                .feedLikeUnlikeModel!
                                                .user![0]
                                                .feedlikeStatus!;
                                      });

                                      print(
                                          "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                                    }
                                    // setState(() {
                                    //   liked = true;
                                    // });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          (news_feed_controller
                                                  .newsfeedModel!
                                                  .data![index]
                                                  .postImage!
                                                  .isNotEmpty
                                              ? FadeInImage.assetNetwork(
                                                  fit: BoxFit.contain,
                                                  image:
                                                      "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel!.data![index].postImage}",
                                                  placeholder:
                                                      'assets/images/Funky_App_Icon.png',
                                                )
                                              : (news_feed_controller
                                                      .newsfeedModel!
                                                      .data![index]
                                                      .uploadVideo!
                                                      .isNotEmpty
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/Funky_App_Icon.png',
                                                        ),
                                                        Center(
                                                            child: GestureDetector(
                                                                // onTap: _playPause,
                                                                child: Icon(
                                                          Icons.play_circle,
                                                          color: Colors.white,
                                                          size: 50,
                                                        )))
                                                      ],
                                                    )
                                                  : Center(
                                                      child: GestureDetector(
                                                          // onTap: _playPause,
                                                          child: Icon(
                                                      Icons.play_circle,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ))))),
                                          Opacity(
                                            opacity: isHeartAnimating ? 1 : 0,
                                            child: HeartAnimationWidget(
                                              isAnimating: isHeartAnimating,
                                              duration:
                                                  Duration(milliseconds: 900),
                                              onEnd: () {
                                                setState(() {
                                                  isHeartAnimating = false;
                                                });
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                color: HexColor(
                                                    CommonColor.pinkFont),
                                                size: 100,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 16, top: 13),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    news_feed_controller.newsfeedModel!
                                        .data![index].description!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'PR'),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          padding: EdgeInsets.only(left: 5.0),
                                          icon: Icon(
                                            Icons.message,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewsFeedCommantScreen(
                                                          newsID:
                                                              news_feed_controller
                                                                  .newsfeedModel!
                                                                  .data![index]
                                                                  .newsID!,
                                                        )));
                                          }),
                                      Text(
                                        news_feed_controller.newsfeedModel!
                                            .data![index].feedCount!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'PR'),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.only(left: 5.0),
                                          icon: Image.asset(
                                            AssetUtils.like_icon_filled,
                                            color: (news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .feedlikeStatus ==
                                                    'false'
                                                ? Colors.white
                                                : HexColor(
                                                    CommonColor.pinkFont)),
                                            height: 20,
                                            width: 20,
                                          ),
                                          onPressed: () async {
                                            await news_feed_controller.FeedLikeUnlikeApi(
                                                context: context,
                                                news_post_feedlikeStatus:
                                                    (news_feed_controller
                                                                .newsfeedModel!
                                                                .data![index]
                                                                .feedlikeStatus! ==
                                                            "true"
                                                        ? 'false'
                                                        : 'true'),
                                                news_post_id_type:
                                                    (news_feed_controller
                                                                .newsfeedModel!
                                                                .data![index]
                                                                .feedlikeStatus! ==
                                                            "true"
                                                        ? 'unliked'
                                                        : 'liked'),
                                                news_post_id:
                                                    news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .newsID!);

                                            if (news_feed_controller
                                                    .feedLikeUnlikeModel!
                                                    .error ==
                                                false) {
                                              // if (news_feed_controller
                                              //         .feedLikeUnlikeModel!
                                              //         .user![0]
                                              //         .feedlikeStatus ==
                                              //     'false') {
                                              //   setState(() {
                                              //     liked = false;
                                              //   });
                                              // } else {
                                              //   setState(() {
                                              //     liked = true;
                                              //   });
                                              // }

                                              print(
                                                  "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");

                                              setState(() {
                                                news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .feedLikeCount =
                                                    news_feed_controller
                                                        .feedLikeUnlikeModel!
                                                        .user![0]
                                                        .feedLikeCount;

                                                news_feed_controller
                                                        .newsfeedModel!
                                                        .data![index]
                                                        .feedlikeStatus =
                                                    news_feed_controller
                                                        .feedLikeUnlikeModel!
                                                        .user![0]
                                                        .feedlikeStatus!;
                                              });

                                              print(
                                                  "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
                                            }
                                          }),
                                      Text(
                                        news_feed_controller.newsfeedModel!
                                            .data![index].feedLikeCount!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'PR'),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.only(left: 5.0),
                                          icon: Image.asset(
                                            AssetUtils.share_icon2,
                                            color: Colors.white,
                                            height: 20,
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            _onShare(
                                                context: context,
                                                link:
                                                    "${URLConstants.base_data_url}images/${news_feed_controller.newsfeedModel!.data![index].postImage}");
                                          }),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Container(
                            height: 80,
                            width: 100,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircularProgressIndicator(
                                  color: HexColor(CommonColor.pinkFont),
                                ),
                              ],
                            )
                            // Material(
                            //   color: Colors.transparent,
                            //   child: LoadingIndicator(
                            //     backgroundColor: Colors.transparent,
                            //     indicatorType: Indicator.ballScale,
                            //     colors: _kDefaultRainbowColors,
                            //     strokeWidth: 4.0,
                            //     pathBackgroundColor: Colors.yellow,
                            //     // showPathBackground ? Colors.black45 : null,
                            //   ),
                            // ),
                            ),
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onShare({required BuildContext context, required String link}) async {
    Share.share(link, subject: 'Share App');
  }
}
