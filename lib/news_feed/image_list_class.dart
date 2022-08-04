import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../my_flutter_app_icons.dart';
import 'controller/news_feed_controller.dart';
import 'heart_animation_widget.dart';
import 'news_feed_cpmment_screen.dart';

class ImageNewsFeed extends StatefulWidget {
  final String url;
  final String logo;
  final String title;
  final String description;
  final String likeCount;
  final String like_status;
  final String news_id;
  final String feedlikeStatus;

  const ImageNewsFeed(
      {Key? key,
      required this.url,
      required this.logo,
      required this.title,
      required this.description,
      required this.likeCount,
      required this.like_status,
      required this.news_id,
      required this.feedlikeStatus})
      : super(key: key);

  @override
  State<ImageNewsFeed> createState() => _ImageNewsFeedState();
}

class _ImageNewsFeedState extends State<ImageNewsFeed> {
  bool isLiked = false;
  bool isHeartAnimating = false;
  bool? liked;

  final NewsFeed_screen_controller newsFeed_screen_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() {
    setState(() {
      liked = (widget.feedlikeStatus == "true" ? true : false);
    });
    print("liked -----$liked");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (newsFeed_screen_controller.isVideoLoading.value == true
          ? Center(
        child: Material(
          color: Color(0x66DD4D4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  color: Colors.transparent,
                  height: 80,
                  width: 200,
                  child: Container(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircularProgressIndicator(
                          color: HexColor(CommonColor.pinkFont),
                        ),
                        Text(
                          'Loading...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'PR'),
                        )
                      ],
                    ),
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
            ],
          ),
        ),
      )
          : Column(
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
                    color: Colors.white, fontSize: 14, fontFamily: 'PB'),
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
              await newsFeed_screen_controller.FeedLikeUnlikeApi(
                  context: context,
                  news_post_feedlikeStatus: 'true',
                  news_post_id_type: 'liked',
                  news_post_id: widget.news_id);
              setState(() {
                liked = true;
              });
            },
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: Stack(alignment: Alignment.center, children: [
                Image.network(
                  "http://foxyserver.com/funky/images/${widget.url}",
                  fit: BoxFit.contain,
                ),
                Opacity(
                  opacity: isHeartAnimating ? 1 : 0,
                  child: HeartAnimationWidget(
                    isAnimating: isHeartAnimating,
                    duration: Duration(milliseconds: 900),
                    onEnd: () {
                      setState(() {
                        isHeartAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: HexColor(CommonColor.pinkFont),
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
              widget.description,
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: 'PR'),
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
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => NewsFeedCommantScreen(
                      //           newsID: widget.news_id,
                      //         )));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => NewsFeedCommantScreen(newsID: widget.news_id,)),
                              (route) => false
                      );
                    }),
                Text(
                  '1',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'PR'),
                ),
                IconButton(
                    padding: EdgeInsets.only(left: 5.0),
                    icon: Image.asset(
                      AssetUtils.like_icon_filled,
                      color: (liked == false
                          ? Colors.white
                          : HexColor(CommonColor.pinkFont)),
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () async {
                      await newsFeed_screen_controller.FeedLikeUnlikeApi(
                          context: context,
                          news_post_feedlikeStatus:
                          (liked == true ? 'false' : 'true'),
                          news_post_id_type:
                          (liked == true ? 'unliked' : 'liked'),
                          news_post_id: widget.news_id);

                      if (newsFeed_screen_controller
                          .feedLikeUnlikeModel!.error ==
                          false) {
                        if (newsFeed_screen_controller
                            .feedLikeUnlikeModel!
                            .user![0]
                            .feedlikeStatus ==
                            'false') {
                          setState(() {
                            liked = false;
                          });
                        } else {
                          setState(() {
                            liked = true;
                          });
                        }
                        print(newsFeed_screen_controller
                            .feedLikeUnlikeModel!
                            .user![0]
                            .feedlikeStatus);
                        print(widget.feedlikeStatus);
                      }
                    }),
                Text(
                  widget.likeCount,
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
                    onPressed: () {}),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      )),
    );
  }
}
