import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:funky_new/Utils/App_utils.dart';
import 'package:funky_new/homepage/ui/post_image_commet_scren.dart';
import 'package:get/get.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/common_buttons.dart';
import '../../news_feed/heart_animation_widget.dart';
import '../controller/homepage_controller.dart';
import '../model/VideoList_model.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final String singerName;
  final String description;
  final String songName;
  final String url;
  final String image_url;

  final String video_id;
  final String comment_count;
  final Data_video? videoListModel;

  String video_like_count;
  String video_like_status;

  final VoidCallback? onDoubleTap;

  VideoWidget({
    Key? key,
    required this.url,
    required this.play,
    required this.singerName,
    required this.songName,
    required this.image_url,
    required this.description,
    required this.video_id,
    required this.video_like_count,
    required this.video_like_status,
    this.onDoubleTap,
    required this.comment_count,
    this.videoListModel,
  }) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  VideoPlayerController? controller_last;

  bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
    print('image urlllllllllllll ${widget.url}');
    print('image video_id ${widget.video_id}');
    print('image video_like_count ${widget.video_like_count}');
    print('image video_like_status ${widget.video_like_status}');
    controller_last = VideoPlayerController.network(
        "${URLConstants.base_data_url}video/${widget.url}");

    controller_last!.setLooping(true);
    controller_last!.initialize().then((_) {
      setState(() {});
    });
    (widget.play ? controller_last!.play() : controller_last!.pause());
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
    controller_last!.dispose();
  }

  int _currentPage = 0;

  // an arbitrary value, this can be whatever you need it to be
  double videoContainerRatio = 0.5;

  double getScale() {
    double videoRatio = controller_last!.value.aspectRatio;

    if (videoRatio < videoContainerRatio) {
      ///for tall videos, we just return the inverse of the controller aspect ratio
      return videoContainerRatio / videoRatio;
    } else {
      ///for wide videos, divide the video AR by the fixed container AR
      ///so that the video does not over scale

      return videoRatio / videoContainerRatio;
    }
  }

  bool isLiked = false;
  bool isHeartAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: GestureDetector(
          onTap: () {
            setState(() {
              isClicked = false;
            });
          },
          onDoubleTap: () async {
            setState(() {
              isLiked = true;
              isHeartAnimating = true;
            });
            if (widget.video_like_status == 'false') {
              await homepageController.PostLikeUnlikeApi(
                  context: context,
                  post_id: widget.video_id,
                  post_id_type: 'liked',
                  post_likeStatus: 'true');

              if (homepageController.postLikeUnlikeModel!.error == false) {
                print("mmmmm${widget.video_like_count}");
                setState(() {
                  widget.video_like_count =
                  homepageController.postLikeUnlikeModel!.user![0].likes!;

                  widget.video_like_status = homepageController
                      .postLikeUnlikeModel!.user![0].likeStatus!;
                });
                print("mmmmm${widget.video_like_count}");
              }
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  print('hello');
                  isClicked = isClicked ? false : true;
                  print(isClicked);
                },
                child: controller_last!.value.isInitialized
                    ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: controller_last!.value.aspectRatio,
                        child: VideoPlayer(controller_last!)),
                  ),
                )
                    : Container(),
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
                        onTap: () {
                          setState(() {
                            isClicked = true;
                            if (controller_last!.value.isPlaying) {
                              controller_last!.pause();
                            } else {
                              controller_last!.play();
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              controller_last!.value.isPlaying
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
                              margin: EdgeInsets.only(
                                  bottom: 0, right: 21, left: 20.0),
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      visualDensity:
                                      VisualDensity(vertical: -4),
                                      padding: EdgeInsets.only(left: 0.0),
                                      icon: Image.asset(
                                        AssetUtils.like_icon_filled,
                                        color: (widget.video_like_status ==
                                            'false'
                                            ? Colors.white
                                            : HexColor(CommonColor.pinkFont)),
                                        scale: 3,
                                      ),
                                      onPressed: () async {
                                        await homepageController
                                            .PostLikeUnlikeApi(
                                            context: context,
                                            post_id: widget.video_id,
                                            post_id_type:
                                            (widget.video_like_status ==
                                                "true"
                                                ? 'unliked'
                                                : 'liked'),
                                            post_likeStatus:
                                            (widget.video_like_status ==
                                                "true"
                                                ? 'false'
                                                : 'true'));

                                        if (homepageController
                                            .postLikeUnlikeModel!.error ==
                                            false) {
                                          print(
                                              "mmmmm${widget.video_like_count}");
                                          if (widget.video_like_status ==
                                              "false") {
                                            setState(() {
                                              widget.video_like_status =
                                              homepageController
                                                  .postLikeUnlikeModel!
                                                  .user![0]
                                                  .likeStatus!;

                                              widget.video_like_count =
                                              homepageController
                                                  .postLikeUnlikeModel!
                                                  .user![0]
                                                  .likes!;
                                            });
                                          } else {
                                            setState(() {
                                              widget.video_like_status =
                                              'false';

                                              widget.video_like_count =
                                              homepageController
                                                  .postLikeUnlikeModel!
                                                  .user![0]
                                                  .likes!;
                                            });
                                          }
                                          // setState(() {
                                          //   widget.video_like_count =
                                          //       homepageController
                                          //           .postLikeUnlikeModel!
                                          //           .user![0]
                                          //           .likes!;
                                          //
                                          //   widget.video_like_status =
                                          //       homepageController
                                          //           .postLikeUnlikeModel!
                                          //           .user![0]
                                          //           .likeStatus!;
                                          // });
                                          print(
                                              "mmmmm${widget.video_like_count}");
                                        }
                                      }),
                                  Container(
                                    child: Text(widget.video_like_count,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'PR')),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    visualDensity:
                                    VisualDensity(vertical: -4),
                                    iconSize: 30.0,
                                    padding: EdgeInsets.only(left: 0.0),
                                    icon: Image.asset(
                                      AssetUtils.comment_icon,
                                      color: HexColor('#8AFC8D'),
                                      scale: 3,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostImageCommentScreen(
                                                    PostID: widget.video_id,
                                                  )));
                                      // setState(() {
                                      //   // _myPage.jumpToPage(0);
                                      // });
                                    },
                                  ),
                                  Container(
                                    child: Text('${widget.comment_count}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'PR')),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    visualDensity:
                                    VisualDensity(vertical: -4),
                                    padding: EdgeInsets.only(left: 0.0),
                                    icon: Image.asset(
                                      AssetUtils.share_icon,
                                      color: HexColor('#66E4F2'),
                                      scale: 2,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // _myPage.jumpToPage(0);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    visualDensity:
                                    VisualDensity(vertical: -4),
                                    iconSize: 30.0,
                                    padding: EdgeInsets.only(left: 0.0),
                                    icon: Image.asset(
                                      AssetUtils.reward_icon,
                                      color: HexColor('#F32E82'),
                                      scale: 3,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // _myPage.jumpToPage(0);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    visualDensity:
                                    VisualDensity(vertical: -4),
                                    padding: EdgeInsets.only(left: 0.0),
                                    icon: Image.asset(
                                      AssetUtils.music_icon,
                                      color: HexColor('#F5C93A'),
                                      scale: 3,
                                    ),
                                    onPressed: () {
                                      setState(() {
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
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.red,
                              child: Image.network(
                                widget.image_url,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minWidth: 100, maxWidth: 220),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
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
                                    width:
                                    MediaQuery.of(context).size.width / 4,
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
                                        color: HexColor(CommonColor.pinkFont),
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
          ),
        ));
  }
}
