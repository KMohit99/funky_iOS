import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:funky_project/Authentication/creator_login/model/creator_loginModel.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/profile_screen/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

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
    print(
        "SOcial type------------ ${_creator_login_screen_controller.userInfoModel_email!.data![0].socialType}");
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  init() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    get_gallery_list(context);
    (_creator_login_screen_controller
                .userInfoModel_email!.data![0].socialType ==
            ""
        ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
            UserId: id_user)
        : await _creator_login_screen_controller.getUserInfo_social());
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false,
                expandedHeight: 370.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 18, top: 0, bottom: 0),
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      icon: (Image.asset(
                                        AssetUtils.story5,
                                        color: HexColor(CommonColor.pinkFont),
                                        height: 20.0,
                                        width: 20.0,
                                        fit: BoxFit.contain,
                                      ))),
                                ),
                                Text(
                                  'My Profile',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'PB'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 20),
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
                                              MediaQuery.of(context).size.width;
                                          double height = MediaQuery.of(context)
                                              .size
                                              .height;
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: AlertDialog(
                                                insetPadding: EdgeInsets.only(
                                                    bottom: 500, left: 100),
                                                backgroundColor:
                                                    Colors.transparent,
                                                contentPadding: EdgeInsets.zero,
                                                elevation: 0.0,
                                                // title: Center(child: Text("Evaluation our APP")),
                                                content: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      // height: 122,
                                                      width: 150,
                                                      // padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment(
                                                                -1.0, 0.0),
                                                            end: Alignment(
                                                                1.0, 0.0),
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
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      26.0))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 5),
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
                                                                  fontSize: 15,
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
                                                              child: Divider(
                                                                color: Colors
                                                                    .black,
                                                                height: 20,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Block',
                                                              style: TextStyle(
                                                                  fontSize: 15,
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
                                                              child: Divider(
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
                                                                  fontSize: 15,
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
                                                              child: Divider(
                                                                color: Colors
                                                                    .black,
                                                                height: 20,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Share Profile ',
                                                              style: TextStyle(
                                                                  fontSize: 15,
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
                                    child: Image.asset(AssetUtils.image1),
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
                                            padding: EdgeInsets.only(left: 5.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            visualDensity:
                                                VisualDensity(vertical: -4),
                                            padding: EdgeInsets.only(left: 5.0),
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
                                            padding: EdgeInsets.only(left: 5.0),
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
                                            padding: EdgeInsets.only(left: 5.0),
                                            icon: Image.asset(
                                              AssetUtils.following_filled,
                                              color: HexColor(
                                                  CommonColor.pinkFont),
                                              height: 20,
                                              width: 20,
                                            ),
                                            onPressed: () {
                                              Get.to(FollowingScreen());
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            color: HexColor(CommonColor.borderColor),
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
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                                                  vertical: -4, horizontal: -4),
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
                            color: HexColor(CommonColor.borderColor),
                            height: 0.5,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    )),
                bottom: TabBar(
                  labelPadding: EdgeInsets.zero,
                  indicatorColor: Colors.black,
                  controller: _tabController,
                  tabs: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor(CommonColor.blue),
                              // spreadRadius: 5,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                          border: Border.all(
                              color: HexColor(CommonColor.blue), width: 1.5)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            index == 0;
                          });
                          print(index);
                        },
                        icon: Image.asset(
                          AssetUtils.story1,
                          height: 25,
                          width: 25,
                          color: HexColor(CommonColor.blue),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(0),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor(CommonColor.green),
                              // spreadRadius: 5,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                          border: Border.all(
                              color: HexColor(CommonColor.green), width: 1.5)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            index == 1;
                          });
                          print(index);
                        },
                        icon: Image.asset(
                          AssetUtils.story2,
                          height: 25,
                          width: 25,
                          color: HexColor(CommonColor.green),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(0),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: HexColor(CommonColor.tile),
                              // spreadRadius: 5,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                          border: Border.all(
                              color: HexColor(CommonColor.tile), width: 1.5)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            index == 2;
                          });
                          print(index);
                        },
                        icon: Image.asset(
                          AssetUtils.story3,
                          height: 25,
                          width: 25,
                          color: HexColor(CommonColor.tile),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(0),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: HexColor(CommonColor.orange),
                              // spreadRadius: 5,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                          border: Border.all(
                              color: HexColor(CommonColor.orange), width: 1.5)),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            index == 3;
                          });
                          print(index);
                        },
                        icon: Image.asset(
                          AssetUtils.story4,
                          height: 25,
                          width: 25,
                          color: HexColor(CommonColor.orange),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(0),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              // spreadRadius: 5,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            index == 4;
                          });
                          print(index);
                        },
                        icon: Image.asset(
                          AssetUtils.story5,
                          height: 25,
                          width: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //
                    //
                    //       ],
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.symmetric(vertical: 15),
                    //       color: HexColor(CommonColor.borderColor),
                    //       height: 0.5,
                    //       width: MediaQuery.of(context).size.width,
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ];
          },
          body: Container(
            margin: EdgeInsets.only(top: 10, right: 16, left: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Container(
                  //       // color: Colors.white,
                  //       height: 80,
                  //       width: 80,
                  //       child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(50),
                  //         child: Image.asset(AssetUtils.image1),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Expanded(
                  //       flex: 3,
                  //       child: Container(
                  //         child: Text(
                  //           'Name Surname',
                  //           style: TextStyle(
                  //               fontSize: 14,
                  //               color: HexColor(CommonColor.pinkFont)),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Row(
                  //             children: [
                  //               IconButton(
                  //                   visualDensity: VisualDensity(vertical: -4),
                  //                   padding: EdgeInsets.only(left: 5.0),
                  //                   icon: Image.asset(
                  //                     AssetUtils.like_icon_filled,
                  //                     color: HexColor(CommonColor.pinkFont),
                  //                     height: 20,
                  //                     width: 20,
                  //                   ),
                  //                   onPressed: () {}),
                  //               Text(
                  //                 '45',
                  //                 style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 12,
                  //                     fontFamily: 'PR'),
                  //               ),
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               IconButton(
                  //                   padding: EdgeInsets.only(left: 5.0),
                  //                   visualDensity: VisualDensity(vertical: -4),
                  //                   icon: Image.asset(
                  //                     AssetUtils.profile_filled,
                  //                     color: HexColor(CommonColor.pinkFont),
                  //                     height: 20,
                  //                     width: 20,
                  //                   ),
                  //                   onPressed: () {}),
                  //               Text(
                  //                 '260',
                  //                 style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 12,
                  //                     fontFamily: 'PR'),
                  //               ),
                  //             ],
                  //           ),
                  //           IconButton(
                  //               visualDensity: VisualDensity(vertical: -4),
                  //               padding: EdgeInsets.only(left: 5.0),
                  //               icon: Image.asset(
                  //                 AssetUtils.following_filled,
                  //                 color: HexColor(CommonColor.pinkFont),
                  //                 height: 20,
                  //                 width: 20,
                  //               ),
                  //               onPressed: () {}),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(50),
                  //             ),
                  //             child: IconButton(
                  //               padding: EdgeInsets.zero,
                  //               visualDensity:
                  //                   VisualDensity(vertical: -4, horizontal: -4),
                  //               icon: Image.asset(
                  //                 AssetUtils.facebook_icon,
                  //                 height: 32,
                  //                 width: 32,
                  //               ),
                  //               onPressed: () {
                  //                 // _loginScreenController.signInWithFacebook(
                  //                 //     login_type: 'creator', context: context);
                  //               },
                  //             ),
                  //           ),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(50),
                  //             ),
                  //             child: IconButton(
                  //               padding: EdgeInsets.zero,
                  //               visualDensity:
                  //                   VisualDensity(vertical: -4, horizontal: -4),
                  //               icon: Image.asset(
                  //                 AssetUtils.instagram_icon,
                  //                 height: 32,
                  //                 width: 32,
                  //               ),
                  //               onPressed: () {
                  //                 // Get.to(InstagramView());
                  //               },
                  //             ),
                  //           ),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(50),
                  //             ),
                  //             child: IconButton(
                  //               padding: EdgeInsets.zero,
                  //               visualDensity:
                  //                   VisualDensity(vertical: -4, horizontal: -4),
                  //               icon: Image.asset(
                  //                 AssetUtils.twitter_icon,
                  //                 height: 32,
                  //                 width: 32,
                  //               ),
                  //               onPressed: () {
                  //                 // _loginScreenController.signInWithTwitter(context: context, login_type: 'creator');
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 2,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           Container(
                  //             margin: const EdgeInsets.symmetric(horizontal: 0),
                  //             // height: 45,
                  //             // width:(width ?? 300) ,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(25)),
                  //             child: Container(
                  //                 alignment: Alignment.center,
                  //                 margin: EdgeInsets.symmetric(
                  //                     vertical: 10, horizontal: 20),
                  //                 child: Text(
                  //                   'Analysis',
                  //                   style: TextStyle(
                  //                       color: Colors.black,
                  //                       fontFamily: 'PR',
                  //                       fontSize: 16),
                  //                 )),
                  //           ),
                  //           SizedBox(
                  //             width: 10,
                  //           ),
                  //           Container(
                  //             margin: const EdgeInsets.symmetric(horizontal: 0),
                  //             // height: 45,
                  //             // width:(width ?? 300) ,
                  //             decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(25)),
                  //             child: Container(
                  //                 alignment: Alignment.center,
                  //                 margin: EdgeInsets.symmetric(
                  //                     vertical: 10, horizontal: 30),
                  //                 child: Text(
                  //                   'Chat',
                  //                   style: TextStyle(
                  //                       color: Colors.black,
                  //                       fontFamily: 'PR',
                  //                       fontSize: 16),
                  //                 )),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 15),
                  //   color: HexColor(CommonColor.borderColor),
                  //   height: 0.5,
                  //   width: MediaQuery.of(context).size.width,
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.all(5),
                  //       height: 61,
                  //       width: 61,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(50),
                  //           border: Border.all(color: Colors.white, width: 3)),
                  //       child: IconButton(
                  //         onPressed: () {},
                  //         icon: Icon(
                  //           Icons.add,
                  //           color: HexColor(CommonColor.pinkFont),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: SizedBox(
                  //         height: 70,
                  //         child: ListView.builder(
                  //             itemCount: Story_img.length,
                  //             shrinkWrap: true,
                  //             scrollDirection: Axis.horizontal,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               return Container(
                  //                 margin: EdgeInsets.all(5),
                  //                 height: 61,
                  //                 width: 61,
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(50),
                  //                     border: Border.all(
                  //                         color: Colors.white, width: 3)),
                  //                 child: IconButton(
                  //                   color: Colors.red,
                  //                   visualDensity: VisualDensity(
                  //                       vertical: -4, horizontal: -4),
                  //                   onPressed: () {},
                  //                   icon: Image.asset(
                  //                     Story_img[index],
                  //                     fit: BoxFit.fill,
                  //                     // color: HexColor(CommonColor.pinkFont),
                  //                   ),
                  //                 ),
                  //               );
                  //             }),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 15),
                  //   color: HexColor(CommonColor.borderColor),
                  //   height: 0.5,
                  //   width: MediaQuery.of(context).size.width,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       margin: EdgeInsets.all(5),
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
                  //         onPressed: () {},
                  //         icon: Image.asset(
                  //           AssetUtils.story1,
                  //           height: 25,
                  //           width: 25,
                  //           color: HexColor(CommonColor.blue),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(5),
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
                  //               color: HexColor(CommonColor.green),
                  //               width: 1.5)),
                  //       child: IconButton(
                  //         onPressed: () {},
                  //         icon: Image.asset(
                  //           AssetUtils.story2,
                  //           height: 25,
                  //           width: 25,
                  //           color: HexColor(CommonColor.green),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(5),
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
                  //         onPressed: () {},
                  //         icon: Image.asset(
                  //           AssetUtils.story3,
                  //           height: 25,
                  //           width: 25,
                  //           color: HexColor(CommonColor.tile),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(5),
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
                  //               color: HexColor(CommonColor.orange),
                  //               width: 1.5)),
                  //       child: IconButton(
                  //         onPressed: () {},
                  //         icon: Image.asset(
                  //           AssetUtils.story4,
                  //           height: 25,
                  //           width: 25,
                  //           color: HexColor(CommonColor.orange),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.all(5),
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
                  //           border:
                  //               Border.all(color: Colors.white, width: 1.5)),
                  //       child: IconButton(
                  //         onPressed: () {},
                  //         icon: Image.asset(
                  //           AssetUtils.story5,
                  //           height: 25,
                  //           width: 25,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  video_screen(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget video_screen() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 16, left: 16),
      child: SingleChildScrollView(
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            itemCount: _galleryModelList!.data!.length,
            itemBuilder: (BuildContext context, int index) => ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 120.0,
                // width: 120.0,
                child: (_galleryModelList!.data![index].image!.isEmpty
                    ? Image.asset(AssetUtils.logo)
                    : Image.network(
                  'http://foxyserver.com/funky/images/${_galleryModelList!.data![index].postImage}',)),
              ),
            ),
            staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 3 : 2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          )),
    );
  }

  bool ispostLoading = false;
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
      print(_galleryModelList);
      if (_galleryModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Posted Succesfully');
        setState(() {
          ispostLoading = false;
        });
        print(_galleryModelList!.data![index].image!.length);

        // hideLoader(context);
        // Get.to(Dashboard());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }
}
