import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/search_screen/model/searchModel.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';
import 'package:funky_new/search_screen/search_screen_user_profile.dart';
import 'package:funky_new/search_screen/tagged_searchScreen.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
// import 'package:funky_project/search_screen/searchModel.dart';
// import 'package:funky_project/search_screen/search__screen_controller.dart';
// import 'package:funky_project/search_screen/search_screen_user_profile.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_appbar.dart';
import '../Utils/custom_textfeild.dart';
import '../chat_quickblox/bloc/dialogs/dialogs_screen_bloc.dart';
import '../chat_quickblox/bloc/dialogs/dialogs_screen_events.dart';
import '../chat_quickblox/bloc/dialogs/dialogs_screen_states.dart';
import '../chat_quickblox/presentation/screens/base_screen_state.dart';
import '../drawerScreen.dart';
import 'discoverFeedScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseScreenState<DialogsScreenBloc> {
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
    bloc?.events?.add(ModeDeleteChatsEvent());
    super.initState();
  }

  init() {
    _search_screen_controller.getDiscoverFeed();
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
    initBloc(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,

        // resizeToAvoidBottomInset: false,'
        drawer: DrawerScreen(),
        // appBar: CustomAppbar(
        //   lable_tex: 'Discover',
        //   // ondrawertap: (){
        //   //   _globalKey!.currentState!.openDrawer();
        //   // },
        // ),
        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            // updateData();
            _search_screen_controller.getDiscoverFeed();

            print("object");
          },
          child: Container(
            margin: const EdgeInsets.only(top: 80, left: 23, right: 23),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: CommonTextFormField_search(
                        icon_color: Colors.black,
                        Font_color: Colors.black,
                        iconData: Icons.clear,
                        color: Colors.white,
                        controller: _search_screen_controller.searchquery,
                        labelText: "Search",
                        tap: () {
                          setState(() {
                            _search_screen_controller.taxfeildTapped(true);
                          });
                        },
                        onpress: () {
                          setState(() {
                            _search_screen_controller.searchquery.clear();
                          });
                        },
                        onChanged: (dynamic) {
                          print(dynamic[0]);

                          if (dynamic[0] == '#') {
                            setState(() {
                              _search_screen_controller.getHashtagList(
                                  hashtag: dynamic);
                            });
                          } else {
                            setState(() {
                              _search_screen_controller.getUserList();
                            });
                          }
                        },
                      )),
                      Container(
                        // color: Colors.red,
                        margin: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                        child: IconButton(
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: (Image.asset(
                              AssetUtils.filter_icon,
                              color: HexColor(CommonColor.pinkFont),
                              height: 19.0,
                              width: 19.0,
                              fit: BoxFit.contain,
                            ))),
                      ),
                    ],
                  ),
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
                (_search_screen_controller.searchquery.text.isNotEmpty
                    ? (_search_screen_controller.searchquery.text[0] == '#'
                        ? (_search_screen_controller.hashTagSearchModel == null
                            ? SizedBox.shrink()
                            : Expanded(
                                child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 50),
                                shrinkWrap: true,
                                itemCount: _search_screen_controller
                                    .hashTagSearchModel!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    visualDensity:
                                        VisualDensity(vertical: 2, horizontal: 0),
                                    onTap: () {
                                      print(_search_screen_controller
                                          .hashTagSearchModel!
                                          .data![index]
                                          .tagName!);
                                      Get.to(TaggedSearchScreen(
                                          Hashtag: _search_screen_controller
                                              .hashTagSearchModel!
                                              .data![index]
                                              .tagName!));
                                    },
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: const Alignment(-1.0, 0.0),
                                              end: const Alignment(1.0, 0.0),
                                              transform: const GradientRotation(
                                                  0.7853982),
                                              // stops: [0.1, 0.5, 0.7, 0.9],
                                              colors: [
                                                HexColor("#000000"),
                                                Colors.pink,
                                                // HexColor("#FFFFFF").withOpacity(0.67),
                                              ],
                                            ),
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(26.0))),
                                        child: Center(
                                          child: Text(
                                            '#',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _search_screen_controller
                                          .hashTagSearchModel!
                                          .data![index]
                                          .tagName!,
                                      style: const TextStyle(
                                          color: Colors.white, fontFamily: 'PR'),
                                    ),
                                  );
                                },
                              )))
                        : (_search_screen_controller.searchlistModel == null
                            ? SizedBox.shrink()
                            : Expanded(
                                child: StreamProvider<DialogsScreenStates>(
                                create: (context) => bloc?.states?.stream
                                    as Stream<DialogsScreenStates>,
                                initialData: ChatConnectingState(),
                                child: Selector<DialogsScreenStates,
                                    DialogsScreenStates>(
                                  selector: (_, state) => state,
                                  shouldRebuild: (previous, next) {
                                    return next is UpdateChatsSuccessState;
                                  },
                                  builder: (_, state, __) {
                                    if (state is UpdateChatsSuccessState) {
                                      List<QBDialog?> dialogs = state.dialogs;
                                      return ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 50),
                                        shrinkWrap: true,
                                        itemCount: _search_screen_controller
                                            .searchlistModel!.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            onTap: () {
                                              String id =
                                                  _search_screen_controller
                                                      .searchlistModel!
                                                      .data![index]
                                                      .id!;
                                              String username =
                                                  _search_screen_controller
                                                      .searchlistModel!
                                                      .data![index]
                                                      .userName!;

                                              print("id $id");

                                              Data_searchApi last_out =
                                                  _search_screen_controller
                                                      .searchlistModel!.data!
                                                      .firstWhere((element) =>
                                                          element.id == id);
                                              Data_searchApi blahh = last_out;

                                              // QBDialog? qb_user =
                                              //     dialogs.firstWhere((element) =>
                                              //         element!.name == username);
                                              // if (qb_user == null) {
                                              //   print("no data found");
                                              // } else {
                                              //   print(
                                              //       "quickblox username ${qb_user.name}");
                                              //   print(
                                              //       "quickblox id ${qb_user.id}");
                                              // }
                                              // print("blahhh id ${blahh.id}");
                                              //
                                              // print(_search_screen_controller
                                              //     .searchlistModel!
                                              //     .data![index]
                                              //     .id);
                                              //
                                              // print(dialogs);
                                              Get.to(SearchUserProfile(
                                                // quickBlox_id: qb_user!.id!,
                                                quickBlox_id: "0",
                                                // UserId: _search_screen_controller
                                                //     .searchlistModel!.data![index].id!,
                                                search_user_data: blahh,
                                              ));
                                            },
                                            leading: Container(
                                              height: 50,
                                              width: 50,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: (_search_screen_controller
                                                        .searchlistModel!
                                                        .data![index]
                                                        .profileUrl!
                                                        .isNotEmpty
                                                    ? Image.asset(
                                                        'assets/images/Funky_App_Icon.png')
                                                    // FadeInImage.assetNetwork(
                                                    //         height: 80,
                                                    //         width: 80,
                                                    //         fit: BoxFit.cover,
                                                    //         placeholder:
                                                    //             'assets/images/Funky_App_Icon.png',
                                                    //         image: _search_screen_controller
                                                    //             .searchlistModel!
                                                    //             .data![index]
                                                    //             .profileUrl!,
                                                    //       )
                                                    :
                                                    // Container(
                                                    //   height: 50,
                                                    //   width: 50,
                                                    //   child: ClipRRect(
                                                    //     borderRadius: BorderRadius.circular(50),
                                                    //     child: Image.network(
                                                    //       _search_screen_controller
                                                    //           .searchlistModel!
                                                    //           .data![index]
                                                    //           .profileUrl!, fit: BoxFit.fill,),
                                                    //   ),
                                                    // )
                                                    (_search_screen_controller
                                                            .searchlistModel!
                                                            .data![index]
                                                            .image!
                                                            .isNotEmpty
                                                        ? FadeInImage
                                                            .assetNetwork(
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.cover,
                                                            image:
                                                                "${URLConstants.base_data_url}images/${_search_screen_controller.searchlistModel!.data![index].image!}",
                                                            placeholder:
                                                                'assets/images/Funky_App_Icon.png',
                                                          )
                                                        : Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: IconButton(
                                                              icon: Image.asset(
                                                                AssetUtils
                                                                    .user_icon3,
                                                                fit: BoxFit.fill,
                                                              ),
                                                              onPressed: () {},
                                                            )))),
                                              ),
                                            ),
                                            title: Text(
                                              _search_screen_controller
                                                  .searchlistModel!
                                                  .data![index]
                                                  .fullName!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'PR'),
                                            ),
                                            subtitle: Text(
                                              _search_screen_controller
                                                  .searchlistModel!
                                                  .data![index]
                                                  .userName!,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'PR'),
                                            ),
                                          );
                                        },
                                      );
                                    }

                                    return Text('');
                                  },
                                ),
                              ))))
                    : Obx(() => _search_screen_controller
                                .isDiscoverLoading.value ==
                            true
                        ? Container(
                            height: 80,
                            width: 100,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                            )
                        : Expanded(
                            child: Container(
                              child: StaggeredGridView.countBuilder(
                                shrinkWrap: true,

                                padding: EdgeInsets.only(top: 20,bottom: 50),
                                crossAxisCount: 4,
                                itemCount: _search_screen_controller
                                    .getDiscoverModel!.data!.length,
                                itemBuilder: (BuildContext context, int index) =>
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                      height: 120.0,
                                      // width: 120.0,
                                      decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //   image: (_search_screen_controller
                                        //               .getDiscoverModel!
                                        //               .data![index]
                                        //               .isVideo ==
                                        //           'false'
                                        //       ? NetworkImage(
                                        //           "${URLConstants.base_data_url}images/${_search_screen_controller.getDiscoverModel!.data![index].postImage!}")
                                        //       : const NetworkImage(
                                        //           "http://foxyserver.com/funky/images/Funky_App_Icon.png")),
                                        //   fit: BoxFit.cover,
                                        // ),
                                        shape: BoxShape.rectangle,
                                      ),
                                      // child: Image.file(_search_screen_controller.test_thumb[index]),
                                      child: (_search_screen_controller
                                                  .getDiscoverModel!
                                                  .data![index]
                                                  .isVideo ==
                                              'false'
                                          ? GestureDetector(
                                              onTap: () {
                                                print(_search_screen_controller
                                                    .getDiscoverModel!
                                                    .data![index]
                                                    .iD);
                                                Get.to(DiscoverFeedScreen(
                                                  index_: index,
                                                  getDiscoverModel:
                                                      _search_screen_controller
                                                          .getDiscoverModel,
                                                ));
                                              },
                                              child:
                                                  // Image.network(
                                                  //   "${URLConstants.base_data_url}images/${_search_screen_controller.getDiscoverModel!.data![index].postImage!}",
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  FadeInImage.assetNetwork(
                                                fit: BoxFit.cover,
                                                image:
                                                    "${URLConstants.base_data_url}images/${_search_screen_controller.getDiscoverModel!.data![index].postImage!}",
                                                placeholder:
                                                    'assets/images/Funky_App_Icon.png',
                                              ))
                                          : GestureDetector(
                                              onTap: () {
                                                print(_search_screen_controller
                                                    .getDiscoverModel!
                                                    .data![index]
                                                    .iD);
                                                Get.to(DiscoverFeedScreen(
                                                  index_: index,
                                                  getDiscoverModel:
                                                      _search_screen_controller
                                                          .getDiscoverModel,
                                                ));
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Positioned.fill(
                                                    child: Image.network(
                                                      "http://foxyserver.com/funky/images/Funky_App_Icon.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black54,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                100)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.pink,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))),
                                ),
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.count(2, index.isEven ? 3 : 2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              ),
                            ),
                          ))),

                // Obx(() => (_search_screen_controller.taxfeildTapped == true)
                //     ? (_search_screen_controller.searchlistModel == null
                //         ? SizedBox.shrink()
                //         : Expanded(
                //             child: ListView.builder(
                //             padding: EdgeInsets.all(0),
                //             shrinkWrap: true,
                //             itemCount: _search_screen_controller
                //                 .searchlistModel!.data!.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               return Container(
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10),
                //                     border: Border.all(
                //                         color: HexColor(CommonColor.pinkFont),
                //                         width: 1)),
                //                 margin: EdgeInsets.symmetric(
                //                     vertical: 10, horizontal: 10),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Row(
                //                     children: [
                //                       (_search_screen_controller.searchlistModel!
                //                               .data![index].profileUrl!.isNotEmpty
                //                           ? Container(
                //                               height: 50,
                //                               width: 50,
                //                               child: ClipRRect(
                //                                 borderRadius: BorderRadius.circular(50),
                //                                 child: Image.network(
                //                                     _search_screen_controller
                //                                         .searchlistModel!
                //                                         .data![index]
                //                                         .profileUrl!),
                //                               ),
                //                             )
                //                           : Container(
                //                         height: 50,
                //                         width: 50,
                //                         child: ClipRRect(
                //                           borderRadius: BorderRadius.circular(50),
                //                         ),
                //                       )),
                //                       Column(
                //                         children: [
                //                           Text(
                //                             _search_screen_controller.searchlistModel!
                //                                 .data![index].fullName!,
                //                             style: TextStyle(color: Colors.white),
                //                           ),
                //                           Text(
                //                             _search_screen_controller.searchlistModel!
                //                                 .data![index].userName!,
                //                             style: TextStyle(color: Colors.white),
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               );
                //             },
                //           )))
                //     : Expanded(
                //         child: GridView.builder(
                //             shrinkWrap: true,
                //             padding: EdgeInsets.zero,
                //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //                 crossAxisCount: 2, childAspectRatio: 2 / 3),
                //             itemCount: image_list.length,
                //             itemBuilder: (BuildContext ctx, index) {
                //               return Container(
                //                 margin: EdgeInsets.all(8),
                //                 child: Image.asset(
                //                   image_list[index],
                //                   fit: BoxFit.contain,
                //                 ),
                //               );
                //             }),
                //       )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // List<QBDialog?> dialogs = [];
  QBDialog? qb;

  StreamProvider get_user() {
    return StreamProvider<DialogsScreenStates>(
      create: (context) => bloc?.states?.stream as Stream<DialogsScreenStates>,
      initialData: ChatConnectingState(),
      child: Selector<DialogsScreenStates, DialogsScreenStates>(
        selector: (_, state) => state,
        shouldRebuild: (previous, next) {
          return next is UpdateChatsSuccessState;
        },
        builder: (_, state, __) {
          if (state is UpdateChatsSuccessState) {
            List<QBDialog?> dialogs = state.dialogs;
            return ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount:
                  _search_screen_controller.searchlistModel!.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    String id = _search_screen_controller
                        .searchlistModel!.data![index].id!;
                    String username = _search_screen_controller
                        .searchlistModel!.data![index].userName!;

                    print("id $id");

                    Data_searchApi last_out = _search_screen_controller
                        .searchlistModel!.data!
                        .firstWhere((element) => element.id == id);
                    Data_searchApi blahh = last_out;

                    QBDialog? qb_user = dialogs
                        .firstWhere((element) => element!.name == username);
                    print("quickblox username ${qb_user!.name}");
                    print("blahhh id ${blahh.id}");

                    print(_search_screen_controller
                        .searchlistModel!.data![index].id);

                    print(dialogs);
                    // Get.to(SearchUserProfile(
                    //   // UserId: _search_screen_controller
                    //   //     .searchlistModel!.data![index].id!,
                    //   search_user_data: blahh,
                    // ));
                  },
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: (_search_screen_controller.searchlistModel!
                              .data![index].profileUrl!.isNotEmpty
                          ? Image.asset('assets/images/Funky_App_Icon.png')
                          // FadeInImage.assetNetwork(
                          //         height: 80,
                          //         width: 80,
                          //         fit: BoxFit.cover,
                          //         placeholder:
                          //             'assets/images/Funky_App_Icon.png',
                          //         image: _search_screen_controller
                          //             .searchlistModel!
                          //             .data![index]
                          //             .profileUrl!,
                          //       )
                          :
                          // Container(
                          //   height: 50,
                          //   width: 50,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(50),
                          //     child: Image.network(
                          //       _search_screen_controller
                          //           .searchlistModel!
                          //           .data![index]
                          //           .profileUrl!, fit: BoxFit.fill,),
                          //   ),
                          // )
                          (_search_screen_controller.searchlistModel!
                                  .data![index].image!.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  image:
                                      "${URLConstants.base_data_url}images/${_search_screen_controller.searchlistModel!.data![index].image!}",
                                  placeholder:
                                      'assets/images/Funky_App_Icon.png',
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  child: IconButton(
                                    icon: Image.asset(
                                      AssetUtils.user_icon3,
                                      fit: BoxFit.fill,
                                    ),
                                    onPressed: () {},
                                  )))),
                    ),
                  ),
                  title: Text(
                    _search_screen_controller
                        .searchlistModel!.data![index].fullName!,
                    style:
                        const TextStyle(color: Colors.white, fontFamily: 'PR'),
                  ),
                  subtitle: Text(
                    _search_screen_controller
                        .searchlistModel!.data![index].userName!,
                    style:
                        const TextStyle(color: Colors.grey, fontFamily: 'PR'),
                  ),
                );
              },
            );
          }
          return Text("");
        },
      ),
    );
  }
}
