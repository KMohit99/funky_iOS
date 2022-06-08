import 'dart:async';

import 'package:flutter/material.dart';
import 'package:funky_new/guest_screen/ui/video_class.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../homepage/controller/homepage_controller.dart';
import '../../homepage/ui/common_video_class.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  final HomepageController homepageController =
  Get.put(HomepageController(), tag: HomepageController().toString());
  VideoPlayerController? _controller;

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
    _controller!.dispose();
    _timer?.cancel();
    super.dispose();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            body: Obx(() => (homepageController.isVideoLoading != true)
                ? Center(
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                  homepageController.videoListModel!.data!.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return video_class(
                      url: homepageController
                          .videoListModel!.data![index].user!.profileUrl !,
                      play: true,
                      songName: homepageController
                          .videoListModel!.data![index].musicName!,
                      singerName: homepageController
                          .videoListModel!.data![index].userName!,
                    );
                  }),
            )
                : Center(
              child: Container(
                child: Text('plaese wait'),
              ),
            )))
      ],
    );
  }
}
