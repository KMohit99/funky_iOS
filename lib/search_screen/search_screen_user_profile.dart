import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/search_screen/searchModel.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';

// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/profile_screen/edit_profile_screen.dart';
// import 'package:funky_project/search_screen/searchModel.dart';
// import 'package:funky_project/search_screen/search__screen_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/toaster_widget.dart';
import '../chat/constants/firestore_constants.dart';
import '../chat/models/user_chat.dart';
import '../chat/pages/chat_page.dart';
import '../chat_quickblox/presentation/screens/chat/chat_screen.dart';
import '../chat_quickblox/presentation/screens/dialogs/dialogs_screen.dart';
import '../homepage/model/UserInfoModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../profile_screen/model/followUnfollowModel.dart';
import '../profile_screen/model/followersModel.dart';
import '../profile_screen/model/galleryModel.dart';
import '../profile_screen/model/getStoryModel.dart';
import '../profile_screen/model/videoModelList.dart';
import '../profile_screen/story_view/storyView.dart';
import '../profile_screen/video_viewer.dart';
import '../sharePreference.dart';
import 'Followers_scren.dart';
import 'Following_scren.dart';
import 'ViewStoryModel.dart';

class SearchUserProfile extends StatefulWidget {
  final Data_searchApi search_user_data;
  final String quickBlox_id;

  // final String UserId;

  const SearchUserProfile(
      {Key? key, required this.search_user_data, required this.quickBlox_id})
      : super(key: key);

  @override
  State<SearchUserProfile> createState() => _SearchUserProfileState();
}

class _SearchUserProfileState extends State<SearchUserProfile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    print('social type: ${widget.search_user_data.socialType}');
    init();
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  final _creator_Login_screen_controller =
  new Creator_Login_screen_controller();

  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  init() async {
    (widget.search_user_data.socialType == ""
        ? await _search_screen_controller.CreatorgetUserInfo_Email(
        UserId: widget.search_user_data.id!)
        : await _search_screen_controller.getUserInfo_social(
        UserId: widget.search_user_data.id!));
    await _search_screen_controller.compare_data();
    await get_story_list();
    await get_video_list(context);
    await get_gallery_list(context);
  }

  // Data_followers? _search_screen_controller.is_follower;
  // Data_followers? _search_screen_controller.is_following;
  //
  // compare_data() {
  //   print("widget.search_user_data.id ${_search_screen_controller.userInfoModel_email!.data![0].id}");
  //   print(
  //       "widget.search_user_data.id ${_search_screen_controller.userInfoModel_email!.data![0].followerNumber}");
  //   // print("widget.search_user_data.id ${FollowersData[0].id}");
  //
  //   String id = _search_screen_controller.userInfoModel_email!.data![0].id!;
  //
  //   Data_followers? last_out = FollowersData.firstWhereOrNull(
  //     (element) => element.id == id,
  //   );
  //   if (last_out == null) {
  //     print('no data found');
  //   } else {
  //     _search_screen_controller.is_follower = last_out;
  //     print('Followers list data _search_screen_controller.$is_follower');
  //   }
  //
  //   Data_followers? first_out = FollowingData.firstWhereOrNull(
  //     (element) => element.id == id,
  //   );
  //   if (first_out == null) {
  //     print('no data found');
  //   } else {
  //     _search_screen_controller.is_following = first_out;
  //     print('Followers list data _search_screen_controller.$is_following');
  //   }
  // }

  // RxBool isSearchuserinfoLoading = false.obs;
  // UserInfoModel? userInfoModel_search;
  // var getSearchedUSerModelList = UserInfoModel().obs;
  // Future get_searched_UserInfo_Email() async {
  //   isSearchuserinfoLoading(true);
  //   String userId = CommonService().getStoreValue(keys:'type');
  //   print("UserID ${widget.UserId}");
  //   String url = (URLConstants.base_url +
  //       URLConstants.user_info_email_Api +
  //       "?id=${widget.UserId}");
  //
  //
  //    http.Response response = await http.get(Uri.parse(url));
  //
  //   print('Response request: ${response.request}');
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     var data = convert.jsonDecode(response.body);
  //     userInfoModel_search = UserInfoModel.fromJson(data);
  //     getSearchedUSerModelList(userInfoModel_search);
  //     if (userInfoModel_search!.error == false) {
  //       debugPrint(
  //           '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${userInfoModel_search!.data!.length}');
  //       isSearchuserinfoLoading(false);
  //       // CommonWidget().showToaster(msg: data["success"].toString());
  //       return userInfoModel_search;
  //     } else {
  //       // CommonWidget().showToaster(msg: msg.toString());
  //       return null;
  //     }
  //   } else if (response.statusCode == 422) {
  //     // CommonWidget().showToaster(msg: msg.toString());
  //   } else if (response.statusCode == 401) {
  //     // CommonService().unAuthorizedUser();
  //   } else {
  //     // CommonWidget().showToaster(msg: msg.toString());
  //   }
  // }

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

  static final List<Tab> _tabs = [
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

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
        body: (_search_screen_controller.isuserinfoLoading.value == true
            ? Center(
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
                        margin:
                        EdgeInsets.only(top: 32, right: 16, left: 16),
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
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 5, top: 0, bottom: 0),
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity(
                                            vertical: -4, horizontal: -4),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ))),
                                Text(
                                  '${_search_screen_controller
                                      .userInfoModel_email!.data![0].userName}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'PB'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 0),
                                  child: IconButton(
                                    visualDensity: VisualDensity(
                                        vertical: 0, horizontal: -4),
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
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width;
                                          double height =
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height;
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: AlertDialog(
                                                insetPadding:
                                                EdgeInsets.only(
                                                    bottom: 500,
                                                    left: 150),
                                                backgroundColor:
                                                Colors.transparent,
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
                                                            begin: Alignment(
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
                                                              width:
                                                              1),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  26.0))),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10,
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
                                                                height:
                                                                20,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                _search_screen_controller
                                                                    .Block_unblock_api(
                                                                    context:
                                                                    context,
                                                                    user_id: _search_screen_controller
                                                                        .userInfoModel_email!
                                                                        .data![
                                                                    0]
                                                                        .id!,
                                                                    user_name: _search_screen_controller
                                                                        .userInfoModel_email!
                                                                        .data![
                                                                    0]
                                                                        .userName!,
                                                                    social_bloc_type: _search_screen_controller
                                                                        .userInfoModel_email!
                                                                        .data![
                                                                    0]
                                                                        .socialType!,
                                                                    block_unblock:
                                                                    'Block');
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                              Container(
                                                                child:
                                                                const Text(
                                                                  'Block',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontFamily:
                                                                      'PR',
                                                                      color:
                                                                      Colors
                                                                          .white),
                                                                ),
                                                              ),
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
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Colors.white,

                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(50),
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: (_search_screen_controller
                                          .isuserinfoLoading
                                          .value ==
                                          true
                                          ? CircularProgressIndicator(
                                        color: HexColor(
                                            CommonColor.pinkFont),
                                      )
                                          : (_search_screen_controller
                                          .userInfoModel_email!
                                          .data![0]
                                          .image!
                                          .isNotEmpty
                                          ? Image.network(
                                        "${URLConstants
                                            .base_data_url}images/${_search_screen_controller
                                            .userInfoModel_email!.data![0]
                                            .image!}",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                          : (_search_screen_controller
                                          .userInfoModel_email!
                                          .data![0]
                                          .profileUrl!
                                          .isNotEmpty
                                          ? Image.network(
                                        _search_screen_controller
                                            .userInfoModel_email!
                                            .data![0]
                                            .profileUrl!,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        AssetUtils.image1,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 100,
                                    // alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (_search_screen_controller
                                              .userInfoModel_email!
                                              .data![0]
                                              .fullName!
                                              .isNotEmpty
                                              ? '${_search_screen_controller
                                              .userInfoModel_email!.data![0]
                                              .fullName}'
                                              : 'Please update profile'),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: HexColor(
                                                  CommonColor.pinkFont)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          (_search_screen_controller
                                              .userInfoModel_email!
                                              .data![0]
                                              .about!
                                              .isNotEmpty
                                              ? '${_search_screen_controller
                                              .userInfoModel_email!.data![0]
                                              .about}'
                                              : ' '),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: HexColor(CommonColor
                                                  .subHeaderColor)),
                                        ),
                                        // Text(
                                        //   (widget.search_user_data.fullName!
                                        //           .isNotEmpty
                                        //       ? '${widget.search_user_data.fullName}'
                                        //       : 'Please update profile'),
                                        //   style: TextStyle(
                                        //       fontSize: 14,
                                        //       color: HexColor(CommonColor.pinkFont)),
                                        // ),
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
                                            visualDensity: VisualDensity(
                                                vertical: -4),
                                            padding: EdgeInsets.only(
                                                left: 5.0),
                                            icon: Image.asset(
                                              AssetUtils.like_icon_filled,
                                              color: HexColor(
                                                  CommonColor.pinkFont),
                                              height: 20,
                                              width: 20,
                                            ),
                                            onPressed: () {}),
                                        Text(
                                          '${_search_screen_controller
                                              .userInfoModel_email!.data![0]
                                              .followerNumber}',
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
                                            visualDensity: VisualDensity(
                                                vertical: -4),
                                            icon: Image.asset(
                                              AssetUtils.profile_filled,
                                              color: HexColor(
                                                  CommonColor.pinkFont),
                                              height: 20,
                                              width: 20,
                                            ),
                                            onPressed: () {
                                              Get.to(SearchUserFollowrs(
                                                searchUserid: widget
                                                    .search_user_data.id!,
                                              ));
                                            }),
                                        Text(
                                          '${_search_screen_controller
                                              .userInfoModel_email!.data![0]
                                              .followerNumber}',
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
                                            visualDensity: VisualDensity(
                                                vertical: -4),
                                            padding: EdgeInsets.only(
                                                left: 5.0),
                                            icon: Image.asset(
                                              AssetUtils.following_filled,
                                              color: HexColor(
                                                  CommonColor.pinkFont),
                                              height: 20,
                                              width: 20,
                                            ),
                                            onPressed: () {
                                              Get.to(searchUserFollowing(
                                                searchUserid: widget
                                                    .search_user_data.id!,
                                              ));
                                            }),
                                        Text(
                                          '${_search_screen_controller
                                              .userInfoModel_email!.data![0]
                                              .followingNumber}',
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
                            Row(
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
                                            height: 30,
                                            width: 30,
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
                                            height: 30,
                                            width: 30,
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
                                            height: 30,
                                            width: 30,
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
                                      Obx(() =>
                                      (_search_screen_controller
                                          .comapre_loading
                                          .value ==
                                          true
                                          ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(

                                            color: HexColor(
                                                CommonColor.pinkFont),
                                            strokeWidth: 2,))
                                          : GestureDetector(
                                        onTap: () async {
                                          await _search_screen_controller
                                              .Follow_unfollow_api(
                                              context: context,
                                              user_id: widget
                                                  .search_user_data
                                                  .id,
                                              user_social: widget
                                                  .search_user_data
                                                  .socialType,
                                              follow_unfollow: (_search_screen_controller
                                                  .is_follower !=
                                                  null &&
                                                  _search_screen_controller
                                                      .is_following !=
                                                      null
                                                  ? 'unfollow'
                                                  : (_search_screen_controller
                                                  .is_follower !=
                                                  null &&
                                                  _search_screen_controller
                                                      .is_following ==
                                                      null
                                                  ? 'follow'
                                                  : (_search_screen_controller
                                                  .is_follower == null &&
                                                  _search_screen_controller
                                                      .is_following != null
                                                  ? "unfollow"
                                                  : (_search_screen_controller
                                                  .is_follower == null &&
                                                  _search_screen_controller
                                                      .is_following == null
                                                  ? "follow"
                                                  : 'follow')))))
                                              .then((value) => setState(() {}));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets
                                              .symmetric(
                                              horizontal: 0),
                                          // height: 45,
                                          // width:(width ?? 300) ,
                                          decoration: BoxDecoration(
                                              color: (_search_screen_controller
                                                  .is_follower != null &&
                                                  _search_screen_controller
                                                      .is_following !=
                                                      null
                                                  ? Colors.black
                                                  : (_search_screen_controller
                                                  .is_follower != null &&
                                                  _search_screen_controller
                                                      .is_following == null
                                                  ? Colors.white
                                                  : (_search_screen_controller
                                                  .is_follower == null &&
                                                  _search_screen_controller
                                                      .is_following != null
                                                  ? Colors
                                                  .black
                                                  : (_search_screen_controller
                                                  .is_follower == null &&
                                                  _search_screen_controller
                                                      .is_following == null
                                                  ? Colors
                                                  .white
                                                  : Colors
                                                  .white)))),
                                              border: Border.all(
                                                  width: 1,
                                                  color: (_search_screen_controller
                                                      .is_follower != null &&
                                                      _search_screen_controller
                                                          .is_following !=
                                                          null
                                                      ? Colors.white
                                                      : (_search_screen_controller
                                                      .is_follower != null &&
                                                      _search_screen_controller
                                                          .is_following == null
                                                      ? HexColor(
                                                      CommonColor.pinkFont)
                                                      : (_search_screen_controller
                                                      .is_follower == null &&
                                                      _search_screen_controller
                                                          .is_following != null
                                                      ? Colors.white
                                                      : (_search_screen_controller
                                                      .is_follower == null &&
                                                      _search_screen_controller
                                                          .is_following == null
                                                      ? HexColor(
                                                      CommonColor.pinkFont)
                                                      : Colors.white))))),
                                              borderRadius: BorderRadius
                                                  .circular(25)),
                                          child: Container(
                                              alignment:
                                              Alignment.center,
                                              margin: EdgeInsets
                                                  .symmetric(
                                                  vertical: 8,
                                                  horizontal:
                                                  15),
                                              child: Text(
                                                (_search_screen_controller
                                                    .is_follower !=
                                                    null &&
                                                    _search_screen_controller
                                                        .is_following !=
                                                        null
                                                    ? 'Following'
                                                    : (_search_screen_controller
                                                    .is_follower !=
                                                    null &&
                                                    _search_screen_controller
                                                        .is_following ==
                                                        null
                                                    ? 'Follow'
                                                    : (_search_screen_controller
                                                    .is_follower ==
                                                    null &&
                                                    _search_screen_controller
                                                        .is_following !=
                                                        null
                                                    ? "Following"
                                                    : (_search_screen_controller
                                                    .is_follower == null &&
                                                    _search_screen_controller
                                                        .is_following == null
                                                    ? 'Follow'
                                                    : (_search_screen_controller
                                                    .is_follower == null &&
                                                    _search_screen_controller
                                                        .is_following != null
                                                    ? 'Following'
                                                    : ''))))),
                                                style: TextStyle(
                                                    color: (_search_screen_controller
                                                        .is_follower !=
                                                        null &&
                                                        _search_screen_controller
                                                            .is_following !=
                                                            null
                                                        ? Colors
                                                        .white
                                                        : (_search_screen_controller
                                                        .is_follower !=
                                                        null &&
                                                        _search_screen_controller
                                                            .is_following ==
                                                            null
                                                        ? Colors
                                                        .black
                                                        : (_search_screen_controller
                                                        .is_follower == null &&
                                                        _search_screen_controller
                                                            .is_following !=
                                                            null
                                                        ? Colors
                                                        .white
                                                        : (_search_screen_controller
                                                        .is_follower == null &&
                                                        _search_screen_controller
                                                            .is_following ==
                                                            null
                                                        ? Colors.black
                                                        : Colors.white)))),
                                                    fontFamily: 'PR',
                                                    fontSize: 16),
                                              )),
                                        ),
                                      ))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          // if (_search_screen_controller
                                          //     .is_follower !=
                                          //     null ||
                                          //     _search_screen_controller
                                          //         .is_following !=
                                          //         null) {
                                            // final QuerySnapshot result = await firebaseFirestore
                                            //     .collection(FirestoreConstants.pathUserCollection)
                                            //     .where(FirestoreConstants.id, isEqualTo: widget.search_user_data.id)
                                            //     .get();
                                            // final List<DocumentSnapshot> documents = result.docs;
                                            // if (documents.isEmpty) {
                                            //   // Writing data to server because here is a new user
                                            //   firebaseFirestore
                                            //       .collection(FirestoreConstants.pathUserCollection)
                                            //       .doc(widget.search_user_data.id)
                                            //       .set({
                                            //     FirestoreConstants.nickname: widget.search_user_data.fullName,
                                            //     FirestoreConstants.photoUrl:
                                            //     "https://foxytechnologies.com/funky/images/${widget.search_user_data.image}",
                                            //     FirestoreConstants.id: widget.search_user_data.id,
                                            //     'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                                            //     FirestoreConstants.chattingWith: null
                                            //   });
                                            //   // Write data to local storage
                                            //   // User? currentUser = firebaseUser;
                                            //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                            //   await prefs.setString(
                                            //       FirestoreConstants.id, widget.search_user_data.id!);
                                            //   await prefs.setString(
                                            //       FirestoreConstants.nickname, widget.search_user_data.fullName ?? "");
                                            //   await prefs.setString(
                                            //       FirestoreConstants.photoUrl,
                                            //       widget.search_user_data.image ??
                                            //           "");
                                            // }
                                            // else{
                                            //   DocumentSnapshot documentSnapshot = documents[0];
                                            //   UserChat userChat = UserChat.fromDocument(documentSnapshot);
                                            //   // Write data to local
                                            //   SharedPreferences prefs = await SharedPreferences.getInstance();
                                            //   await prefs.setString(FirestoreConstants.id, userChat.id);
                                            //   await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
                                            //   await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
                                            //   await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
                                            //
                                            // }

                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ChatPage(
                                            //           arguments: ChatPageArguments(
                                            //             peerId: widget
                                            //                 .search_user_data
                                            //                 .id!,
                                            //             peerAvatar: widget
                                            //                 .search_user_data
                                            //                 .image!,
                                            //             peerNickname: widget
                                            //                 .search_user_data
                                            //                 .fullName!,
                                            //           ),
                                            //         ),
                                            //   ),
                                            // );
                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => DialogsScreen()));
                                          // } else {
                                          //   // CommonWidget().showToaster(msg: 'Need to follow the user');
                                          // }
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatScreen(
                                                    widget.quickBlox_id, false),
                                              ));
                                        },
                                        child: Container(
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
                                              margin: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8,
                                                  horizontal: 20),
                                              child: const Text(
                                                'Chat',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'PR',
                                                    fontSize: 16),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              color: HexColor(CommonColor.pinkFont)
                                  .withOpacity(0.7),
                              height: 0.5,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 0, right: 16, left: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Column(
                                  //   children: [
                                  //     Container(
                                  //       margin: EdgeInsets.symmetric(
                                  //           horizontal: 5),
                                  //       height: 61,
                                  //       width: 61,
                                  //       decoration: BoxDecoration(
                                  //           borderRadius:
                                  //           BorderRadius.circular(50),
                                  //           border: Border.all(
                                  //               color: Colors.white,
                                  //               width: 3)),
                                  //       child: IconButton(
                                  //         onPressed: () async {
                                  //           // File editedFile = await Navigator
                                  //           //     .of(context)
                                  //           //     .push(MaterialPageRoute(
                                  //           //     builder: (context) =>
                                  //           //         StoriesEditor(
                                  //           //           // fontFamilyList: font_family,
                                  //           //           giphyKey: '',
                                  //           //           onDone:
                                  //           //               (String) {},
                                  //           //           // filePath:
                                  //           //           //     imgFile!.path,
                                  //           //         )));
                                  //           // if (editedFile != null) {
                                  //           //   print(
                                  //           //       'editedFile: ${editedFile.path}');
                                  //           // }
                                  //         },
                                  //         icon: Icon(
                                  //           Icons.add,
                                  //           color: HexColor(
                                  //               CommonColor.pinkFont),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     Text(
                                  //       'Add Story',
                                  //       style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontFamily: 'PR',
                                  //           fontSize: 12),
                                  //     )
                                  //   ],
                                  // ),
                                  (story_info.length > 0 ?
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
                                                      // view_story(
                                                      //     story_id: story_info[index]
                                                      //         .stID!);
                                                      print(index);
                                                      story_info =
                                                      getStoryModel!
                                                          .data![index].storys!;

                                                      Get.to(() =>
                                                          StoryScreen(
                                                            thumbnail: test_thumb[index],
                                                            stories:
                                                            story_info,
                                                            story_no:
                                                            index,
                                                            stories_title: story_,
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
                                                          child: Image.file(
                                                              test_thumb[index])
                                                        // FadeInImage
                                                        //     .assetNetwork(
                                                        //   fit: BoxFit
                                                        //       .cover,
                                                        //   image: "${URLConstants.base_data_url}images/${story_[index].storys![0].storyPhoto}",
                                                        //   placeholder: 'assets/images/Funky_App_Icon.png',
                                                        //   // color: HexColor(CommonColor.pinkFont),
                                                        // ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 0,
                                                  ),
                                                  // Text(
                                                  //   '${story_info[index].title}',
                                                  //   style: TextStyle(
                                                  //       color:
                                                  //       Colors.white,
                                                  //       fontFamily: 'PR',
                                                  //       fontSize: 14),
                                                  // )
                                                  Container(
                                                    height: 20,
                                                    width: 40,
                                                    child: Marquee(
                                                      text: '${story_[index]
                                                          .title}',
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontFamily: 'PR',
                                                          fontSize: 14),
                                                      scrollAxis: Axis
                                                          .horizontal,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      blankSpace: 20.0,
                                                      velocity: 30.0,
                                                      pauseAfterRound: Duration(
                                                          milliseconds: 100),
                                                      startPadding: 10.0,
                                                      accelerationDuration: Duration(
                                                          seconds: 1),
                                                      accelerationCurve: Curves
                                                          .easeIn,
                                                      decelerationDuration: Duration(
                                                          microseconds: 500),
                                                      decelerationCurve: Curves
                                                          .easeOut,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  )
                                      : Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                      child: Text(
                                        'No Stories available',
                                        style: TextStyle(color: Colors.white,
                                            fontFamily: 'PR',
                                            fontSize: 16),
                                      )))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              color: HexColor(CommonColor.pinkFont)
                                  .withOpacity(0.7),
                              height: 0.5,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                            ),
                          ],
                        ),
                      )),
                  bottom: TabBar(
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    tabs: _tabs,
                  )),
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
        )));
  }

  bool isvideoLoading = true;
  VideoModelList? _videoModelList;
  List<File> imgFile_list = [];

  Future<dynamic> get_video_list(BuildContext context) async {
    setState(() {
      isvideoLoading = true;
    });
    // showLoader(context);

    String id_user =
    _search_screen_controller.userInfoModel_email!.data![0].id!;

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
        // CommonWidget().showToaster(msg: 'Succesful');
        print(_videoModelList);
        setState(() {
          isvideoLoading = false;
        });
        print(_videoModelList!.data![index].image!.length);

        // for (int i = 0; i < _videoModelList!.data!.length; i++) {
        //   final uint8list = await VideoThumbnail.thumbnailFile(
        //     video:
        //     ("http://foxyserver.com/funky/video/${_videoModelList!.data![i].uploadVideo}"),
        //     thumbnailPath: (await getTemporaryDirectory()).path,
        //     imageFormat: ImageFormat.JPEG,
        //     maxHeight: 64,
        //     // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        //     quality: 75,
        //   );
        //   imgFile_list.add(File(uint8list!));
        //   // print(test_thumb[i].path);
        //   setState(() {
        //     isvideoLoading = false;
        //   });
        //   print("test----------${imgFile_list[i].path}");
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: HexColor(CommonColor.pinkFont), width: 0.5)),
                    height: 120.0,
                    // width: 120.0,
                    child: (isvideoLoading == true
                        ? CircularProgressIndicator(
                      color: HexColor(CommonColor.pinkFont),
                    )
                        : (_videoModelList!.data![index].image!.isEmpty
                        ? Image.asset(AssetUtils.logo)
                        : GestureDetector(
                      onTap: () {
                        print('data');
                        Get.to(VideoViewer(
                          url: _videoModelList!
                              .data![index].uploadVideo!,
                        ));
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            '${URLConstants
                                .base_data_url}images/${_videoModelList!
                                .data![index].image}',
                            fit: BoxFit.contain,
                          ),
                          // Icon(Icons.play_circle,
                          //   color: HexColor(CommonColor.pinkFont),)
                        ],
                      ),
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
                        : (_galleryModelList!
                        .data![index].postImage!.isEmpty
                        ? Image.asset(AssetUtils.logo)
                        : Image.network(
                      '${URLConstants.base_data_url}images/${_galleryModelList!
                          .data![index].postImage}',
                      loadingBuilder:
                          (context, child, loadingProgress) {
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

  bool ispostLoading = true;
  GalleryModelList? _galleryModelList;

  Future<dynamic> get_gallery_list(BuildContext context) async {
    setState(() {
      ispostLoading = true;
    });
    // showLoader(context);

    String id_user =
    _search_screen_controller.userInfoModel_email!.data![0].id!;

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
      print(_galleryModelList);
      if (_galleryModelList!.error == false) {
        CommonWidget().showToaster(msg: 'Data Found');
        print("_galleryModelList!.error ${_galleryModelList!.error}");
        setState(() {
          ispostLoading = false;
        });
        print(_galleryModelList!.data![index].image!.length);

        // hideLoader(context);
        // Get.to(Dashboard());
      } else {
        setState(() {
          ispostLoading = false;
        });
        CommonWidget().showErrorToaster(msg: 'No Data found');

        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  bool isStoryLoading = true;
  GetStoryModel? getStoryModel;
  List<Storys> story_info = [];
  List<Data_story> story_ = [];

  // List<String> thumb = [];
  // String? filePath;
  List<File> test_thumb = [];

  Future<dynamic> get_story_list() async {
    print('Inside creator get email');
    setState(() {
      isStoryLoading = true;
    });
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $id_user");
    String url =
    ("${URLConstants.base_url}${URLConstants.StoryGetApi}?userId=${widget
        .search_user_data.id}");
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
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getStoryModel!
                .data!.length}');
        story_ = getStoryModel!.data!;
        story_info = getStoryModel!.data![0].storys!;
        for (int i = 0; i < story_info.length; i++) {
          if (story_info[i].isVideo == 'true') {
            final uint8list = await VideoThumbnail.thumbnailFile(
              video:
              ("${URLConstants.base_data_url}images/${story_info[i]
                  .storyPhoto}"),
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.JPEG,
              maxHeight: 64,
              // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
              quality: 75,
            );
            test_thumb.add(File(uint8list!));
            print("test_thumb[i].path");
            print(test_thumb[i].path);
          } else if (story_info[i].isVideo == 'false') {
            test_thumb.add(File(story_info[i].storyPhoto!));
            // print(story_info[i].image);
          }
          print("test----------${test_thumb[i].path}");
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


}
