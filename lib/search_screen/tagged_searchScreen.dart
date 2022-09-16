import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/chat_quickblox/main.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import 'discoverFeedScreen.dart';
import 'search__screen_controller.dart';

class TaggedSearchScreen extends StatefulWidget {
  final String Hashtag;

  const TaggedSearchScreen({Key? key, required this.Hashtag}) : super(key: key);

  @override
  State<TaggedSearchScreen> createState() => _TaggedSearchScreenState();
}

class _TaggedSearchScreenState extends State<TaggedSearchScreen> {
  final Search_screen_controller _search_screen_controller = Get.put(
      Search_screen_controller(),
      tag: Search_screen_controller().toString());

  @override
  void initState() {
    _search_screen_controller.getPostByHashtag(hashtag: widget.Hashtag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            widget.Hashtag,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'PB'),
          ),
          centerTitle: false,
          // leadingWidth: 100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0,vertical: 10),
        child: Column(
          children: [
            Obx(() => _search_screen_controller.isPostHashSearchLoading.value ==
                    true
                ? Expanded(
                  child: Center(
                    child: Container(
                        height: 80,
                        width: 100,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        ),
                  ),
                )
                : (_search_screen_controller.hashTagPostModel!.error == true
                    ? Expanded(
                        child: Center(
                            child: Text(
                          'No post available',
                          style:
                              TextStyle(color: Colors.white60, fontFamily: 'PM'),
                        )),
                      )
                    : Expanded(
                        child: StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 20),
                          crossAxisCount: 4,
                          itemCount: _search_screen_controller
                              .hashTagPostModel!.data!.length,
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
                                            .hashTagPostModel!
                                            .data![index]
                                            .isVideo ==
                                        'false'
                                    ? GestureDetector(
                                        onTap: () {
                                          print(_search_screen_controller
                                              .hashTagPostModel!
                                              .data![index]
                                              .iD);
                                          Get.to(DiscoverFeedScreen(
                                            index_: index,
                                            getDiscoverModel:
                                            _search_screen_controller
                                                .hashTagPostModel,
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
                                              "${URLConstants.base_data_url}images/${_search_screen_controller.hashTagPostModel!.data![index].postImage!}",
                                          placeholder:
                                              'assets/images/Funky_App_Icon.png',
                                        ))
                                    : GestureDetector(
                                        onTap: () {

                                          print(_search_screen_controller
                                              .hashTagPostModel!
                                              .data![index]
                                              .iD);
                                          Get.to(DiscoverFeedScreen(
                                            index_: index,
                                            getDiscoverModel:
                                            _search_screen_controller
                                                .hashTagPostModel,
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
                                                      BorderRadius.circular(100)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                      ))),
          ],
        ),
      ),
    );
  }
}
