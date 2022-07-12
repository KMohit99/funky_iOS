import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../sharePreference.dart';
import '../model/getStoryCountModel.dart';
import '../model/getStoryModel.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class StoryScreen extends StatefulWidget {
  final List<Data_story> stories;
  int story_no;

  StoryScreen({required this.stories, required this.story_no});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  AnimationController? _animController;
  VideoPlayerController? _videoController;

  // int  widget.story_no = widget.story_no;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    final Data_story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController!.stop();
        _animController!.reset();
        setState(() {
          if (widget.story_no + 1 < widget.stories.length) {
            widget.story_no += 1;
            _loadStory(story: widget.stories[widget.story_no]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            widget.story_no = 0;
            _loadStory(story: widget.stories[widget.story_no]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _animController!.dispose();
    _videoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Data_story story = widget.stories[widget.story_no];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  // color: Colors.green,
                  alignment: Alignment.center,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.1,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.stories.length,
                    itemBuilder: (context, i) {
                      final Data_story story = widget.stories[widget.story_no];
                      get_story_count(story_id: story.stID!);
                      if (story.isVideo == 'false') {
                        print(
                            "http://foxyserver.com/funky/images/${story
                                .storyPhoto!}");
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Container(
                            // color: Colors.white,
                            child: FadeInImage.assetNetwork(
                              image:
                              "http://foxyserver.com/funky/images/${story
                                  .storyPhoto!}",
                              fit: BoxFit.contain,
                              placeholder: 'assets/images/Funky_App_Icon.png',
                            ),
                          ),
                        );
                      } else {
                        if (_videoController != null &&
                            _videoController!.value.isInitialized) {
                          return FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController!.value.size.width,
                              height: _videoController!.value.size.height,
                              child: VideoPlayer(_videoController!),
                            ),
                          );
                        }
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: widget.stories
                        .asMap()
                        .map((i, e) {
                      return MapEntry(
                        i,
                        AnimatedBar(
                          animController: _animController!,
                          position: i,
                          currentIndex: widget.story_no,
                        ),
                      );
                    })
                        .values
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: CachedNetworkImageProvider(
                            "http://foxyserver.com/funky/images/${story
                                .storyPhoto!}",
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            '${story.title}',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PM',
                                fontSize: 18),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _animController!.stop();
                            selectTowerBottomSheet(context);
                          },
                        ),
                        Text(
                          '${story.viewCount}',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PM',
                              fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Data_story story) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (widget.story_no - 1 >= 0) {
          widget.story_no -= 1;
          _loadStory(story: widget.stories[widget.story_no]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (widget.story_no + 1 < widget.stories.length) {
          widget.story_no += 1;
          _loadStory(story: widget.stories[widget.story_no]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          widget.story_no = 0;
          _loadStory(story: widget.stories[widget.story_no]);
        }
      });
    } else {
      if (story.isVideo == 'true') {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _animController!.stop();
        } else {
          _videoController!.play();
          _animController!.forward();
        }
      }
    }
  }

  void _loadStory({required Data_story story, bool animateToPage = true}) {
    _animController!.stop();
    _animController!.reset();
    // switch (story.media) {
    //   case MediaType.image:
    //     _animController.duration = story.duration;
    //     _animController.forward();
    //     break;
    //   case MediaType.video:
    //     _videoController = null;
    //     _videoController?.dispose();
    //     _videoController = VideoPlayerController.network(story.url)
    //       ..initialize().then((_) {
    //         setState(() {});
    //         if (_videoController.value.initialized) {
    //           _animController.duration = _videoController.value.duration;
    //           _videoController.play();
    //           _animController.forward();
    //         }
    //       });
    //     break;
    // }
    if (story.isVideo == 'false') {
      _animController!.duration = Duration(seconds: 10);
      _animController!.forward();
    } else {
      _videoController = null;
      _videoController!.dispose();
      _videoController = VideoPlayerController.network(story.uploadVideo!)
        ..initialize().then((_) {
          setState(() {});
          if (_videoController!.value.isInitialized) {
            _animController!.duration = _videoController!.value.duration;
            _videoController!.play();
            _animController!.forward();
          }
        });
    }
    if (animateToPage) {
      _pageController!.animateToPage(
        widget.story_no,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery
        .of(context)
        .size
        .height;
    final screenwidth = MediaQuery
        .of(context)
        .size
        .width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                _animController!.forward();
                Navigator.pop(context);
              },
              child: Container(
                height: screenheight * 0.8,
                width: screenwidth,
                decoration: BoxDecoration(
                  // color: Colors.black.withOpacity(0.65),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#C12265").withOpacity(0.67),
                      HexColor("#000000").withOpacity(0.67),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#04060F'),
                      offset: Offset(10, 10),
                      blurRadius: 20,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(33.9),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        child: Text('Select media',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.pink,
                                fontFamily: 'PR')),
                      ),
                      ListView.builder(
                        itemCount: storyCountModel!.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Text(storyCountModel!.data![index].fullName!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.pink,
                                    fontFamily: 'PR')),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  StoryCountModel? storyCountModel;
  bool isStoryCountLoading = true;

  Future<dynamic> get_story_count({required String story_id}) async {
    print('Inside creator get email');
    isStoryCountLoading = true;
    String url =
    ("${URLConstants.base_url}${URLConstants
        .StoryGetCountApi}?stoID=${story_id}");
    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      storyCountModel = StoryCountModel.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      if (storyCountModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${storyCountModel!
                .data!.length}');
        // story_info = getStoryModel!.data!;

        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        isStoryCountLoading = false;
        return storyCountModel;
      } else {
        setState(() {
          isStoryCountLoading = false;
        });
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key? key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? HexColor(CommonColor.pinkFont)
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) {
                    return _buildContainer(
                      constraints.maxWidth * animController.value,
                      HexColor(CommonColor.pinkFont),
                    );
                  },
                )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 3.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final User user;
  final Data_story stories;

  const UserInfo({
    Key? key,
    required this.user,
    required this.stories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            "http://foxyserver.com/funky/images/${stories.storyPhoto!}",
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            '${stories.title}',
            style:
            TextStyle(color: Colors.white, fontFamily: 'PM', fontSize: 18),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
