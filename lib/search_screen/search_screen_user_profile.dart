import 'dart:convert';
import 'dart:ui';

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

import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../homepage/model/UserInfoModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../profile_screen/model/followUnfollowModel.dart';
import '../profile_screen/model/followersModel.dart';
import '../sharePreference.dart';
import 'Followers_scren.dart';
import 'Following_scren.dart';

class SearchUserProfile extends StatefulWidget {
  final Data_searchApi search_user_data;

  // final String UserId;

  const SearchUserProfile({Key? key, required this.search_user_data})
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
    await getAllFollowersList();
    await getAllFollowingList();
    await _search_screen_controller.compare_data();
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
        body: Obx(() => _search_screen_controller.isuserinfoLoading.value ==
                true
            ? Center(child: CircularProgressIndicator(color: HexColor(CommonColor.pinkFont),))
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
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
                                      '${_search_screen_controller.userInfoModel_email!.data![0].userName}',
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
                                                            left: 150),
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
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    _search_screen_controller.Block_unblock_api(
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
                                                                              Colors.white),
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
                                        height: 100,
                                        // alignment: FractionalOffset.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (_search_screen_controller
                                                      .userInfoModel_email!
                                                      .data![0]
                                                      .fullName!
                                                      .isNotEmpty
                                                  ? '${_search_screen_controller.userInfoModel_email!.data![0].fullName}'
                                                  : 'Please update profile'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: HexColor(
                                                      CommonColor.pinkFont)),
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
                                              '${_search_screen_controller.userInfoModel_email!.data![0].followerNumber}',
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
                                                  Get.to(SearchUserFollowrs(
                                                    searchUserid: widget
                                                        .search_user_data.id!,
                                                  ));
                                                }),
                                            Text(
                                              '${_search_screen_controller.userInfoModel_email!.data![0].followerNumber}',
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
                                                  Get.to(searchUserFollowing(
                                                    searchUserid: widget
                                                        .search_user_data.id!,
                                                  ));
                                                }),
                                            Text(
                                              '${_search_screen_controller.userInfoModel_email!.data![0].followingNumber}',
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
                                                  vertical: -4, horizontal: -4),
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
                                                  vertical: -4, horizontal: -4),
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
                                                  vertical: -4, horizontal: -4),
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
                                          GestureDetector(
                                            onTap: () {
                                              _search_screen_controller.Follow_unfollow_api(
                                                  context: context,
                                                  user_id: widget
                                                      .search_user_data.id,
                                                  user_social: widget
                                                      .search_user_data.type,
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
                                                                          .is_follower ==
                                                                      null &&
                                                                  _search_screen_controller.is_following != null
                                                              ? "unfollow"
                                                              : 'follow'))));
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              // height: 45,
                                              // width:(width ?? 300) ,
                                              decoration: BoxDecoration(
                                                  color: (_search_screen_controller.is_follower != null &&
                                                          _search_screen_controller.is_following !=
                                                              null
                                                      ? Colors.black
                                                      : (_search_screen_controller.is_follower != null && _search_screen_controller.is_following == null
                                                          ? Colors.white
                                                          : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null
                                                              ? Colors.black
                                                              : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .white)))),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: (_search_screen_controller.is_follower != null &&
                                                              _search_screen_controller.is_following !=
                                                                  null
                                                          ? Colors.white
                                                          : (_search_screen_controller.is_follower != null &&
                                                                  _search_screen_controller.is_following == null
                                                              ? HexColor(CommonColor.pinkFont)
                                                              : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following != null ? Colors.white : (_search_screen_controller.is_follower == null && _search_screen_controller.is_following == null ? HexColor(CommonColor.pinkFont) : Colors.white))))),
                                                  borderRadius: BorderRadius.circular(25)),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 15),
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
                                                                : (_search_screen_controller.is_follower ==
                                                                            null &&
                                                                        _search_screen_controller.is_following ==
                                                                            null
                                                                    ? 'Follow'
                                                                    : (_search_screen_controller.is_follower ==
                                                                                null &&
                                                                            _search_screen_controller.is_following !=
                                                                                null
                                                                        ? 'Following'
                                                                        : ''))))),
                                                    style: TextStyle(
                                                        color: (_search_screen_controller
                                                                        .is_follower !=
                                                                    null &&
                                                                _search_screen_controller
                                                                        .is_following !=
                                                                    null
                                                            ? Colors.white
                                                            : (_search_screen_controller
                                                                            .is_follower !=
                                                                        null &&
                                                                    _search_screen_controller
                                                                            .is_following ==
                                                                        null
                                                                ? Colors.black
                                                                : (_search_screen_controller.is_follower ==
                                                                            null &&
                                                                        _search_screen_controller.is_following !=
                                                                            null
                                                                    ? Colors
                                                                        .white
                                                                    : (_search_screen_controller.is_follower ==
                                                                                null &&
                                                                            _search_screen_controller.is_following ==
                                                                                null
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white)))),
                                                        fontFamily: 'PR',
                                                        fontSize: 16),
                                                  )),
                                            ),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  color: HexColor(CommonColor.borderColor),
                                  height: 0.5,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      height: 61,
                                      width: 61,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                                margin: EdgeInsets.all(5),
                                                height: 61,
                                                width: 61,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 3)),
                                                child: IconButton(
                                                  color: Colors.red,
                                                  visualDensity: VisualDensity(
                                                      vertical: -4,
                                                      horizontal: -4),
                                                  onPressed: () {},
                                                  icon: Image.asset(
                                                    Story_img[index],
                                                    fit: BoxFit.fill,
                                                    // color: HexColor(CommonColor.pinkFont),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  ],
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                    color: HexColor(CommonColor.blue),
                                    width: 1.5)),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                    color: HexColor(CommonColor.green),
                                    width: 1.5)),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                    color: HexColor(CommonColor.tile),
                                    width: 1.5)),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                    color: HexColor(CommonColor.orange),
                                    width: 1.5)),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                    color: Colors.white, width: 1.5)),
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

                        (index == 0
                            ? video_screen()
                            : (index == 1
                                ? image_screen()
                                : (index == 2
                                    ? video_screen()
                                    : (index == 3
                                        ? video_screen()
                                        : (index == 4
                                            ? video_screen()
                                            : video_screen()))))),
                      ],
                    ),
                  ),
                ),
              )));
  }

  Widget video_screen() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      itemCount: image_list.length,
      itemBuilder: (BuildContext context, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: new Container(
          height: 120.0,
          // width: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image_list[index]),
              fit: BoxFit.fitWidth,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget image_screen() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      itemCount: image_list.length,
      itemBuilder: (BuildContext context, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: new Container(
          height: 120.0,
          // width: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image_list[index]),
              fit: BoxFit.fitWidth,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget songs_screen() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      itemCount: image_list.length,
      itemBuilder: (BuildContext context, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: new Container(
          height: 120.0,
          // width: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image_list[index]),
              fit: BoxFit.fitWidth,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Future<dynamic> getAllFollowersList() async {
    final books = await _search_screen_controller.getFollowersList();

    setState(
        () => this._search_screen_controller.FollowersData = RxList(books));
    print(_search_screen_controller.FollowersData!.length);
  }

  Future<dynamic> getAllFollowingList() async {
    final books = await _search_screen_controller.getFollowingList();

    setState(
        () => this._search_screen_controller.FollowingData = RxList(books));
    print(_search_screen_controller.FollowingData!.length);
  }
}
