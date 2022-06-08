import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/homepage/controller/homepage_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/custom_appbar.dart';
import '../../drawerScreen.dart';
import '../controller/homepage_controller.dart';
import 'better_video.dart';
import 'common_video_class.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key,}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
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
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        drawer: DrawerScreen(),
        appBar: CustomAppbar(
          lable_tex: 'Dashboard',
          ondrawertap:(){
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        body: Obx(() => (homepageController.isVideoLoading != true &&
                homepageController.videoListModel != null)
            ? Center(
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homepageController.videoListModel!.data!.length,
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
                        url: homepageController
                            .videoListModel!.data![index].uploadVideo!,
                        play: true,
                        songName: homepageController
                            .videoListModel!.data![index].musicName!,
                              image_url : (homepageController
                                  .videoListModel!.data![index].user!.profileUrl ==
                                  null
                                  ? ''
                                  : homepageController
                                  .videoListModel!.data![index].user!.profileUrl!),
                        singerName: (homepageController
                                    .videoListModel!.data![index].userName ==
                                null
                            ? ''
                            : homepageController
                                .videoListModel!.data![index].userName!),
                      );
                    }),
              )
            : Center(
                child: Container(
                  child: Text('plaese wait'),
                ),
              )));
  }
}
