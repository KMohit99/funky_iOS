import 'package:flutter/material.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import 'controller/news_feed_controller.dart';

class NewsFeedCommantScreen extends StatefulWidget {
  final String newsID;

  const NewsFeedCommantScreen({Key? key, required this.newsID})
      : super(key: key);

  @override
  State<NewsFeedCommantScreen> createState() => _NewsFeedCommantScreenState();
}

class _NewsFeedCommantScreenState extends State<NewsFeedCommantScreen> {
  final NewsFeed_screen_controller _newsFeed_screen_controller = Get.put(
      NewsFeed_screen_controller(),
      tag: NewsFeed_screen_controller().toString());

  @override
  void initState() {
    init();
    focusNode = FocusNode();
    super.initState();
  }

  init() {
    _newsFeed_screen_controller.getNewsFeedCommnets(
        newsfeedID: widget.newsID, context: context);
  }

  FocusNode? focusNode;

  // String replyname = 'a';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _newsFeed_screen_controller.Replyname_controller = '';
        _newsFeed_screen_controller.Replying_comment_id = '';
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Comments",
            style:
                TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'PR'),
          ),
          backgroundColor: Colors.black,
        ),
        body: RefreshIndicator(
          color: HexColor(CommonColor.pinkFont),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            // updateData();
            _newsFeed_screen_controller.getNewsFeedCommnets(
                newsfeedID: widget.newsID, context: context);
            // news_feed_controller.getAllNewsFeedList();

            print("object");
          },
          child: Obx(() => _newsFeed_screen_controller.iscommentsLoading.value !=
                  true
              ? Container(
                  height: double.maxFinite,
                  child: Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _newsFeed_screen_controller
                            .newsFeedCommnetModel!.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Container(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: (_newsFeed_screen_controller
                                                .newsFeedCommnetModel!
                                                .data![index]
                                                .user!
                                                .profileUrl!
                                                .isNotEmpty
                                            ? Image.network(
                                                _newsFeed_screen_controller
                                                    .newsFeedCommnetModel!
                                                    .data![index]
                                                    .user!
                                                    .profileUrl!,
                                                fit: BoxFit.fill,
                                              )
                                            : (_newsFeed_screen_controller
                                                    .newsFeedCommnetModel!
                                                    .data![index]
                                                    .user!
                                                    .image!
                                                    .isNotEmpty
                                                ? Image.network(
                                                    "${URLConstants.base_data_url}images/${_newsFeed_screen_controller.newsFeedCommnetModel!.data![index].user!.image!}",
                                                    fit: BoxFit.fill,
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
                                                    )))))),
                                title: Text(
                                  _newsFeed_screen_controller
                                      .newsFeedCommnetModel!
                                      .data![index]
                                      .userName!,
                                  style: TextStyle(
                                      color: HexColor(CommonColor.subHeaderColor),
                                      fontSize: 14,
                                      fontFamily: 'PR'),
                                ),
                                subtitle: Text(
                                  _newsFeed_screen_controller
                                      .newsFeedCommnetModel!
                                      .data![index]
                                      .message!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'PM'),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await _newsFeed_screen_controller
                                            .CommentLikeUnlikeApi(
                                                context: context,
                                                comment_id:
                                                    _newsFeed_screen_controller
                                                        .newsFeedCommnetModel!
                                                        .data![index]
                                                        .neID!,
                                                comment_likeStatus:
                                                    (_newsFeed_screen_controller
                                                                .newsFeedCommnetModel!
                                                                .data![index]
                                                                .likeStatus ==
                                                            'true'
                                                        ? 'false'
                                                        : 'true'),
                                                comment_type:
                                                    (_newsFeed_screen_controller
                                                                .newsFeedCommnetModel!
                                                                .data![index]
                                                                .likeStatus ==
                                                            'true'
                                                        ? 'unliked'
                                                        : 'liked'),
                                                news_id: widget.newsID);

                                        if (_newsFeed_screen_controller
                                                .commentLikeUnlikeModel!.error ==
                                            false) {
                                          print(
                                              "vvvv${_newsFeed_screen_controller.newsFeedCommnetModel!.data![index].likeCount!}");

                                          setState(() {
                                            _newsFeed_screen_controller
                                                    .newsFeedCommnetModel!
                                                    .data![index]
                                                    .likeCount =
                                                _newsFeed_screen_controller
                                                    .commentLikeUnlikeModel!
                                                    .user![0]
                                                    .likeCount!;

                                            _newsFeed_screen_controller
                                                    .newsFeedCommnetModel!
                                                    .data![index]
                                                    .likeStatus =
                                                _newsFeed_screen_controller
                                                    .commentLikeUnlikeModel!
                                                    .user![0]
                                                    .likeStatus!;
                                          });
                                          print(
                                              "mmmm${_newsFeed_screen_controller.newsFeedCommnetModel!.data![index].likeCount!}");
                                        }
                                      },
                                      child: Image.asset(
                                        (_newsFeed_screen_controller
                                                    .newsFeedCommnetModel!
                                                    .data![index]
                                                    .likeStatus! ==
                                                'true'
                                            ? AssetUtils.like_icon_filled
                                            : AssetUtils.like_icon),
                                        color: HexColor(CommonColor.pinkFont),
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _newsFeed_screen_controller
                                          .newsFeedCommnetModel!
                                          .data![index]
                                          .likeCount!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'PR'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                            "name : ${_newsFeed_screen_controller.Replyname_controller.length}");
                                        print(
                                            "id : ${_newsFeed_screen_controller.Replying_comment_id.length}");
                                        _newsFeed_screen_controller
                                                .Replyname_controller =
                                            _newsFeed_screen_controller
                                                .newsFeedCommnetModel!
                                                .data![index]
                                                .userName!;
                                        _newsFeed_screen_controller
                                                .Replying_comment_id =
                                            _newsFeed_screen_controller
                                                .newsFeedCommnetModel!
                                                .data![index]
                                                .neID!;
                                        print(
                                            "name : ${_newsFeed_screen_controller.Replyname_controller}");
                                        print(
                                            "id : ${_newsFeed_screen_controller.Replying_comment_id}");
                                        FocusScope.of(context)
                                            .requestFocus(focusNode);
                                      },
                                      child: Text(
                                        'reply',
                                        style: TextStyle(
                                            color: HexColor(
                                                CommonColor.subHeaderColor),
                                            fontSize: 14,
                                            fontFamily: 'PR'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                alignment: Alignment.centerRight,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _newsFeed_screen_controller
                                        .newsFeedCommnetModel!
                                        .data![index]
                                        .replies!
                                        .length,
                                    itemBuilder: (BuildContext context, int idx) {
                                      return ListTile(
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: 0),
                                        leading: Container(
                                            height: 40,
                                            width: 40,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: (_newsFeed_screen_controller
                                                        .newsFeedCommnetModel!
                                                        .data![index]
                                                        .replies![idx]
                                                        .user!
                                                        .profileUrl!
                                                        .isNotEmpty
                                                    ? Image.network(
                                                        _newsFeed_screen_controller
                                                            .newsFeedCommnetModel!
                                                            .data![index]
                                                            .replies![idx]
                                                            .user!
                                                            .profileUrl!,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : (_newsFeed_screen_controller
                                                            .newsFeedCommnetModel!
                                                            .data![index]
                                                            .replies![idx]
                                                            .user!
                                                            .image!
                                                            .isNotEmpty
                                                        ? Image.network(
                                                            "${URLConstants.base_data_url}images/${_newsFeed_screen_controller.newsFeedCommnetModel!.data![index].replies![idx].user!.image!}",
                                                            fit: BoxFit.fill,
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
                                                            )))))),
                                        title: Text(
                                          _newsFeed_screen_controller
                                              .newsFeedCommnetModel!
                                              .data![index]
                                              .replies![idx]
                                              .user!
                                              .userName!,
                                          style: TextStyle(
                                              color: HexColor(
                                                  CommonColor.subHeaderColor),
                                              fontSize: 14,
                                              fontFamily: 'PR'),
                                        ),
                                        subtitle: Text(
                                          _newsFeed_screen_controller
                                              .newsFeedCommnetModel!
                                              .data![index]
                                              .replies![idx]
                                              .comment!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'PM'),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await _newsFeed_screen_controller.CommentReplyLikeUnlikeApi(
                                                    context: context,
                                                    comment_id:
                                                        _newsFeed_screen_controller
                                                            .newsFeedCommnetModel!
                                                            .data![index]
                                                            .replies![idx]
                                                            .nfID!,
                                                    comment_likeStatus:
                                                        (_newsFeed_screen_controller
                                                                    .newsFeedCommnetModel!
                                                                    .data![index]
                                                                    .replies![idx]
                                                                    .likeStatus! ==
                                                                'true'
                                                            ? 'false'
                                                            : 'true'),
                                                    comment_type:
                                                        (_newsFeed_screen_controller
                                                                    .newsFeedCommnetModel!
                                                                    .data![index]
                                                                    .replies![idx]
                                                                    .likeStatus! ==
                                                                'true'
                                                            ? 'unliked'
                                                            : 'liked'),
                                                    news_id: widget.newsID);

                                                if (_newsFeed_screen_controller
                                                        .commentReplyLikeUnlikeModel!
                                                        .error ==
                                                    false) {
                                                  print(
                                                      "vvvv${_newsFeed_screen_controller.newsFeedCommnetModel!.data![index].replies![idx].likeStatus!}");

                                                  setState(() {
                                                    _newsFeed_screen_controller
                                                            .newsFeedCommnetModel!
                                                            .data![index]
                                                            .replies![idx]
                                                            .likeCount =
                                                        _newsFeed_screen_controller
                                                            .commentReplyLikeUnlikeModel!
                                                            .user![0]
                                                            .likeCount!;

                                                    _newsFeed_screen_controller
                                                            .newsFeedCommnetModel!
                                                            .data![index]
                                                            .replies![idx]
                                                            .likeStatus =
                                                        _newsFeed_screen_controller
                                                            .commentReplyLikeUnlikeModel!
                                                            .user![0]
                                                            .likeStatus!;
                                                  });
                                                  print(
                                                      "mmmm${_newsFeed_screen_controller.newsFeedCommnetModel!.data![index].replies![idx].likeStatus}");
                                                }
                                              },
                                              child: Image.asset(
                                                (_newsFeed_screen_controller
                                                            .newsFeedCommnetModel!
                                                            .data![index]
                                                            .replies![idx]
                                                            .likeStatus! ==
                                                        'true'
                                                    ? AssetUtils.like_icon_filled
                                                    : AssetUtils.like_icon),
                                                color: HexColor(
                                                    CommonColor.pinkFont),
                                                height: 15,
                                                width: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              _newsFeed_screen_controller
                                                  .newsFeedCommnetModel!
                                                  .data![index]
                                                  .replies![idx]
                                                  .likeCount!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'PR'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                      ),
                      Container(
                        child: Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black,
                              child: Container(
                                height: 45,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 1.3,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: HexColor(CommonColor.pinkFont),
                                            width: 1),
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                      child: TextFormField(
                                        focusNode: focusNode,
                                        // onChanged: onChanged,
                                        // enabled: enabled,
                                        // validator: validator,
                                        // maxLines: maxLines,
                                        // onTap: tap,
                                        // obscureText: isObscure ?? false,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 20, top: 14, bottom: 14),
                                          alignLabelWithHint: false,
                                          isDense: true,
                                          hintText: 'Write Comment...',
                                          filled: true,
                                          border: InputBorder.none,
                                          // errorText: errorText,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),

                                          // focusedBorder: OutlineInputBorder(
                                          //   borderSide:
                                          //   BorderSide(color: ColorUtils.blueColor, width: 1),
                                          //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                          // ),
                                          prefixText:
                                              "@${_newsFeed_screen_controller.Replyname_controller}",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'PR',
                                            color: Colors.grey,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'PR',
                                          color: Colors.white,
                                        ),
                                        controller: _newsFeed_screen_controller
                                            .comment_controller,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        (_newsFeed_screen_controller
                                                    .Replyname_controller
                                                    .isNotEmpty &&
                                                _newsFeed_screen_controller
                                                    .Replying_comment_id
                                                    .isNotEmpty
                                            ? _newsFeed_screen_controller
                                                .ReplyCommentPostApi(
                                                context: context,
                                                news_id: widget.newsID,
                                              )
                                            : _newsFeed_screen_controller
                                                .CommentPostApi(
                                                    post_id: widget.newsID,
                                                    news_id: widget.newsID,
                                                    context: context));
                                      },
                                      child: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                      height: 80,
                      width: 100,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                )),
        ),
      ),
    );
  }
}
