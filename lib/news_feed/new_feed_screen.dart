import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
// import 'package:funky_project/news_feed/news_feed_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_appbar.dart';
import '../Utils/custom_textfeild.dart';
import '../drawerScreen.dart';
import 'news_feed_controller.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final news_feed_controller = new NewsFeed_screen_controller();

  @override
  void initState() {
    news_feed_controller.getAllNewsFeedList();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      drawer: DrawerScreen(),
      appBar: CustomAppbar(
        lable_tex: 'News Feed',
        ondrawertap:(){
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 100,
        ),
        child: Center(child: Text('No Posts Yet',style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'PR')),)

        // Obx(() => news_feed_controller.isVideoLoading.value != true
        //     ? ListView.builder(
        //         padding: EdgeInsets.only(bottom: 50),
        //         shrinkWrap: true,
        //         itemCount: news_feed_controller.newsfeedModel!.data!.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return Column(
        //             children: [
        //               Container(
        //                 child: ListTile(
        //                   visualDensity:
        //                       VisualDensity(vertical: 0, horizontal: -4),
        //                   dense: true,
        //                   leading: Container(
        //                     width: 50,
        //                     child: CircleAvatar(
        //                       radius: 48, // Image radius
        //                       backgroundImage: NetworkImage(
        //                         "http://foxyserver.com/funky/images/${news_feed_controller.newsfeedModel!.data![index].image}",
        //                       ),
        //                     ),
        //                   ),
        //                   //
        //                   // Container(
        //                   //     height: 50,
        //                   //     decoration: BoxDecoration(
        //                   //       borderRadius: BorderRadius.circular(50),
        //                   //       color: Colors.white,
        //                   //     ),
        //                   //     child: ClipRRect(
        //                   //       borderRadius: BorderRadius.circular(50),
        //                   //       child: IconButton(
        //                   //         onPressed: () {},
        //                   //         icon: Image.asset(
        //                   //           AssetUtils.image1,
        //                   //           fit: BoxFit.fill,
        //                   //         ),
        //                   //       ),
        //                   //     )),
        //                   title: Text(
        //                     news_feed_controller
        //                         .newsfeedModel!.data![index].fullName!,
        //                     style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: 16,
        //                         fontFamily: 'PR'),
        //                   ),
        //                   trailing: IconButton(
        //                     icon: Icon(
        //                       Icons.more_vert,
        //                       color: Colors.white,
        //                       size: 20,
        //                     ),
        //                     onPressed: () {},
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 10,
        //               ),
        //               Stack(
        //                 children: [
        //                   Container(
        //                     color: Colors.white,
        //                     width: MediaQuery.of(context).size.width,
        //                     height: MediaQuery.of(context).size.height,
        //                     child:
        //
        //                     Image.network(
        //                       "http://foxyserver.com/funky/images/${news_feed_controller.newsfeedModel!.data![index].postImage}",
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                   Positioned.fill(
        //                     child: Align(
        //                       alignment: Alignment.bottomRight,
        //                       child: Container(
        //                         width: 100,
        //                         height: 38,
        //                         decoration: BoxDecoration(
        //                             color: HexColor(CommonColor.pinkFont),
        //                             borderRadius: BorderRadius.only(
        //                               topLeft: Radius.circular(13),
        //                               bottomLeft: Radius.circular(13),
        //                             )),
        //                         child: Container(
        //                           alignment: Alignment.center,
        //                           child: Text(
        //                             'I am here',
        //                             style: TextStyle(
        //                                 color: Colors.white,
        //                                 fontSize: 16,
        //                                 fontFamily: 'PR'),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //               Container(
        //                 margin: EdgeInsets.only(left: 16, top: 13),
        //                 alignment: Alignment.centerLeft,
        //                 child: Text(
        //                   news_feed_controller.newsfeedModel!.data![index].description!,
        //                   style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16,
        //                       fontFamily: 'PR'),
        //                 ),
        //               ),
        //               Container(
        //                 child: Row(
        //                   children: [
        //                     IconButton(
        //                         padding: EdgeInsets.only(left: 5.0),
        //                         icon: Image.asset(
        //                           AssetUtils.comment_icon,
        //                           color: Colors.white,
        //                           height: 20,
        //                           width: 20,
        //                         ),
        //                         onPressed: () {}),
        //                     Text(
        //                       news_feed_controller
        //                           .newsfeedModel!.data![index].commentCount!,
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                           fontFamily: 'PR'),
        //                     ),
        //                     IconButton(
        //                         padding: EdgeInsets.only(left: 5.0),
        //                         icon: Image.asset(
        //                           AssetUtils.like_icon_filled,
        //                           color: HexColor(CommonColor.pinkFont),
        //                           height: 20,
        //                           width: 20,
        //                         ),
        //                         onPressed: () {}),
        //                     Text(
        //                       news_feed_controller
        //                           .newsfeedModel!.data![index].likes!,
        //                       style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                           fontFamily: 'PR'),
        //                     ),
        //                     IconButton(
        //                         padding: EdgeInsets.only(left: 5.0),
        //                         icon: Image.asset(
        //                           AssetUtils.share_icon2,
        //                           color: Colors.white,
        //                           height: 20,
        //                           width: 20,
        //                         ),
        //                         onPressed: () {}),
        //                   ],
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 10,
        //               )
        //             ],
        //           );
        //         },
        //       )
        //     : Container()),
      ),
    );
  }
}
