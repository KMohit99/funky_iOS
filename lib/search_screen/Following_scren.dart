import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';
import '../dashboard/dashboard_screen.dart';
import '../homepage/ui/homepage_screen.dart';
import '../profile_screen/model/followersModel.dart';
import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';


class searchUserFollowing extends StatefulWidget {
  final String searchUserid;

  const searchUserFollowing({Key? key, required this.searchUserid}) : super(key: key);

  @override
  State<searchUserFollowing> createState() => _searchUserFollowingState();
}

class _searchUserFollowingState extends State<searchUserFollowing> {
  List image_list = [
    AssetUtils.image1,
    AssetUtils.image2,
    AssetUtils.image3,
    AssetUtils.image4,
    AssetUtils.image5,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
    super.initState();
  }

  init() async {
    await _search_screen_controller.friendSuggestionList(context: context);
    await getAllFollowingList();
  }


  @override
  void dispose() {
    // _search_screen_controller.searchquery.clear();
    super.dispose();
  }

  bool textfeilf_tap = false;
  GlobalKey<ScaffoldState>? _globalKey = GlobalKey<ScaffoldState>();
  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Following',
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
              InkWell(
                child: Padding(
                  padding:
                  const EdgeInsets.only(right: 20.0, top: 0.0, bottom: 5.0),
                  child: ClipRRect(
                    child: Image.asset(
                      AssetUtils.noti_icon,
                      height: 20.0,
                      width: 20.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Padding(
                  padding:
                  const EdgeInsets.only(right: 20.0, top: 0.0, bottom: 5.0),
                  child: ClipRRect(
                    child: Image.asset(
                      AssetUtils.chat_icon,
                      height: 20.0,
                      width: 20.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
        // leadingWidth: 100,
        leading: Container(
          margin: const EdgeInsets.only(left: 15, top: 0, bottom: 0),
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Get.to(Dashboard(page: 0,));
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: HexColor(CommonColor.pinkFont),
              )),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: CommonTextFormField_search(
                      Font_color: Colors.white,
                      icon_color: HexColor(CommonColor.pinkFont),
                      iconData: Icons.search,
                      color: Colors.transparent,
                      controller: _search_screen_controller.searchquery,
                      labelText: "Search",
                      onpress: () {
                        setState(() {
                          _search_screen_controller.searchquery.clear();
                        });
                      },
                      onChanged: (value) {
                        Following_list_search_API(value);
                      },
                    )),
              ],
            ),
            // (_search_screen_controller.searchlistModel != null ?  Expanded(
            //     child: ListView.builder(
            //       shrinkWrap: true,
            //       itemCount: _search_screen_controller
            //           .searchlistModel!.data!.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Row(
            //           children: [
            //             (_search_screen_controller.searchlistModel!
            //                 .data![index].profileUrl!.isNotEmpty
            //                 ? Container(
            //               height: 50,
            //               width: 50,
            //               child: Image.network(
            //                   _search_screen_controller
            //                       .searchlistModel!
            //                       .data![index]
            //                       .profileUrl!),
            //             )
            //                 : SizedBox.shrink()),
            //             Column(
            //               children: [
            //                 Text(
            //                   _search_screen_controller
            //                       .searchlistModel!.data![index].fullName!,
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //                 Text(
            //                   _search_screen_controller
            //                       .searchlistModel!.data![index].userName!,
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         );
            //       },
            //     )): Expanded(
            //   child: GridView.builder(
            //       shrinkWrap: true,
            //       padding: EdgeInsets.zero,
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2, childAspectRatio: 2 / 3),
            //       itemCount: image_list.length,
            //       itemBuilder: (BuildContext ctx, index) {
            //         return Container(
            //           margin: EdgeInsets.all(8),
            //           child: Image.asset(
            //             image_list[index],
            //             fit: BoxFit.contain,
            //           ),
            //         );
            //       }),
            // )),
      Obx(() => _search_screen_controller.isSuggestionLoading.value == true ? SizedBox.shrink() :
            Container(
              height: MediaQuery.of(context).size.height / 3.1,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _search_screen_controller
                    .getFriendSuggestionModel!.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height / 4.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            // stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              HexColor("#000000"),
                              HexColor("#C12265"),
                              HexColor("#C12265"),
                              HexColor("#C12265"),
                              HexColor("#FFFFFF"),
                            ],
                          ),
                        ),
                        margin: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    height: 80,
                                    width: 80,
                                    child: (_search_screen_controller
                                        .getFriendSuggestionModel!
                                        .data![index]
                                        .image!
                                        .isNotEmpty
                                        ?
                                    // Image.network(
                                    //         "${URLConstants.base_data_url}images/${_search_screen_controller.getFriendSuggestionModel!.data![index].image!}",
                                    //         height: 80,
                                    //         width: 80,
                                    //         fit: BoxFit.cover,
                                    //       )
                                    FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      image:
                                      "${URLConstants.base_data_url}images/${_search_screen_controller.getFriendSuggestionModel!.data![index].image!}",
                                      height: 80,
                                      width: 80,

                                      placeholder:
                                      'assets/images/Funky_App_Icon.png',
                                      // color: HexColor(CommonColor.pinkFont),
                                    )
                                        : (_search_screen_controller
                                        .getFriendSuggestionModel!
                                        .data![index]
                                        .profileUrl!
                                        .isNotEmpty
                                        ? Image.network(
                                      _search_screen_controller
                                          .getFriendSuggestionModel!
                                          .data![index]
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
                            Container(
                              child: Text(
                                _search_screen_controller
                                    .getFriendSuggestionModel!
                                    .data![index]
                                    .fullName!,
                                // overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PM',
                                    fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                _search_screen_controller
                                    .getFriendSuggestionModel!
                                    .data![index]
                                    .userName!,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontFamily: 'PM',
                                    fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _search_screen_controller
                                    .Follow_unfollow_api(
                                    follow_unfollow: 'follow',
                                    user_id: _search_screen_controller
                                        .getFriendSuggestionModel!
                                        .data![index]
                                        .id,
                                    user_social: _search_screen_controller
                                        .getFriendSuggestionModel!
                                        .data![index]
                                        .socialType,
                                    context: context);
                                setState(() {
                                  init();
                                });
                              },
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0),
                                    child: Text(
                                      'Follow',
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
                      Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _search_screen_controller
                                    .getFriendSuggestionModel!.data!
                                    .removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            )),
                      )
                    ],
                  );
                },
              ),
            )),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                itemCount: FollowingData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        visualDensity:
                        VisualDensity(vertical: 0, horizontal: -4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                              height: 50,
                              width: 50,
                              child: (FollowingData[index]
                                  .image!
                                  .isNotEmpty
                                  ? Image.network(
                                "${URLConstants.base_data_url}images/${FollowingData[index].image!}",
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                                  : (FollowingData[index]
                                  .profileUrl!
                                  .isNotEmpty
                                  ? Image.network(
                                FollowingData[index]
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
                        title: Text(
                          '${FollowingData[index].fullName}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'PR'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              height: 34,
                              // width:(width ?? 300) ,
                              decoration: BoxDecoration(
                                  color: HexColor(CommonColor.pinkFont),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PR',
                                        fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        color: HexColor(CommonColor.borderColor),
                        height: 0.5,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  RxBool isFollowingLoading = false.obs;
  String query_following = '';
  List<Data_followers> FollowingData = [];

  Future<dynamic> getAllFollowingList() async {
    print('inside following api');
    final books = await getFollowingList(query_following);

    setState(() => this.FollowingData = books);
    print(FollowingData.length);
  }

  Future Following_list_search_API(String query) async {
    final books = await getFollowingList(query);

    if (!mounted) return;

    setState(() {
      this.query_following = query;
      this.FollowingData = books;
    });
  }

   Future<List<Data_followers>> getFollowingList(String query) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ('${URLConstants.base_url}${URLConstants.followingListApi}?id=${widget.searchUserid}');
    http.Response response = await http.get(Uri.parse(url));
    print("response status${response.statusCode}");
    print("response request${response.request}");
    print("response body${response.body}");
    List books = [];
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      books = data["data"];
      print('Books =${books}');
    }
    return books.map((json) => Data_followers.fromJson(json)).where((book) {
      final titleLower = book.userName!.toLowerCase();
      final authorLower = book.fullName!.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.contains(searchLower);
    }).toList();
  }
}

