import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/profile_screen/story_view/story_edit.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/toaster_widget.dart';
import '../../custom_widget/common_buttons.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../search_screen/ViewStoryModel.dart';
import '../../sharePreference.dart';
import '../model/getStoryCountModel.dart';
import '../model/getStoryModel.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class StoryScreen extends StatefulWidget {
  final List<Storys> stories;
  final List<Data_story> stories_title;
  final String title;

  // final File thumbnail;
  int story_no;

  StoryScreen({
    required this.stories,
    required this.story_no,
    required this.stories_title,
    required this.title,
  });

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

    final Storys firstStory = widget.stories.first;
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
            // You can also
            // Navigator.of(context).pop();
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
    final Storys story = widget.stories[0];
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
                  height: MediaQuery.of(context).size.height / 1.1,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.stories.length,
                    itemBuilder: (context, i) {
                      final Storys story = widget.stories[i];
                      get_story_count(story_id: story.stID!);
                      if (story.isVideo == 'false') {
                        print(
                            "${URLConstants.base_data_url}images/${story.storyPhoto!}");
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Container(
                            // color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 90),
                            child: FadeInImage.assetNetwork(
                              image:
                                  "${URLConstants.base_data_url}images/${story.storyPhoto!}",
                              fit: BoxFit.contain,
                              placeholder: 'assets/images/Funky_App_Icon.png',
                            ),
                          ),
                        );
                      } else {
                        if (_videoController != null &&
                            _videoController!.value.isInitialized) {
                          return Container(
                            // color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            height: MediaQuery.of(context).size.height / 1.2,
                            child: Align(
                              alignment: Alignment.center,
                              child: AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!)),
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
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: (story.isVideo == 'true'
                                ? Image.asset(
                                    'assets/images/Funky_App_Icon.png')
                                // Image.file(
                                //         widget.thumbnail)
                                : FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    image:
                                        "${URLConstants.base_data_url}images/${story.storyPhoto!}",
                                    placeholder:
                                        'assets/images/Funky_App_Icon.png',
                                    // color: HexColor(CommonColor.pinkFont),
                                  )),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            '${widget.title}',
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
                          // '${story.viewCount}',
                          '0',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PM',
                              fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            print(story.stID!);
                            // share_icon(story_id: story.stID!);
                            pop_up(
                                story_id: story.stID!,
                                story_image:
                                    (story.storyPhoto!.isEmpty
                                        ? 'assets/images/Funky_App_Icon.png'
                                        : story.storyPhoto!),
                                story_title: widget
                                    .stories_title[widget.story_no].title!,
                                is_video: (story.storyPhoto!.isEmpty
                                    ? 'true'
                                    : 'false'));
                            // delete_story(story_id: story.stID!);
                          },
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

  void _onTapDown(TapDownDetails details,Storys story) {
    final double screenWidth = MediaQuery.of(context).size.width;
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
      if (story.storyPhoto!.isEmpty) {
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

  void _loadStory({required Storys story, bool animateToPage = true}) {
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
      print('imageeeeeeee');
      view_story(story_id: story.stID!);
      _animController!.duration = Duration(seconds: 10);
      _animController!.forward();
    } else {
      // _videoController = null;
      print('videooo');
      view_story(story_id: story.stID!);
      _videoController = VideoPlayerController.network(
          "${URLConstants.base_data_url}images/${story.storyPhoto!}")
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
      // if(story.isVideo == 'true'){
      //   _videoController!.dispose();
      // }
    }
  }

  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  '${storyCountModel!.data!.length}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PM',
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                        itemCount: storyCountModel!.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            visualDensity:
                                VisualDensity(vertical: -4, horizontal: -4),
                            leading: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: (storyCountModel!.data![index].user!
                                        .profileUrl!.isNotEmpty
                                    ? Image.network(storyCountModel!
                                        .data![index].user!.profileUrl!)
                                    : Image.network(
                                        '${URLConstants.base_data_url}images/${storyCountModel!.data![index].user!.image!}')),
                              ),
                            ),
                            title: Text(storyCountModel!.data![index].fullName!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'PR')),
                            subtitle: Text(
                                storyCountModel!.data![index].userName!,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'PR')),
                          );
                          //   Container(
                          //   child: Text(storyCountModel!.data![index].fullName!,
                          //       style: TextStyle(
                          //           fontSize: 16,
                          //           color: Colors.pink,
                          //           fontFamily: 'PR')),
                          // );
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
        ("${URLConstants.base_url}${URLConstants.StoryGetCountApi}?stoID=${story_id}");
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
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${storyCountModel!.data!.length}');
        // story_info = getStoryModel!.data!;

        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        isStoryCountLoading = false;
        return storyCountModel;
      } else {
        isStoryCountLoading = false;
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

  ViewStoryModel? viewStoryModel;

  Future<dynamic> view_story({required String story_id}) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    // isLikeLoading(true);

    Map data = {
      'stID': story_id,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.StoryViewApi);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      // isLikeLoading(false);
      var data = jsonDecode(response.body);
      viewStoryModel = ViewStoryModel.fromJson(data);
      print(viewStoryModel!.message);
      if (viewStoryModel!.error == false) {
        // CommonWidget().showToaster(msg: data["message"]);
        // feedlikeStatus = feedLikeUnlikeModel!.user![0].feedlikeStatus!;
        // feedlikeCount = feedLikeUnlikeModel!.user![0].feedLikeCount!;
        // await getAllNewsFeedList();
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Dashboard(page: 3,)));
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  Future<dynamic> delete_story({required String story_id}) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    // isLikeLoading(true);

    Map data = {
      'stID': story_id,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.StoryDeleteApi);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      // isLikeLoading(false);
      var data = jsonDecode(response.body);
      // feedLikeUnlikeModel = FeedLikeUnlikeModel.fromJson(data);
      print(data);
      if (data["error"] == false) {
        CommonWidget().showToaster(msg: data["message"]);
        // feedlikeStatus = feedLikeUnlikeModel!.user![0].feedlikeStatus!;
        // feedlikeCount = feedLikeUnlikeModel!.user![0].feedLikeCount!;
        // await getAllNewsFeedList();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(
                      page: 3,
                    )));
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  share_icon({required String story_id}) {
    _animController!.stop();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Story ?",
            style:
                TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'PM')),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: common_button(
              onTap: () {
                delete_story(story_id: story_id);
                // Get.toNamed(BindingUtils.signupOption);
              },
              backgroud_color: Colors.black,
              lable_text: 'Delete',
              lable_text_color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: common_button(
              onTap: () {
                Navigator.pop(context);
                _animController!.forward();
                // delete_story(story_id: story_id);
                // Get.toNamed(BindingUtils.signupOption);
              },
              backgroud_color: Colors.black,
              lable_text: 'Cancel',
              lable_text_color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future pop_up({
    required String story_id,
    required String story_image,
    required String story_title,
    required String is_video,
  }) {
    _animController!.stop();
    _videoController!.pause();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        elevation: 0.0,
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          height: MediaQuery.of(context).size.height / 5,
          // width: 133,
          // padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, 0.0),
                end: const Alignment(1.0, 0.0),
                transform: const GradientRotation(0.7853982),
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#000000"),
                  HexColor("#000000"),
                  HexColor("##E84F90"),
                  HexColor("#ffffff"),
                  // HexColor("#FFFFFF").withOpacity(0.67),
                ],
              ),
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(26.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      // mainAxisAlignment:
                      // MainAxisAlignment
                      //     .center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                delete_story(story_id: story_id);
                                // camera_upload();
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                delete_story(story_id: story_id);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                // height: 45,
                                // width:(width ?? 300) ,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PR',
                                          fontSize: 16),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.auto_fix_high_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                Get.to(StoryEdit(
                                  ImageFile: story_image,
                                  storyId: story_id,
                                  story_title: story_title,
                                  isvideo: is_video,
                                ));
                                // File editedFile = await Navigator.of(context)
                                //     .push(MaterialPageRoute(
                                //         builder: (context) => StoriesEditor(
                                //               // fontFamilyList: font_family,
                                //               giphyKey: '',
                                //               onDone: (String) {},
                                //               // filePath:
                                //               //     imgFile!.path,
                                //             )));
                                // if (editedFile != null) {
                                //   print('editedFile: ${editedFile.path}');
                                // }
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PR',
                                        fontSize: 16),
                                  )),
                            ),
                          ],
                        ),

                        // IconButton(
                        //   icon: const Icon(
                        //     Icons
                        //         .video_call,
                        //     size: 40,
                        //     color: Colors
                        //         .grey,
                        //   ),
                        //   onPressed:
                        //       () {
                        //         video_upload();
                        //       },
                        // ),
                      ],
                    ),
                  )

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      _animController!.forward();
      _videoController!.play();
    });
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

// class UserInfo extends StatelessWidget {
//   final User user;
//   final Data_story stories;
//
//   const UserInfo({
//     Key? key,
//     required this.user,
//     required this.stories,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: <Widget>[
//         CircleAvatar(
//           radius: 20.0,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: CachedNetworkImageProvider(
//             "${URLConstants.base_data_url}images/${stories.image!}",
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Expanded(
//           child: Text(
//             '${stories.title}',
//             style:
//                 TextStyle(color: Colors.white, fontFamily: 'PM', fontSize: 18),
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.remove_red_eye,
//             color: Colors.white,
//           ),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.close,
//             size: 30.0,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }
// }
