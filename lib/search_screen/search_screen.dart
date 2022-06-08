import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/search_screen/searchModel.dart';
import 'package:funky_new/search_screen/search__screen_controller.dart';
import 'package:funky_new/search_screen/search_screen_user_profile.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
// import 'package:funky_project/search_screen/searchModel.dart';
// import 'package:funky_project/search_screen/search__screen_controller.dart';
// import 'package:funky_project/search_screen/search_screen_user_profile.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../Utils/custom_appbar.dart';
import '../Utils/custom_textfeild.dart';
import '../drawerScreen.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({Key? key,}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    super.initState();
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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,

        // resizeToAvoidBottomInset: false,'
        drawer: DrawerScreen(),
        appBar: CustomAppbar(
          lable_tex: 'Discover',
          ondrawertap: (){
            _globalKey!.currentState!.openDrawer();
          },
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 100, left: 23, right: 23),
          child: Column(
            children: [
              Row(
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
                      setState(() {
                        _search_screen_controller.getUserList();
                      });
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
                  ? (_search_screen_controller.searchlistModel == null
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: _search_screen_controller
                              .searchlistModel!.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                String id = _search_screen_controller
                                    .searchlistModel!.data![index].id!;
                                print("id $id");

                                Data_searchApi last_out =
                                    _search_screen_controller
                                        .searchlistModel!.data!
                                        .firstWhere(
                                            (element) => element.id == id);
                                Data_searchApi blahh = last_out;

                                print("blahhh id ${blahh.id}");

                                print(_search_screen_controller
                                    .searchlistModel!.data![index].id);
                                Get.to(SearchUserProfile(
                                  // UserId: _search_screen_controller
                                  //     .searchlistModel!.data![index].id!,
                                  search_user_data: blahh,
                                ));
                              },
                              leading: (_search_screen_controller.searchlistModel!
                                      .data![index].profileUrl!.isNotEmpty
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        icon: Image.asset(
                                          AssetUtils.user_icon3,
                                          fit: BoxFit.fill,
                                        ),
                                        onPressed: () {},
                                      ))
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
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        icon: Image.asset(
                                          AssetUtils.user_icon3,
                                          fit: BoxFit.fill,
                                        ),
                                        onPressed: () {},
                                      ))),
                              title: Text(
                                _search_screen_controller
                                    .searchlistModel!.data![index].fullName!,
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'PR'),
                              ),
                              subtitle: Text(
                                _search_screen_controller
                                    .searchlistModel!.data![index].userName!,
                                style: const TextStyle(
                                    color: Colors.grey, fontFamily: 'PR'),
                              ),
                            );
                          },
                        )))
                  : Expanded(
                      child: Container(
                        child: StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 20),
                          crossAxisCount: 4,
                          itemCount: image_list.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
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
                        ),
                      ),
                    )),
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
    );
  }
}
