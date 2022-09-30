import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/profile_screen/story_view/storyView.dart';
import 'package:funky_new/profile_screen/video_viewer.dart';
import 'package:funky_new/profile_screen/story_view/view_selected_image.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';

// import 'package:funky_project/Authentication/creator_login/model/creator_loginModel.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/profile_screen/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import 'package:http/http.dart' as http;

import '../Utils/toaster_widget.dart';
import '../custom_widget/common_buttons.dart';

// import '../header_model.dart';
import '../dashboard/post_screen.dart';
import '../dashboard/story_/src/presentation/widgets/animated_onTap_button.dart';
import '../dashboard/story_/stories_editor.dart';
import '../dashboard/story_/story_image_preview.dart';
import '../sharePreference.dart';
import '../video_recorder/lib/main.dart';
import 'edit_profile_screen.dart';
import 'followers_screen.dart';
// import 'following_screen.dart';
import 'following_screen.dart';
import 'model/galleryModel.dart';
import 'model/getStoryModel.dart';
import 'model/videoModelList.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen>
    with SingleTickerProviderStateMixin {
  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  @override
  void initState() {
    init();
    // print(
    //     "SOcial type------------ ${_creator_login_screen_controller.userInfoModel_email!.data![0].socialType}");
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  init() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String social_type_user =
        await PreferenceManager().getPref(URLConstants.social_type);
    print("id----- $id_user");
    print("id----- $social_type_user");
    (social_type_user == ""
        ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
            UserId: id_user)
        : await _creator_login_screen_controller.getUserInfo_social());
    await get_story_list(index: 0);
    await get_video_list(context);

    await get_gallery_list(context);
  }

  int index = 0;

  List Story_img = [
    AssetUtils.story_image1,
    AssetUtils.story_image2,
    AssetUtils.story_image3,
    AssetUtils.story_image4,
  ];
  List image_list = [
    AssetUtils.image1,
    AssetUtils.image2,
    AssetUtils.image3,
    AssetUtils.image4,
    AssetUtils.image5,
  ];
  TabController? _tabController;
  List<Tab> _tabs = [
    Tab(
      iconMargin: EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 40),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.blue),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            border: Border.all(color: HexColor(CommonColor.blue), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story1,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.blue),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.green),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            border: Border.all(color: HexColor(CommonColor.green), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story2,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.green),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.tile),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: HexColor(CommonColor.tile), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story3,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.tile),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor(CommonColor.orange),
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border:
                Border.all(color: HexColor(CommonColor.orange), width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story4,
            height: 25,
            width: 25,
            color: HexColor(CommonColor.orange),
          ),
        ),
      ),
    ),
    Tab(
      iconMargin: EdgeInsets.all(5),
      height: 75,
      icon: Container(
        // margin: EdgeInsets.only(top: 20),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                // spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000"),
                HexColor("#C12265"),
                // HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width: 1.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetUtils.story5,
            height: 25,
            width: 25,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: Text(
        //     'My Profile',
        //     style: TextStyle(
        //       fontSize: 16,
        //     ),
        //   ),
        //   centerTitle: true,
        //   actions: [
        //     Container(
        //       margin: EdgeInsets.only(right: 20),
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.more_vert,
        //           color: Colors.white,
        //           size: 25,
        //         ),
        //         onPressed: () {},
        //       ),
        //     ),
        //   ],
        //   leadingWidth: 100,
        //   leading: Container(
        //     margin: EdgeInsets.only(left: 18, top: 0, bottom: 0),
        //     child: IconButton(
        //         padding: EdgeInsets.zero,
        //         onPressed: () {},
        //         icon: (Image.asset(
        //           AssetUtils.story5,
        //           color: HexColor(CommonColor.pinkFont),
        //           height: 20.0,
        //           width: 20.0,
        //           fit: BoxFit.contain,
        //         ))),
        //   ),
        // ),
        body: Obx(() => (_creator_login_screen_controller
                    .isuserinfoLoading.value ==
                true
            ? Center(
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
              )
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        backgroundColor: Colors.black,
                        automaticallyImplyLeading: false,
                        expandedHeight: 400.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            centerTitle: true,
                            background: Container(
                              margin: EdgeInsets.only(
                                top: 32,
                              ),
                              child: Column(
                                children: [
                                  // Expanded(
                                  //   child: Align(
                                  //     alignment: Alignment.bottomCenter,
                                  //     child: Column(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: <Widget>[
                                  //         Text('NEW GAME'),
                                  //         Text('Sekiro: Shadows Dies Twice'),
                                  //         RaisedButton(
                                  //           onPressed: () {},
                                  //           child: Text('Play'),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 16, left: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              // color: Colors.white,
                                              ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${_creator_login_screen_controller.userInfoModel_email!.data![0].fullName}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily: 'PB'),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.only(right: 0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    double width =
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width;
                                                    double height =
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height;
                                                    return BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 10,
                                                          sigmaY: 10),
                                                      child: AlertDialog(
                                                          insetPadding:
                                                              EdgeInsets.only(
                                                                  bottom: 500,
                                                                  left: 100),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          elevation: 0.0,
                                                          // title: Center(child: Text("Evaluation our APP")),
                                                          content: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                // height: 122,
                                                                width: 150,
                                                                height: 120,
                                                                // padding: const EdgeInsets.all(8.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          begin: Alignment(
                                                                              -1.0,
                                                                              0.0),
                                                                          end: Alignment(
                                                                              1.0,
                                                                              0.0),
                                                                          transform:
                                                                              GradientRotation(0.7853982),
                                                                          // stops: [0.1, 0.5, 0.7, 0.9],
                                                                          colors: [
                                                                            HexColor("#000000"),
                                                                            HexColor("#000000"),
                                                                            HexColor("##E84F90"),
                                                                            // HexColor("#ffffff"),
                                                                            // HexColor("#FFFFFF").withOpacity(0.67),
                                                                          ],
                                                                        ),
                                                                        color: Colors
                                                                            .white,
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .white,
                                                                            width:
                                                                                1),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(26.0))),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          5),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          'Report',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontFamily: 'PR',
                                                                              color: Colors.white),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 20),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                Colors.black,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Block',
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontFamily: 'PR',
                                                                              color: Colors.white),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 20),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                Colors.black,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Remove follower',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontFamily: 'PR',
                                                                              color: Colors.white),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 20),
                                                                          child:
                                                                              Divider(
                                                                            color:
                                                                                Colors.black,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          'Share Profile ',
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontFamily: 'PR',
                                                                              color: Colors.white),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 16, left: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // color: Colors.white,
                                          height: 80,
                                          width: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child:
                                                (_creator_login_screen_controller
                                                        .userInfoModel_email!
                                                        .data![0]
                                                        .image!
                                                        .isNotEmpty
                                                    ? Image.network(
                                                        '${URLConstants.base_data_url}images/${_creator_login_screen_controller.userInfoModel_email!.data![0].image!}',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        AssetUtils.image1)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      (_creator_login_screen_controller
                                                              .userInfoModel_email!
                                                              .data![0]
                                                              .fullName!
                                                              .isNotEmpty
                                                          ? '${_creator_login_screen_controller.userInfoModel_email!.data![0].fullName}'
                                                          : 'Please update profile'),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: HexColor(
                                                              CommonColor
                                                                  .pinkFont)),
                                                    ),
                                                    IconButton(
                                                        visualDensity:
                                                            VisualDensity(
                                                                vertical: -4),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.grey,
                                                          size: 15,
                                                        ),
                                                        onPressed: () {
                                                          Get.to(
                                                              const EditProfileScreen());
                                                        }),
                                                  ],
                                                ),
                                                Text(
                                                  (_creator_login_screen_controller
                                                          .userInfoModel_email!
                                                          .data![0]
                                                          .about!
                                                          .isNotEmpty
                                                      ? '${_creator_login_screen_controller.userInfoModel_email!.data![0].about}'
                                                      : ' '),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: HexColor(
                                                          CommonColor
                                                              .subHeaderColor)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    visualDensity:
                                                        VisualDensity(
                                                            vertical: -4),
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    icon: Image.asset(
                                                      AssetUtils
                                                          .like_icon_filled,
                                                      color: HexColor(
                                                          CommonColor.pinkFont),
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    onPressed: () {}),
                                                Text(
                                                  '${_creator_login_screen_controller.userInfoModel_email!.data![0].followerNumber}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'PR'),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    visualDensity:
                                                        VisualDensity(
                                                            vertical: -4),
                                                    icon: Image.asset(
                                                      AssetUtils.profile_filled,
                                                      color: HexColor(
                                                          CommonColor.pinkFont),
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    onPressed: () {
                                                      Get.to(FollowersList());
                                                    }),
                                                Text(
                                                  '${_creator_login_screen_controller.userInfoModel_email!.data![0].followerNumber}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'PR'),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    visualDensity:
                                                        VisualDensity(
                                                            vertical: -4),
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    icon: Image.asset(
                                                      AssetUtils
                                                          .following_filled,
                                                      color: HexColor(
                                                          CommonColor.pinkFont),
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  FollowingScreen(
                                                                    user_id: _creator_login_screen_controller
                                                                        .userInfoModel_email!
                                                                        .data![
                                                                            0]
                                                                        .id!,
                                                                  ))).then(
                                                          (_) =>
                                                              setState(() {}));

                                                      // Get.to(FollowingScreen());
                                                    }),
                                                Text(
                                                  '${_creator_login_screen_controller.userInfoModel_email!.data![0].followingNumber}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'PR'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 16, left: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: VisualDensity(
                                                      vertical: -4,
                                                      horizontal: -4),
                                                  icon: Image.asset(
                                                    AssetUtils.facebook_icon,
                                                    height: 32,
                                                    width: 32,
                                                  ),
                                                  onPressed: () {
                                                    // _loginScreenController.signInWithFacebook(
                                                    //     login_type: 'creator', context: context);
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: VisualDensity(
                                                      vertical: -4,
                                                      horizontal: -4),
                                                  icon: Image.asset(
                                                    AssetUtils.instagram_icon,
                                                    height: 32,
                                                    width: 32,
                                                  ),
                                                  onPressed: () {
                                                    // Get.to(InstagramView());
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  visualDensity: VisualDensity(
                                                      vertical: -4,
                                                      horizontal: -4),
                                                  icon: Image.asset(
                                                    AssetUtils.twitter_icon,
                                                    height: 32,
                                                    width: 32,
                                                  ),
                                                  onPressed: () {
                                                    // _loginScreenController.signInWithTwitter(context: context, login_type: 'creator');
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                // height: 45,
                                                // width:(width ?? 300) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 20),
                                                    child: Text(
                                                      'Analysis',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'PR',
                                                          fontSize: 16),
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                // height: 45,
                                                // width:(width ?? 300) ,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 30),
                                                    child: Text(
                                                      'Chat',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'PR',
                                                          fontSize: 16),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    color: HexColor(CommonColor.pinkFont)
                                        .withOpacity(0.7),
                                    height: 0.5,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 0, right: 0, left: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 3)),
                                              child: IconButton(
                                                visualDensity: VisualDensity(
                                                    vertical: -4,
                                                    horizontal: -4),
                                                onPressed: () async {
                                                  // File editedFile = await Navigator
                                                  //         .of(context)
                                                  //     .push(MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             StoriesEditor(
                                                  //               // fontFamilyList: font_family,
                                                  //               giphyKey: '',
                                                  //               onDone:
                                                  //                   (String) {},
                                                  //               // filePath:
                                                  //               //     imgFile!.path,
                                                  //             )));
                                                  // if (editedFile != null) {
                                                  //   print(
                                                  //       'editedFile: ${editedFile.path}');
                                                  // }
                                                  // openCamera();
                                                  pop_up();
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  color: HexColor(
                                                      CommonColor.pinkFont),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Add Story',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'PR',
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 85,
                                            child: ListView.builder(
                                                itemCount: story_.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            print(index);
                                                            story_info =
                                                                getStoryModel!
                                                                    .data![
                                                                        index]
                                                                    .storys!;
                                                            print(story_info);
                                                            Get.to(() =>
                                                                StoryScreen(
                                                                  title: story_[
                                                                          index]
                                                                      .title!,
                                                                  // thumbnail:
                                                                  //     test_thumb[index],
                                                                  stories:
                                                                      story_info,
                                                                  story_no:
                                                                      index,
                                                                  stories_title:
                                                                      story_,
                                                                ));
                                                            // Get.to(StoryScreen(stories: story_info));
                                                          },
                                                          child: SizedBox(
                                                            height: 60,
                                                            width: 60,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child: (story_[
                                                                          index]
                                                                      .storys![
                                                                          0]
                                                                      .storyPhoto!
                                                                      .isEmptys
                                                                  ? Image.asset(
                                                                      // test_thumb[
                                                                      //     index]
                                                                      'assets/images/Funky_App_Icon.png')
                                                                  : (story_[index]
                                                                              .storys![
                                                                                  0]
                                                                              .isVideo ==
                                                                          'false'
                                                                      ?
                                                              // Image.file(test_thumb[index])
                                                              FadeInImage
                                                                          .assetNetwork(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              "${URLConstants.base_data_url}images/${story_[index].storys![0].storyPhoto!}",
                                                                          placeholder:
                                                                              'assets/images/Funky_App_Icon.png',
                                                                          // color: HexColor(CommonColor.pinkFont),
                                                                        )
                                                                      :
                                                              Image.asset(
                                                                          // test_thumb[
                                                                          //     index]
                                                                          'assets/images/Funky_App_Icon.png'
                                                              ))),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        (story_[index]
                                                                    .title!
                                                                    .length >=
                                                                5
                                                            ? Container(
                                                                height: 20,
                                                                width: 40,
                                                                child: Marquee(
                                                                  text:
                                                                      '${story_[index].title}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'PR',
                                                                      fontSize:
                                                                          14),
                                                                  scrollAxis: Axis
                                                                      .horizontal,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  blankSpace:
                                                                      20.0,
                                                                  velocity:
                                                                      30.0,
                                                                  pauseAfterRound:
                                                                      Duration(
                                                                          milliseconds:
                                                                              100),
                                                                  startPadding:
                                                                      10.0,
                                                                  accelerationDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  accelerationCurve:
                                                                      Curves
                                                                          .easeIn,
                                                                  decelerationDuration:
                                                                      Duration(
                                                                          microseconds:
                                                                              500),
                                                                  decelerationCurve:
                                                                      Curves
                                                                          .easeOut,
                                                                ),
                                                              )
                                                            : Text(
                                                                '${story_[index].title}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'PR',
                                                                    fontSize:
                                                                        14),
                                                              ))
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    color: HexColor(CommonColor.pinkFont)
                                        .withOpacity(0.7),
                                    height: 0.5,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ],
                              ),
                            )),
                        bottom: TabBar(
                          indicatorColor: Colors.transparent,
                          controller: _tabController,
                          tabs: _tabs,
                        )
                        // TabBar(
                        //   labelPadding: EdgeInsets.zero,
                        //   indicatorColor: Colors.black,
                        //   controller: _tabController,
                        //   tabs: <Widget>[
                        //     Container(
                        //       margin: EdgeInsets.only(bottom: 0),
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //           color: Colors.black,
                        //           borderRadius: BorderRadius.circular(50),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: HexColor(CommonColor.blue),
                        //               // spreadRadius: 5,
                        //               blurRadius: 6,
                        //               offset:
                        //                   Offset(0, 3), // changes position of shadow
                        //             ),
                        //           ],
                        //           gradient: LinearGradient(
                        //             begin: Alignment.topLeft,
                        //             end: Alignment.bottomRight,
                        //             // stops: [0.1, 0.5, 0.7, 0.9],
                        //             colors: [
                        //               HexColor("#000000"),
                        //               HexColor("#C12265"),
                        //               // HexColor("#FFFFFF").withOpacity(0.67),
                        //             ],
                        //           ),
                        //           border: Border.all(
                        //               color: HexColor(CommonColor.blue), width: 1.5)),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             index == 0;
                        //           });
                        //           print(index);
                        //         },
                        //         icon: Image.asset(
                        //           AssetUtils.story1,
                        //           height: 25,
                        //           width: 25,
                        //           color: HexColor(CommonColor.blue),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.all(0),
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(50),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: HexColor(CommonColor.green),
                        //               // spreadRadius: 5,
                        //               blurRadius: 6,
                        //               offset:
                        //                   Offset(0, 3), // changes position of shadow
                        //             ),
                        //           ],
                        //           gradient: LinearGradient(
                        //             begin: Alignment.topLeft,
                        //             end: Alignment.bottomRight,
                        //             // stops: [0.1, 0.5, 0.7, 0.9],
                        //             colors: [
                        //               HexColor("#000000"),
                        //               HexColor("#C12265"),
                        //               // HexColor("#FFFFFF").withOpacity(0.67),
                        //             ],
                        //           ),
                        //           border: Border.all(
                        //               color: HexColor(CommonColor.green), width: 1.5)),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             index == 1;
                        //           });
                        //           print(index);
                        //         },
                        //         icon: Image.asset(
                        //           AssetUtils.story2,
                        //           height: 25,
                        //           width: 25,
                        //           color: HexColor(CommonColor.green),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.all(0),
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: HexColor(CommonColor.tile),
                        //               // spreadRadius: 5,
                        //               blurRadius: 6,
                        //               offset:
                        //                   Offset(0, 3), // changes position of shadow
                        //             ),
                        //           ],
                        //           gradient: LinearGradient(
                        //             begin: Alignment.topLeft,
                        //             end: Alignment.bottomRight,
                        //             // stops: [0.1, 0.5, 0.7, 0.9],
                        //             colors: [
                        //               HexColor("#000000"),
                        //               HexColor("#C12265"),
                        //               // HexColor("#FFFFFF").withOpacity(0.67),
                        //             ],
                        //           ),
                        //           borderRadius: BorderRadius.circular(50),
                        //           border: Border.all(
                        //               color: HexColor(CommonColor.tile), width: 1.5)),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             index == 2;
                        //           });
                        //           print(index);
                        //         },
                        //         icon: Image.asset(
                        //           AssetUtils.story3,
                        //           height: 25,
                        //           width: 25,
                        //           color: HexColor(CommonColor.tile),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.all(0),
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: HexColor(CommonColor.orange),
                        //               // spreadRadius: 5,
                        //               blurRadius: 6,
                        //               offset:
                        //                   Offset(0, 3), // changes position of shadow
                        //             ),
                        //           ],
                        //           gradient: LinearGradient(
                        //             begin: Alignment.topLeft,
                        //             end: Alignment.bottomRight,
                        //             // stops: [0.1, 0.5, 0.7, 0.9],
                        //             colors: [
                        //               HexColor("#000000"),
                        //               HexColor("#C12265"),
                        //               // HexColor("#FFFFFF").withOpacity(0.67),
                        //             ],
                        //           ),
                        //           borderRadius: BorderRadius.circular(50),
                        //           border: Border.all(
                        //               color: HexColor(CommonColor.orange), width: 1.5)),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             index == 3;
                        //           });
                        //           print(index);
                        //         },
                        //         icon: Image.asset(
                        //           AssetUtils.story4,
                        //           height: 25,
                        //           width: 25,
                        //           color: HexColor(CommonColor.orange),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.all(0),
                        //       height: 50,
                        //       width: 50,
                        //       decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.white,
                        //               // spreadRadius: 5,
                        //               blurRadius: 6,
                        //               offset:
                        //                   Offset(0, 3), // changes position of shadow
                        //             ),
                        //           ],
                        //           gradient: LinearGradient(
                        //             begin: Alignment.topLeft,
                        //             end: Alignment.bottomRight,
                        //             // stops: [0.1, 0.5, 0.7, 0.9],
                        //             colors: [
                        //               HexColor("#000000"),
                        //               HexColor("#C12265"),
                        //               // HexColor("#FFFFFF").withOpacity(0.67),
                        //             ],
                        //           ),
                        //           borderRadius: BorderRadius.circular(50),
                        //           border: Border.all(color: Colors.white, width: 1.5)),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             index == 4;
                        //           });
                        //           print(index);
                        //         },
                        //         icon: Image.asset(
                        //           AssetUtils.story5,
                        //           height: 25,
                        //           width: 25,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //
                        //   ],
                        // ),
                        ),
                  ];
                },
                body: TabBarView(
                  physics: BouncingScrollPhysics(),
                  // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
                  controller: _tabController,
                  children: [
                    video_screen(),
                    gallery_screen(),
                    gallery_screen(),
                    gallery_screen(),
                    gallery_screen(),
                  ],
                ),
              ))));
  }

  Widget gallery_screen() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 16, left: 16),
      child: SingleChildScrollView(
          child: (ispostLoading == true
              ? Center(
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
                )
              : (_galleryModelList!.error == false
                  ? StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      itemCount: _galleryModelList!.data!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 120.0,
                          // width: 120.0,
                          child: (ispostLoading == true
                              ? CircularProgressIndicator(
                                  color: HexColor(CommonColor.pinkFont),
                                )
                              : Container(
                                  color: Colors.white,
                                  child: (_galleryModelList!
                                          .data![index].postImage!.isEmpty
                                      ? Image.asset(AssetUtils.logo)
                                      : Image.network(
                                          '${URLConstants.base_data_url}images/${_galleryModelList!.data![index].postImage}',
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }

                                            return Center(
                                                child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: HexColor(
                                                          CommonColor.pinkFont),
                                                    )));
                                            // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                          },
                                        )),
                                )),
                        ),
                      ),
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 3 : 2),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Text("${_galleryModelList!.message}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'PR')),
                        ),
                      ),
                    )))),
    );
  }

  bool ispostLoading = true;
  GalleryModelList? _galleryModelList;

  Future<dynamic> get_gallery_list(BuildContext context) async {
    setState(() {
      ispostLoading = true;
    });
    // showLoader(context);

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'userId': id_user,
      'isVideo': 'false',
    };
    print(data);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}galleryList.php');
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
      var data = jsonDecode(response.body);
      _galleryModelList = GalleryModelList.fromJson(data);

      if (_galleryModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Succesful');
        // print(_galleryModelList);
        setState(() {
          ispostLoading = false;
        });
        // print(_galleryModelList!.data![0].postImage);
        // print(_galleryModelList!.data![1].postImage);

        // hideLoader(context);
        // Get.to(Dashboard());
      } else {
        setState(() {
          ispostLoading = false;
        });
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  bool isvideoLoading = true;
  VideoModelList? _videoModelList;
  String? filePath;
  List<File> imgFile_list = [];

  Future<dynamic> get_video_list(BuildContext context) async {
    setState(() {
      isvideoLoading = true;
    });
    // showLoader(context);

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    debugPrint('0-0-0-0-0-0-0 username');
    Map data = {
      'userId': id_user,
      'isVideo': 'true',
    };
    print(data);
    // String body = json.encode(data);

    var url = ('${URLConstants.base_url}post-videoList.php');
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
      var data = jsonDecode(response.body);
      _videoModelList = VideoModelList.fromJson(data);

      if (_videoModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Succesful');
        // print(_videoModelList);

        print("_videoModelList!.data!.length");
        print(_videoModelList!.data!.length);

        for (int i = 0; i < _videoModelList!.data!.length; i++) {
          final uint8list = await VideoThumbnail.thumbnailFile(
            video:
                ("http://foxyserver.com/funky/video/${_videoModelList!.data![i].uploadVideo}"),
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: 64,
            // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
            quality: 75,
          );
          imgFile_list.add(File(uint8list!));
          // print(test_thumb[i].path);
          setState(() {
            isvideoLoading = false;
          });
          print("test----------${imgFile_list[i].path}");
        }
        print("thumbaaaa ;; $imgFile_list");
      } else {
        setState(() {
          isvideoLoading = false;
        });
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  Widget video_screen() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 16, left: 16),
      child: SingleChildScrollView(
          child: (isvideoLoading == true
              ? Center(
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
                )
              : (_videoModelList!.error == false
                  ? StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      itemCount: imgFile_list.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                 ),
                              child: (isvideoLoading == true
                                  ? CircularProgressIndicator(
                                      color: HexColor(CommonColor.pinkFont),
                                    )
                                  : Stack(
                                alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                          child: (_videoModelList!
                                                  .data![index].image!.isEmpty
                                              ? Image.asset(AssetUtils.logo)
                                              : GestureDetector(
                                                  onTap: () {
                                                    print('data');
                                                    Get.to(VideoViewer(
                                                      url: _videoModelList!
                                                          .data![index]
                                                          .uploadVideo!,
                                                    ));
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),

                                                    // height: MediaQuery.of(context).size.aspectRatio,
                                                    child: Image.memory(
                                                      imgFile_list[index]
                                                          .readAsBytesSync(),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                  // Image.network(
                                                  //   'http://foxyserver.com/funky/images/${_videoModelList!.data![index].uploadVideo}',
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  )),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 3 : 2),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Text("${_videoModelList!.message}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'PR')),
                        ),
                      ),
                    )))),
    );
  }

  bool isStoryLoading = true;
  GetStoryModel? getStoryModel;
  List<Storys> story_info = [];
  List<Data_story> story_ = [];

  List<File> test_thumb = [];

  // List<String> thumb = [];
  // String? filePath;

  Future<dynamic> get_story_list({required int index}) async {
    print('Inside Story get email');
    setState(() {
      isStoryLoading = true;
    });
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $id_user");
    String url =
        ("${URLConstants.base_url}${URLConstants.StoryGetApi}?userId=$id_user");
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
      getStoryModel = GetStoryModel.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      if (getStoryModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getStoryModel!.data!.length}');
        story_ = getStoryModel!.data!;
        story_info = getStoryModel!.data![0].storys!;

        // test = File(uint8list!);

        for (int i = 0; i < getStoryModel!.data!.length; i++) {
          if (getStoryModel!.data![i].storys![0].isVideo == 'true') {
            // final uint8list = await VideoThumbnail.thumbnailFile(
            //   video:
            //   ("${URLConstants.base_data_url}images/${getStoryModel!.data![i].storys![0].storyPhoto}"),
            //   thumbnailPath: (await getTemporaryDirectory()).path,
            //   imageFormat: ImageFormat.PNG,
            //   maxHeight: 64,
            //   // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
            //   quality: 20,
            // );
            // test_thumb.add(File(uint8list!));
            // print(test_thumb[i].path);
          } else if (getStoryModel!.data![i].storys![0].isVideo == 'false') {
            // test_thumb
            //     .add(File(getStoryModel!.data![i].storys![0].storyPhoto!));
            // print(story_info[i].image);
          }

          // print("test----------${test_thumb[i].path}");
        }
        setState(() {
          isStoryLoading = false;
        });
        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        return getStoryModel;
      } else {
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

  File? imgFile;
  List<XFile>? ListimgFile_;
  final imgPicker = ImagePicker();

  Future image_Gallery() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                elevation: 0.0,
                // title: Center(child: Text("Evaluation our APP")),
                content: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  height: MediaQuery.of(context).size.height / 3,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(26.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: common_button(
                              onTap: () {
                                // openCamera();
                                openGallery();
                                Navigator.pop(context);
                                // Get.toNamed(BindingUtils.signupOption);
                              },
                              backgroud_color: Colors.black,
                              lable_text: 'Image',
                              lable_text_color: Colors.white,
                            ),
                          ),
                          common_button(
                            onTap: () {
                              Pickvideo();
                              Navigator.pop(context);
                              // Get.toNamed(BindingUtils.signupOption);
                            },
                            backgroud_color: Colors.black,
                            lable_text: 'Video',
                            lable_text_color: Colors.white,
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  void openGallery() async {
    // var imgCamera = await imgPicker.pickImage(source: ImageSource.gallery);
    final List<XFile>? images =
        await imgPicker.pickMultiImage(imageQuality: 50);
    ListimgFile_ = images;
    setState(() {});
    print("images.length ${ListimgFile_!.length}");
    for (var i = 0; i < ListimgFile_!.length; i++) {
      print(ListimgFile_![i].path);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewImageSelected(
                  imageData: ListimgFile_!,
                )));
    // setState(() {
    // imgFile = File(imgCamera!.path);
    // _creator_signup_controller.photoBase64 =
    //     base64Encode(imgFile!.readAsBytesSync());
    // print(_creator_signup_controller.photoBase64);
    // });
    ///edit story
    // File editedFile = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => StoriesEditor(
    //           // fontFamilyList: font_family,
    //           giphyKey:
    //               'https://giphy.com/gifs/congratulations-congrats-xT0xezQGU5xCDJuCPe',
    //           imageData: imgFile,
    //           onDone: (String) {},
    //           // filePath:
    //           //     imgFile!.path,
    //         )));
    // if (editedFile != null) {
    //   print('editedFile: ${editedFile.path}');
    // }
    ///
  }

  void Pickvideo() async {
    var imgCamera = await imgPicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgCamera!.path);
      ListimgFile_ = imgCamera as List<XFile>;
      // _creator_signup_controller.photoBase64 =
      //     base64Encode(imgFile!.readAsBytesSync());
      // print(_creator_signup_controller.photoBase64);
    });
    await Get.to(Story_image_preview(
      ImageFile: ListimgFile_!,
    ));

    // File editedFile = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => StoriesEditor(
    //           // fontFamilyList: font_family,
    //           giphyKey: '',
    //           imageData: imgFile,
    //           onDone: (String) {},
    //           // filePath:
    //           //     imgFile!.path,
    //         )));
    // if (editedFile != null) {
    //   print('editedFile: ${editedFile.path}');
    // }
  }

  late double screenHeight, screenWidth;

  Future pop_up() {
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
                        GestureDetector(
                          onTap: () {
                            // camera_upload();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyApp_video(
                                        story: true,
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // camera_upload();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp_video(
                                              story: true,
                                            )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                // height: 45,
                                // width:(width ?? 300) ,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    child: Text(
                                      'Camera',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PR',
                                          fontSize: 16),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
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
                            // image_Gallery();
                            Get.to(PostScreen());
                          },
                          child: Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
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
                                  // image_Gallery();
                                  Get.to(PostScreen());
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                // height: 45,
                                // width:(width ?? 300) ,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    child: Text(
                                      'Gallery',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PR',
                                          fontSize: 16),
                                    )),
                              ),
                            ],
                          ),
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
    );
  }
}
