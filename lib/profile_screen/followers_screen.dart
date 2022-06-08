import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
// import 'package:funky_project/search_screen/search__screen_controller.dart';
// import 'package:funky_project/search_screen/search_screen_user_profile.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_textfeild.dart';
import '../homepage/model/Homepage_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../search_screen/search__screen_controller.dart';
import '../sharePreference.dart';
import 'model/followersModel.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  List image_list = [
    AssetUtils.image1,
    AssetUtils.image2,
    AssetUtils.image3,
    AssetUtils.image4,
    AssetUtils.image5,
  ];
  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await getAllFollowersList();
    await getAllFollowingList();
    await compare_data();
  }

  @override
  void dispose() {
    _search_screen_controller.searchquery.clear();
    super.dispose();
  }

  bool textfeilf_tap = false;
  GlobalKey<ScaffoldState>? _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Followers',
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
        leadingWidth: 100,
        leading: Container(
          margin: const EdgeInsets.only(left: 18, top: 0, bottom: 0),
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back,
                color: HexColor(CommonColor.pinkFont),)
          ),
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
                      icon_color: HexColor(CommonColor.pinkFont),
                      Font_color: Colors.white,
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
                        Followers_list_search_API(value);
                      },
                    )
                ),

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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                itemCount: FollowersData.length,
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
                          '${FollowersData[index].fullName}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'PR'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0),
                              height: 34,
                              // width:(width ?? 300) ,
                              decoration: BoxDecoration(
                                  color: HexColor(CommonColor.pinkFont),
                                  borderRadius:
                                  BorderRadius.circular(17)),
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
          ],
        ),
      ),
    );
  }

  RxBool isfollowersLoading = false.obs;
  String query_followers = '';
  List<Data_followers> FollowersData = [];

  Future<dynamic> getAllFollowersList() async {
    final books = await getFollowersList(query_followers);

    setState(() => this.FollowersData = books);
    print(FollowersData.length);
    // id = await PreferenceManager().getPref(URLConstants.id);
    // print("id $id");
    //
    // isfollowersLoading(true);
    // String url = (URLConstants.base_url + URLConstants.FollowersListApi + '?id=$id');
    //
    // // debugPrint('Get Sales Token ${tokens.toString()}');
    // // try {
    // // } catch (e) {
    // //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // // }
    //
    // http.Response response = await http.get(Uri.parse(url));
    //
    // print('Response request: ${response.request}');
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    //
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   var data = convert.jsonDecode(response.body);
    //   followersModel = FollowersModel.fromJson(data);
    //   getFollowersModelList(followersModel);
    //   if (followersModel!.error == false) {
    //     debugPrint(
    //         '2-2-2-2-2-2 Inside the Followers Controller Details ${followersModel!.data!.length}');
    //     isfollowersLoading(false);
    //     // CommonWidget().showToaster(msg: data["success"].toString());
    //     return followersModel;
    //   } else {
    //     // CommonWidget().showToaster(msg: msg.toString());
    //     return null;
    //   }
    // } else if (response.statusCode == 422) {
    //   // CommonWidget().showToaster(msg: msg.toString());
    // } else if (response.statusCode == 401) {
    //   // CommonService().unAuthorizedUser();
    // } else {
    //   // CommonWidget().showToaster(msg: msg.toString());
    // }
  }

  Future Followers_list_search_API(String query) async {
    final books = await getFollowersList(query);

    if (!mounted) return;

    setState(() {
      this.query_followers = query;
      this.FollowersData = books;
    });
  }

  static Future<List<Data_followers>> getFollowersList(String query) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = (URLConstants.base_url + URLConstants.FollowersListApi +
        '?id=$id_user');
    http.Response response = await http.get(Uri.parse(url));
    print(response);
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

  compare_data() {
    List<Data_followers> output = FollowersData.where((
        element) => !FollowingData.contains(element)).toList();
    print("output $output");
  }

  RxBool isFollowingLoading = false.obs;
  String query_following = '';
  List<Data_followers> FollowingData = [];

  Future<dynamic> getAllFollowingList() async {
    final books = await getFollowingList(query_following);

    setState(() => this.FollowingData = books);
    print(FollowingData.length);
  }

  static Future<List<Data_followers>> getFollowingList(String query) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = (URLConstants.base_url +
        URLConstants.followingListApi +
        '?id=$id_user');
    http.Response response = await http.get(Uri.parse(url));
    print(response);
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
