import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../custom_widget/common_buttons.dart';

class ImageWidget extends StatefulWidget {
  final String useerName;
  final String Imageurl;

  final String SocialProfileUrl;
  final String ProfileUrl;
  final String description;

  const ImageWidget(
      {Key? key,
      required this.useerName,
      required this.Imageurl,
      required this.ProfileUrl,
      required this.description,
      required this.SocialProfileUrl})
      : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _onTouch = false;
  Timer? _timer;
  bool isClicked = false; // boolean that states if the button is pressed or not

  @override
  void initState() {
    super.initState();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: InkWell(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  // margin: const EdgeInsets.symmetric(vertical: 100),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: (widget.Imageurl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              'http://foxyserver.com/funky/images/${widget.Imageurl}',
                          placeholder: (context, url) => Center(
                            child: Container(
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new CircularProgressIndicator(
                                    color: HexColor(CommonColor.pinkFont),
                                    strokeWidth: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                          fit: BoxFit.fitWidth,
                        )
                      : Image.asset(AssetUtils.logo)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HexColor("#000000").withOpacity(0.9),
                        HexColor("#000000").withOpacity(0.3),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0),
                        HexColor("#000000").withOpacity(0.3),
                        HexColor("#000000").withOpacity(0.9),
                      ],
                    ),
                  ),
                ),

                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.red,
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       // stops: [0.1, 0.5, 0.7, 0.9],
                //       colors: [
                //         HexColor("#000000"),
                //         HexColor("#000000").withOpacity(0.7),
                //         HexColor("#000000").withOpacity(0.3),
                //         Colors.transparent
                //       ],
                //     ),
                //   ),
                //   alignment: Alignment.topCenter,
                //   height: MediaQuery.of(context).size.height/5,
                // ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    child: Container(
                      // color: Colors.red,
                      margin: const EdgeInsets.only(bottom: 20, left: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              child: Container(
                                color: Colors.transparent,
                                width: 50,
                                margin: const EdgeInsets.only(bottom: 0, right: 21),
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      child: IconButton(
                                          padding: const EdgeInsets.only(left: 28.0),
                                          icon: Image.asset(
                                            AssetUtils.like_icon,
                                            color: Colors.white,
                                            height: 30,
                                            width: 30,
                                          ),
                                          onPressed: () {}),
                                    ),
                                    Container(
                                      child: IconButton(
                                        iconSize: 30.0,
                                        padding: const EdgeInsets.only(left: 28.0),
                                        icon: Image.asset(
                                          AssetUtils.comment_icon,
                                          color: HexColor('#8AFC8D'),
                                          height: 30,
                                          width: 30,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // _myPage.jumpToPage(0);
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        iconSize: 30.0,
                                        padding: const EdgeInsets.only(left: 28.0),
                                        icon: Image.asset(
                                          AssetUtils.share_icon,
                                          color: HexColor('#66E4F2'),
                                          height: 30,
                                          width: 30,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // _myPage.jumpToPage(0);
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        iconSize: 30.0,
                                        padding: const EdgeInsets.only(left: 28.0),
                                        icon: Image.asset(
                                          AssetUtils.reward_icon,
                                          color: HexColor('#F32E82'),
                                          height: 30,
                                          width: 30,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // _myPage.jumpToPage(0);
                                          });
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Divider(
                                  color: HexColor('#F32E82'),
                                  height: 10,
                                )),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            visualDensity: const VisualDensity(
                                vertical: -4, horizontal: -4),
                            // tileColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (widget.ProfileUrl.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              color: Colors.red,
                                              child: Image.network(
                                                "http://foxyserver.com/funky/images/${widget.ProfileUrl}",
                                              ),
                                            ),
                                          )
                                        : (widget.SocialProfileUrl.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  color: Colors.red,
                                                  child: Image.network(
                                                    widget.SocialProfileUrl,
                                                  ),
                                                ),
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
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.useerName,
                                          style: TextStyle(
                                              color: HexColor('#D4D4D4'),
                                              fontFamily: "PB",
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: ReadMoreText(
                                            widget.description,
                                            trimLines: 2,
                                            colorClickableText: Colors.grey,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'Show more',
                                            trimExpandedText: 'Show less',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "PR",
                                                fontSize: 12),
                                            moreStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: "PR",
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(5),
                            bottomLeft: const Radius.circular(5)),
                        color: HexColor('#C12265')),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Text(
                        'I AM here',
                        style: TextStyle(
                            color: HexColor('#D4D4D4'),
                            fontFamily: "PR",
                            fontSize: 14),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
