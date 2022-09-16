import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import 'discoverImageClass.dart';
import 'discoverVideoClass.dart';
import 'model/getDiscoverModel.dart';

class DiscoverFeedScreen extends StatefulWidget {
  final int index_;
  final GetDiscoverModel? getDiscoverModel;

  const DiscoverFeedScreen(
      {Key? key, this.getDiscoverModel, required this.index_})
      : super(key: key);

  @override
  State<DiscoverFeedScreen> createState() => _DiscoverFeedScreenState();
}

class _DiscoverFeedScreenState extends State<DiscoverFeedScreen> {
  ScrollController scrollController = ScrollController(
    initialScrollOffset: 10, // or whatever offset you wish
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Explore',
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: true,
          leadingWidth: 100,
        ),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.getDiscoverModel!.data!.length,
        // pageSnapping: false,
        allowImplicitScrolling: true,
        controller: PageController(
          initialPage: widget.index_,
          keepPage: true,
        ),
        itemBuilder: (BuildContext context, int index) {
          return (widget.getDiscoverModel!.data![index].postImage!.isNotEmpty
              ? DiscoverImageClass(
            Image_id: widget.getDiscoverModel!.data![index].iD!,
            play: true,
            imageName: widget.getDiscoverModel!
                .data![index].postImage!,
            imageUrl: widget.getDiscoverModel!
                .data![index].user!.image!,
            likeCount: widget.getDiscoverModel!
                .data![index].likes!,
            Fullname: widget.getDiscoverModel!
                .data![index].user!.fullName!,
            likestatus: widget.getDiscoverModel!
                .data![index].likeStatus!,
            ProfileUrl: widget.getDiscoverModel!
                .data![index].user!.profileUrl!,
            commentCount: widget.getDiscoverModel!
                .data![index].commentCount!,
            description: widget.getDiscoverModel!
                .data![index].description!,
          )
              : DiscoverVideoClass(
            Video_id: widget.getDiscoverModel!.data![index].iD!,
            play: true,
            videoUrl: widget.getDiscoverModel!
                .data![index].uploadVideo!,
            imageUrl: widget.getDiscoverModel!
                .data![index].user!.image!,
            likeCount: widget.getDiscoverModel!
                .data![index].likes!,
            Fullname: widget.getDiscoverModel!
                .data![index].user!.fullName!,
            likestatus: widget.getDiscoverModel!
                .data![index].likeStatus!,
            ProfileUrl: widget.getDiscoverModel!
                .data![index].user!.profileUrl!,
            commentCount: widget.getDiscoverModel!
                .data![index].commentCount!,
            description: widget.getDiscoverModel!
                .data![index].description!,
          ));
          //   Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     SizedBox(
          //       height: 10,
          //     ),
          //     Container(
          //       child: ListTile(
          //         visualDensity: VisualDensity(vertical: 0, horizontal: -4),
          //         dense: true,
          //         leading: Container(
          //           width: 50,
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(50),
          //             child: (widget.getDiscoverModel!.data![index].user!
          //                 .profileUrl!.isNotEmpty
          //                 ? Image.network(widget
          //                 .getDiscoverModel!.data![index].user!.profileUrl!)
          //             // FadeInImage.assetNetwork(
          //             //         height: 80,
          //             //         width: 80,
          //             //         fit: BoxFit.cover,
          //             //         placeholder:
          //             //             'assets/images/Funky_App_Icon.png',
          //             //         image: _search_screen_controller
          //             //             .searchlistModel!
          //             //             .data![index]
          //             //             .profileUrl!,
          //             //       )
          //                 :
          //             // Container(
          //             //   height: 50,
          //             //   width: 50,
          //             //   child: ClipRRect(
          //             //     borderRadius: BorderRadius.circular(50),
          //             //     child: Image.network(
          //             //       _search_screen_controller
          //             //           .searchlistModel!
          //             //           .data![index]
          //             //           .profileUrl!, fit: BoxFit.fill,),
          //             //   ),
          //             // )
          //             (widget.getDiscoverModel!.data![index].user!.image!
          //                 .isNotEmpty
          //                 ? FadeInImage.assetNetwork(
          //               height: 80,
          //               width: 80,
          //               fit: BoxFit.cover,
          //               image:
          //               "${URLConstants.base_data_url}images/${widget
          //                   .getDiscoverModel!.data![index].user!.image}",
          //               placeholder:
          //               'assets/images/Funky_App_Icon.png',
          //             )
          //                 : Container(
          //                 child: Image.asset(
          //                     'assets/images/Funky_App_Icon.png')))),
          //           ),
          //         ),
          //         //
          //         // Container(
          //         //     height: 50,
          //         //     decoration: BoxDecoration(
          //         //       borderRadius: BorderRadius.circular(50),
          //         //       color: Colors.white,
          //         //     ),
          //         //     child: ClipRRect(
          //         //       borderRadius: BorderRadius.circular(50),
          //         //       child: IconButton(
          //         //         onPressed: () {},
          //         //         icon: Image.asset(
          //         //           AssetUtils.image1,
          //         //           fit: BoxFit.fill,
          //         //         ),
          //         //       ),
          //         //     )),
          //         title: Text(
          //           widget.getDiscoverModel!.data![index].user!.fullName!,
          //           style: TextStyle(
          //               color: Colors.white, fontSize: 14, fontFamily: 'PB'),
          //         ),
          //         // trailing: IconButton(
          //         //   icon: Icon(
          //         //     Icons.more_vert,
          //         //     color: Colors.white,
          //         //     size: 20,
          //         //   ),
          //         //   onPressed: () {},
          //         // ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     (widget.getDiscoverModel!.data![index].postImage!.isNotEmpty
          //         ? GestureDetector(
          //       // onDoubleTap: () async {
          //       //   setState(() {
          //       //     isLiked = true;
          //       //     isHeartAnimating = true;
          //       //   });
          //       //   await news_feed_controller.FeedLikeUnlikeApi(
          //       //       context: context,
          //       //       news_post_feedlikeStatus: 'true',
          //       //       news_post_id_type: 'liked',
          //       //       news_post_id: news_feed_controller
          //       //           .newsfeedModel!.data![index].newsID!);
          //       //
          //       //   if (news_feed_controller
          //       //           .feedLikeUnlikeModel!.error ==
          //       //       false) {
          //       //     print(
          //       //         "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //       //
          //       //     setState(() {
          //       //       news_feed_controller.newsfeedModel!
          //       //               .data![index].feedLikeCount =
          //       //           news_feed_controller
          //       //               .feedLikeUnlikeModel!
          //       //               .user![0]
          //       //               .feedLikeCount;
          //       //
          //       //       news_feed_controller.newsfeedModel!
          //       //               .data![index].feedlikeStatus =
          //       //           news_feed_controller
          //       //               .feedLikeUnlikeModel!
          //       //               .user![0]
          //       //               .feedlikeStatus!;
          //       //     });
          //       //
          //       //     print(
          //       //         "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //       //   }
          //       //   // setState(() {
          //       //   //   liked = true;
          //       //   // });
          //       // },
          //       child: AspectRatio(
          //         aspectRatio: 5 / 5,
          //         child: Container(
          //           color: Colors.black,
          //           child: FadeInImage.assetNetwork(
          //             fit: BoxFit.contain,
          //             image:
          //             "${URLConstants.base_data_url}images/${widget
          //                 .getDiscoverModel!.data![index].postImage}",
          //             placeholder:
          //             'assets/images/Funky_App_Icon.png',
          //           ),
          //         ),
          //       ),
          //     )
          //         : (widget.getDiscoverModel!.data![index].uploadVideo!
          //         .isNotEmpty
          //         ? GestureDetector(
          //       // onDoubleTap: () async {
          //       //   setState(() {
          //       //     isLiked = true;
          //       //     isHeartAnimating = true;
          //       //   });
          //       //   await news_feed_controller.FeedLikeUnlikeApi(
          //       //       context: context,
          //       //       news_post_feedlikeStatus: 'true',
          //       //       news_post_id_type: 'liked',
          //       //       news_post_id: news_feed_controller
          //       //           .newsfeedModel!.data![index].newsID!);
          //       //
          //       //   if (news_feed_controller
          //       //           .feedLikeUnlikeModel!.error ==
          //       //       false) {
          //       //     print(
          //       //         "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //       //
          //       //     setState(() {
          //       //       news_feed_controller.newsfeedModel!
          //       //               .data![index].feedLikeCount =
          //       //           news_feed_controller
          //       //               .feedLikeUnlikeModel!
          //       //               .user![0]
          //       //               .feedLikeCount;
          //       //
          //       //       news_feed_controller.newsfeedModel!
          //       //               .data![index].feedlikeStatus =
          //       //           news_feed_controller
          //       //               .feedLikeUnlikeModel!
          //       //               .user![0]
          //       //               .feedlikeStatus!;
          //       //     });
          //       //
          //       //     print(
          //       //         "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //       //   }
          //       //   // setState(() {
          //       //   //   liked = true;
          //       //   // });
          //       // },
          //       child: AspectRatio(
          //         aspectRatio: 5 / 5,
          //         child: Container(
          //           color: Colors.white,
          //           child:
          //           DiscoverVideoClass(
          //             play: true,
          //             videoUrl: widget.getDiscoverModel!
          //                 .data![index].uploadVideo!,
          //             imageUrl:  widget.getDiscoverModel!
          //                 .data![index].user!.image!,
          //             likeCount: widget.getDiscoverModel!
          //                 .data![index].likes!,
          //             Fullname: widget.getDiscoverModel!
          //                 .data![index].user!.fullName!,
          //             likestatus: widget.getDiscoverModel!
          //                 .data![index].likeStatus!,
          //             ProfileUrl: widget.getDiscoverModel!
          //                 .data![index].user!.profileUrl!,
          //             commentCount: widget.getDiscoverModel!
          //                 .data![index].commentCount!,
          //             description: widget.getDiscoverModel!
          //                 .data![index].description!,
          //           ),
          //         ),
          //       ),
          //     )
          //         : GestureDetector(
          //       // onDoubleTap: () async {
          //       //   setState(() {
          //       //     isLiked = true;
          //       //     isHeartAnimating = true;
          //       //   });
          //       //   await news_feed_controller.FeedLikeUnlikeApi(
          //       //       context: context,
          //       //       news_post_feedlikeStatus: 'true',
          //       //       news_post_id_type: 'liked',
          //       //       news_post_id: news_feed_controller
          //       //           .newsfeedModel!.data![index].newsID!);
          //       //
          //       //   if (news_feed_controller
          //       //           .feedLikeUnlikeModel!.error ==
          //       //       false) {
          //       //     print(
          //       //         "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //       //
          //       //     setState(() {
          //       //       news_feed_controller.newsfeedModel!
          //       //               .data![index].feedLikeCount =
          //       //           news_feed_controller
          //       //               .feedLikeUnlikeModel!
          //       //               .user![0]
          //       //               .feedLikeCount;
          //       //
          //       //       news_feed_controller.newsfeedModel!
          //       //               .data![index].feedlikeStatus =
          //       //           news_feed_controller
          //       //               .feedLikeUnlikeModel!
          //       //               .user![0]
          //       //               .feedlikeStatus!;
          //       //     });
          //       //
          //       //     print(
          //       //         "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //       //   }
          //       //   // setState(() {
          //       //   //   liked = true;
          //       //   // });
          //       // },
          //       child: AspectRatio(
          //         aspectRatio: 5 / 5,
          //         child: Container(
          //           color: Colors.black,
          //           child:
          //           Stack(alignment: Alignment.center, children: [
          //             Center(
          //                 child: GestureDetector(
          //                   // onTap: _playPause,
          //                     child: Icon(
          //                       Icons.play_circle,
          //                       color: Colors.white,
          //                       size: 50,
          //                     )))
          //             // Opacity(
          //             //   opacity: isHeartAnimating ? 1 : 0,
          //             //   child: HeartAnimationWidget(
          //             //     isAnimating: isHeartAnimating,
          //             //     duration: Duration(milliseconds: 900),
          //             //     onEnd: () {
          //             //       setState(() {
          //             //         isHeartAnimating = false;
          //             //       });
          //             //     },
          //             //     child: Icon(
          //             //       Icons.favorite,
          //             //       color:
          //             //           HexColor(CommonColor.pinkFont),
          //             //       size: 100,
          //             //     ),
          //             //   ),
          //             // )
          //           ]),
          //         ),
          //       ),
          //     ))),
          //     Container(
          //       margin: EdgeInsets.only(left: 16, top: 13),
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         widget.getDiscoverModel!.data![index].description!,
          //         style: TextStyle(
          //             color: Colors.white, fontSize: 16, fontFamily: 'PR'),
          //       ),
          //     ),
          //     Container(
          //       child: Row(
          //         children: [
          //           IconButton(
          //               padding: EdgeInsets.only(left: 5.0),
          //               icon: Icon(
          //                 Icons.message,
          //                 color: Colors.white,
          //               ),
          //               onPressed: () {
          //                 // Navigator.push(
          //                 //     context,
          //                 //     MaterialPageRoute(
          //                 //         builder: (context) =>
          //                 //             NewsFeedCommantScreen(
          //                 //               newsID:
          //                 //                   news_feed_controller
          //                 //                       .newsfeedModel!
          //                 //                       .data![index]
          //                 //                       .newsID!,
          //                 //             )));
          //               }),
          //           Text(
          //             widget.getDiscoverModel!.data![index].commentCount!,
          //             style: TextStyle(
          //                 color: Colors.white, fontSize: 12, fontFamily: 'PR'),
          //           ),
          //           IconButton(
          //               padding: EdgeInsets.only(left: 5.0),
          //               icon: Image.asset(
          //                 AssetUtils.like_icon_filled,
          //                 color: (widget.getDiscoverModel!.data![index]
          //                     .likeStatus ==
          //                     'false'
          //                     ? Colors.white
          //                     : HexColor(CommonColor.pinkFont)),
          //                 height: 20,
          //                 width: 20,
          //               ),
          //               onPressed: () async {
          //                 // await news_feed_controller.FeedLikeUnlikeApi(
          //                 //     context: context,
          //                 //     news_post_feedlikeStatus:
          //                 //         (news_feed_controller
          //                 //                     .newsfeedModel!
          //                 //                     .data![index]
          //                 //                     .feedlikeStatus! ==
          //                 //                 "true"
          //                 //             ? 'false'
          //                 //             : 'true'),
          //                 //     news_post_id_type:
          //                 //         (news_feed_controller
          //                 //                     .newsfeedModel!
          //                 //                     .data![index]
          //                 //                     .feedlikeStatus! ==
          //                 //                 "true"
          //                 //             ? 'unliked'
          //                 //             : 'liked'),
          //                 //     news_post_id: news_feed_controller
          //                 //         .newsfeedModel!
          //                 //         .data![index]
          //                 //         .newsID!);
          //                 //
          //                 // if (news_feed_controller
          //                 //         .feedLikeUnlikeModel!.error ==
          //                 //     false) {
          //                 //   // if (news_feed_controller
          //                 //   //         .feedLikeUnlikeModel!
          //                 //   //         .user![0]
          //                 //   //         .feedlikeStatus ==
          //                 //   //     'false') {
          //                 //   //   setState(() {
          //                 //   //     liked = false;
          //                 //   //   });
          //                 //   // } else {
          //                 //   //   setState(() {
          //                 //   //     liked = true;
          //                 //   //   });
          //                 //   // }
          //                 //
          //                 //   print(
          //                 //       "vvvv${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //                 //
          //                 //   setState(() {
          //                 //     news_feed_controller
          //                 //             .newsfeedModel!
          //                 //             .data![index]
          //                 //             .feedLikeCount =
          //                 //         news_feed_controller
          //                 //             .feedLikeUnlikeModel!
          //                 //             .user![0]
          //                 //             .feedLikeCount;
          //                 //
          //                 //     news_feed_controller
          //                 //             .newsfeedModel!
          //                 //             .data![index]
          //                 //             .feedlikeStatus =
          //                 //         news_feed_controller
          //                 //             .feedLikeUnlikeModel!
          //                 //             .user![0]
          //                 //             .feedlikeStatus!;
          //                 //   });
          //                 //
          //                 //   print(
          //                 //       "mmmm${news_feed_controller.newsfeedModel!.data![index].feedLikeCount}");
          //                 // }
          //               }),
          //           Text(
          //             widget.getDiscoverModel!.data![index].likes!,
          //             style: TextStyle(
          //                 color: Colors.white, fontSize: 12, fontFamily: 'PR'),
          //           ),
          //           IconButton(
          //               padding: EdgeInsets.only(left: 5.0),
          //               icon: Image.asset(
          //                 AssetUtils.share_icon2,
          //                 color: Colors.white,
          //                 height: 20,
          //                 width: 20,
          //               ),
          //               onPressed: () {
          //                 _onShare(
          //                     context: context,
          //                     link:
          //                     "${URLConstants.base_data_url}images/${widget
          //                         .getDiscoverModel!.data![index].postImage}");
          //               }),
          //         ],
          //       ),
          //     ),
          //     SizedBox(
          //       height: 10,
          //     )
          //   ],
          // );
        },
      ),
    );
  }

  void _onShare({required BuildContext context, required String link}) async {
    Share.share(link, subject: 'Share App');
  }
}
