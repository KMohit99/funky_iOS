import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/profile_screen/profile_screen.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';
import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';
import 'model/followersModel.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List image_list = [
    AssetUtils.image1,
    AssetUtils.image2,
    AssetUtils.image3,
    AssetUtils.image4,
    AssetUtils.image5,
  ];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
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
                // Get.to(Profile_Screen());
                Navigator.pop(context);
                setState((){

                });
              },
              icon: Icon(
                Icons.arrow_back,
                color: HexColor(CommonColor.pinkFont),
              )),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 100, left: 23, right: 23),
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
            (isFollowingLoading == true
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
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
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
                : (FollowingData.length > 0
                ? Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                itemCount: FollowingData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        visualDensity: VisualDensity(
                            vertical: 0, horizontal: -4),
                        leading: Container(
                            height: 50,
                            width: 50,
                            child: IconButton(
                              icon: Image.asset(
                                AssetUtils.user_icon3,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {},
                            )),
                        title: Text(
                          '${FollowingData[index].fullName}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'PR'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                print('${FollowingData[index].id}');
                                await _search_screen_controller.Follow_unfollow_api(
                                    follow_unfollow: 'unfollow',
                                    user_id: FollowingData[index].id,
                                    user_social: FollowingData[index].socialType,
                                    context: context
                                );
                                await getAllFollowingList();
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0),
                                height: 34,
                                // width:(width ?? 300) ,
                                decoration: BoxDecoration(
                                    color: HexColor(
                                        CommonColor.pinkFont),
                                    borderRadius:
                                    BorderRadius.circular(17)),
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 8),
                                    child: Text(
                                      'Unfollow',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'PR',
                                          fontSize: 14),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        color: HexColor(CommonColor.borderColor),
                        height: 0.5,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      ),
                    ],
                  );
                },
              ),
            )
                : Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No Data Found',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PR',
                      fontSize: 16),
                ))))
          ],
        ),
      ),
    );
  }

  bool isFollowingLoading = true;
  String query_following = '';
  List<Data_followers> FollowingData = [];

  Future<dynamic> getAllFollowingList() async {
    print('inside following api');
    setState(() {
      isFollowingLoading = true;
    });
    final books = await getFollowingList(query_following);

    setState(() => this.FollowingData = books);
    print(FollowingData.length);
    setState(() {
      isFollowingLoading = false;
    });
  }

  Future Following_list_search_API(String query) async {
    final books = await getFollowingList(query);

    if (!mounted) return;

    setState(() {
      this.query_following = query;
      this.FollowingData = books;
    });
  }

  static Future<List<Data_followers>> getFollowingList(String query) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = (URLConstants.base_url +
        URLConstants.followingListApi +
        '?id=$id_user');
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
