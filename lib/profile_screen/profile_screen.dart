import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/profile_screen/video_viewer.dart';

// import 'package:funky_project/Authentication/creator_login/model/creator_loginModel.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/profile_screen/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
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
import '../sharePreference.dart';
import 'edit_profile_screen.dart';
import 'followers_screen.dart';
import 'following_screen.dart';
import 'model/galleryModel.dart';
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

  var thumbnail;

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
    await get_gallery_list(context);
    await get_video_list(context);
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
      height: 60,
      icon: Container(
        margin: EdgeInsets.only(top: 10),
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
      height: 60,
      icon: Container(
        margin: EdgeInsets.only(top: 10),
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
      height: 60,
      icon: Container(
        margin: EdgeInsets.only(top: 10),
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
      height: 60,
      icon: Container(
        margin: EdgeInsets.only(top: 10),
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
      height: 60,
      icon: Container(
        margin: EdgeInsets.only(top: 10),
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
        backgroundColor: Colors.transparent,
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
        body: Obx(() => (_creator_login_screen_controller.isuserinfoLoading.value == true ? Center(
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
        ):NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  expandedHeight: 370.0,
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
                              margin:
                              EdgeInsets.only(top: 0, right: 16, left: 16),
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
                                            builder: (BuildContext context) {
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
                                                    sigmaX: 10, sigmaY: 10),
                                                child: AlertDialog(
                                                    insetPadding:
                                                    EdgeInsets.only(
                                                        bottom: 500,
                                                        left: 100),
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    contentPadding:
                                                    EdgeInsets.zero,
                                                    elevation: 0.0,
                                                    // title: Center(child: Text("Evaluation our APP")),
                                                    content: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              vertical: 0,
                                                              horizontal:
                                                              0),
                                                          // height: 122,
                                                          width: 150,
                                                          // padding: const EdgeInsets.all(8.0),
                                                          decoration:
                                                          BoxDecoration(
                                                              gradient:
                                                              LinearGradient(
                                                                begin:
                                                                Alignment(
                                                                    -1.0,
                                                                    0.0),
                                                                end: Alignment(
                                                                    1.0,
                                                                    0.0),
                                                                transform:
                                                                GradientRotation(
                                                                    0.7853982),
                                                                // stops: [0.1, 0.5, 0.7, 0.9],
                                                                colors: [
                                                                  HexColor(
                                                                      "#000000"),
                                                                  HexColor(
                                                                      "#000000"),
                                                                  HexColor(
                                                                      "##E84F90"),
                                                                  // HexColor("#ffffff"),
                                                                  // HexColor("#FFFFFF").withOpacity(0.67),
                                                                ],
                                                              ),
                                                              color: Colors
                                                                  .white,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1),
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      26.0))),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical:
                                                                10,
                                                                horizontal:
                                                                5),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Text(
                                                                  'Report',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontFamily:
                                                                      'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      20),
                                                                  child:
                                                                  Divider(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 20,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Block',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontFamily:
                                                                      'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      20),
                                                                  child:
                                                                  Divider(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 20,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Remove follower',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontFamily:
                                                                      'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      20),
                                                                  child:
                                                                  Divider(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 20,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Share Profile ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontFamily:
                                                                      'PR',
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
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
                              margin:
                              EdgeInsets.only(top: 0, right: 16, left: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // color: Colors.white,
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (_creator_login_screen_controller
                                          .userInfoModel_email!
                                          .data![0]
                                          .image!
                                          .isNotEmpty
                                          ? Image.network(
                                        'http://foxyserver.com/funky/images/${_creator_login_screen_controller.userInfoModel_email!.data![0].image!}',
                                        fit: BoxFit.fitWidth,
                                      )
                                          : Image.asset(AssetUtils.image1)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Row(
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
                                                fontSize: 14,
                                                color: HexColor(
                                                    CommonColor.pinkFont)),
                                          ),
                                          IconButton(
                                              visualDensity:
                                              VisualDensity(vertical: -4),
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                Get.to(EditProfileScreen());
                                              }),
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
                                              VisualDensity(vertical: -4),
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              icon: Image.asset(
                                                AssetUtils.like_icon_filled,
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
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              visualDensity:
                                              VisualDensity(vertical: -4),
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
                                              VisualDensity(vertical: -4),
                                              padding:
                                              EdgeInsets.only(left: 5.0),
                                              icon: Image.asset(
                                                AssetUtils.following_filled,
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
                                                            FollowingScreen()))
                                                    .then(
                                                        (_) => setState(() {}));

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
                              margin:
                              EdgeInsets.only(top: 0, right: 16, left: 16),
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
                                                vertical: -4, horizontal: -4),
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
                                                vertical: -4, horizontal: -4),
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
                                                vertical: -4, horizontal: -4),
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          // height: 45,
                                          // width:(width ?? 300) ,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(25)),
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          // height: 45,
                                          // width:(width ?? 300) ,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(25)),
                                          child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 30),
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
                              margin:
                              EdgeInsets.only(top: 0, right: 16, left: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    height: 61,
                                    width: 61,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.white, width: 3)),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.add,
                                        color: HexColor(CommonColor.pinkFont),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 70,
                                      child: ListView.builder(
                                          itemCount: Story_img.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin: EdgeInsets.all(0),
                                              height: 71,
                                              width: 71,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(50),
                                              ),
                                              child: IconButton(
                                                color: Colors.red,
                                                visualDensity: VisualDensity(
                                                    vertical: -4,
                                                    horizontal: -4),
                                                onPressed: () {},
                                                icon: Image.asset(
                                                  Story_img[index],
                                                  fit: BoxFit.cover,
                                                  // color: HexColor(CommonColor.pinkFont),
                                                ),
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
        ) ))
        );
  }

  Widget gallery_screen() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 16, left: 16),
      child: SingleChildScrollView(
          child: (ispostLoading == true
              ? Material(
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
                                          'http://foxyserver.com/funky/images/${_galleryModelList!.data![index].postImage}',
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;

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

    var url = ('http://foxyserver.com/funky/api/galleryList.php');
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
        print(_galleryModelList);
        setState(() {
          ispostLoading = false;
        });
        print(_galleryModelList!.data![0].postImage);
        print(_galleryModelList!.data![1].postImage);

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

  var uint8list;

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

    var url = ('http://foxyserver.com/funky/api/post-videoList.php');
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
        print(_videoModelList);
        setState(() {
          isvideoLoading = false;
        });
        uint8list = await VideoThumbnail.thumbnailFile(
          video:
              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.WEBP,
          maxHeight: 64,
          // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 75,
        );

        // for(var i = 0 ; i<= _videoModelList!.data!.length ; i++){
        //   Directory tempDir = await getTemporaryDirectory();
        //   String tempPath = tempDir.path;
        //
        //   try {
        //     thumbnail = await VideoThumbnail.thumbnailFile(
        //       video: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        //       imageFormat: ImageFormat.PNG,
        //       maxWidth: 256,
        //       maxHeight: 256,
        //       thumbnailPath: tempPath,
        //       quality: 50,
        //     );
        //     return thumbnail;
        //   } catch (e) {
        //     print(e);
        //     return null;
        //   }
        // }

        // hideLoader(context);
        // Get.to(Dashboard());
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
              ? Material(
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
                )
              : (_videoModelList!.error == false
                  ? StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      itemCount: _videoModelList!.data!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          // height: 120.0,
                          color: Colors.white,
                          // width: 120.0,
                          child: (isvideoLoading == true
                              ? CircularProgressIndicator(
                                  color: HexColor(CommonColor.pinkFont),
                                )
                              : (_videoModelList!
                                      .data![index].uploadVideo!.isEmpty
                                  ? Image.asset(
                                      AssetUtils.logo,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        print('data');
                                        Get.to(VideoViewer(
                                          url: _videoModelList!
                                              .data![index].uploadVideo!,
                                        ));
                                      },
                                      child: Image.asset(
                                        AssetUtils.logo,
                                      )
                                      // Image.network(
                                      //   'http://foxyserver.com/funky/images/${_videoModelList!.data![index].uploadVideo}',
                                      //   fit: BoxFit.cover,
                                      // ),
                                      ))),
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
}
