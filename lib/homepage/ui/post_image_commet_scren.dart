import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../controller/homepage_controller.dart';

class PostImageCommentScreen extends StatefulWidget {
  final String PostID;

  const PostImageCommentScreen({Key? key, required this.PostID})
      : super(key: key);

  @override
  State<PostImageCommentScreen> createState() => _PostImageCommentScreenState();
}

class _PostImageCommentScreenState extends State<PostImageCommentScreen> {
  final HomepageController homepageController =
      Get.put(HomepageController(), tag: HomepageController().toString());
  FocusNode? focusNode;

  @override
  void initState() {
    init();
    focusNode = FocusNode();
    super.initState();
  }

  init() {
    homepageController.Replyname_controller = '';
    homepageController.getPostCommments(
        newsfeedID: widget.PostID, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        homepageController.Replyname_controller = '';
        homepageController.Replying_comment_id = '';
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
        body: Obx(() => homepageController.iscommentsLoading.value != true
            ? Container(
                height: double.maxFinite,
                child: Stack(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount:
                          homepageController.postcommentModel!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Container(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (homepageController
                                              .postcommentModel!
                                              .data![index]
                                              .user!
                                              .profileUrl!
                                              .isNotEmpty
                                          ? Image.network(
                                              homepageController
                                                  .postcommentModel!
                                                  .data![index]
                                                  .user!
                                                  .profileUrl!,
                                              fit: BoxFit.fill,
                                            )
                                          : (homepageController
                                                  .postcommentModel!
                                                  .data![index]
                                                  .user!
                                                  .image!
                                                  .isNotEmpty
                                              ? Image.network(
                                                  "${URLConstants.base_data_url}images/${homepageController.postcommentModel!.data![index].user!.image!}",
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
                                homepageController
                                    .postcommentModel!.data![index].userName!,
                                style: TextStyle(
                                    color: HexColor(CommonColor.subHeaderColor),
                                    fontSize: 14,
                                    fontFamily: 'PR'),
                              ),
                              subtitle: Text(
                                homepageController
                                    .postcommentModel!.data![index].message!,
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
                                      await homepageController
                                          .CommentLikeUnlikeApi(
                                              context: context,
                                              comment_id: homepageController
                                                  .postcommentModel!
                                                  .data![index]
                                                  .cmID!,
                                              comment_likeStatus:
                                                  (homepageController
                                                              .postcommentModel!
                                                              .data![index]
                                                              .likeStatus ==
                                                          'true'
                                                      ? 'false'
                                                      : 'true'),
                                              comment_type: (homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .likeStatus ==
                                                      'true'
                                                  ? 'unliked'
                                                  : 'liked'),
                                              news_id: widget.PostID);

                                      if (homepageController
                                              .postCommentLikeModel!.error ==
                                          false) {
                                        print(
                                            "vvvv${homepageController.postcommentModel!.data![index].likeCount!}");

                                        setState(() {
                                          homepageController.postcommentModel!
                                                  .data![index].likeCount =
                                              homepageController
                                                  .postCommentLikeModel!
                                                  .user![0]
                                                  .likeCount!;

                                          homepageController.postcommentModel!
                                                  .data![index].likeStatus =
                                              homepageController
                                                  .postCommentLikeModel!
                                                  .user![0]
                                                  .likeStatus!;
                                        });
                                        print(
                                            "mmmm${homepageController.postcommentModel!.data![index].likeCount!}");
                                      }
                                    },
                                    child: Image.asset(
                                      (homepageController.postcommentModel!
                                                  .data![index].likeStatus! ==
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
                                    homepageController.postcommentModel!
                                        .data![index].likeCount!,
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
                                          "name : ${homepageController.Replyname_controller.length}");
                                      print(
                                          "id : ${homepageController.Replying_comment_id.length}");
                                      setState(() {
                                        homepageController.Replyname_controller =
                                            homepageController.postcommentModel!
                                                .data![index].userName!;
                                        homepageController.Replying_comment_id =
                                            homepageController.postcommentModel!
                                                .data![index].cmID!;
                                      });
                                      print(
                                          "name : ${homepageController.Replyname_controller}");
                                      print(
                                          "id : ${homepageController.Replying_comment_id}");
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
                                  itemCount: homepageController
                                      .postcommentModel!
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
                                              child: (homepageController
                                                      .postcommentModel!
                                                      .data![index]
                                                      .replies![idx]
                                                      .user!
                                                      .profileUrl!
                                                      .isNotEmpty
                                                  ? Image.network(
                                                      homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .replies![idx]
                                                          .user!
                                                          .profileUrl!,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : (homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .replies![idx]
                                                          .user!
                                                          .image!
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          "https://foxytechnologies.com/funky/images/${homepageController.postcommentModel!.data![index].replies![idx].user!.image!}",
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
                                        homepageController
                                            .postcommentModel!
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
                                        homepageController
                                            .postcommentModel!
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
                                              await homepageController.CommentReplyLikeUnlikeApi(
                                                  context: context,
                                                  comment_id: homepageController
                                                      .postcommentModel!
                                                      .data![index]
                                                      .replies![idx]
                                                      .comId!,
                                                  comment_likeStatus:
                                                      (homepageController
                                                                  .postcommentModel!
                                                                  .data![index]
                                                                  .replies![idx]
                                                                  .likeStatus! ==
                                                              'true'
                                                          ? 'false'
                                                          : 'true'),
                                                  comment_type: (homepageController
                                                              .postcommentModel!
                                                              .data![index]
                                                              .replies![idx]
                                                              .likeStatus! ==
                                                          'true'
                                                      ? 'unliked'
                                                      : 'liked'),
                                                  news_id: widget.PostID);

                                              if (homepageController
                                                      .postCommentReplyLikeModel!
                                                      .error ==
                                                  false) {
                                                print(
                                                    "vvvv${homepageController.postcommentModel!.data![index].replies![idx].likeStatus}");

                                                setState(() {
                                                  homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .replies![idx]
                                                          .likecount =
                                                      homepageController
                                                          .postCommentReplyLikeModel!
                                                          .user![0]
                                                          .likecount!;

                                                  homepageController
                                                          .postcommentModel!
                                                          .data![index]
                                                          .replies![idx]
                                                          .likeStatus =
                                                      homepageController
                                                          .postCommentReplyLikeModel!
                                                          .user![0]
                                                          .likeStatus!;
                                                });
                                                print(
                                                    "mmmmm${homepageController.postcommentModel!.data![index].replies![idx].likeStatus}");
                                              }
                                            },
                                            child: Image.asset(
                                              (homepageController
                                                          .postcommentModel!
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
                                            homepageController
                                                .postcommentModel!
                                                .data![index]
                                                .replies![idx]
                                                .likecount!,
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
                                            "@${homepageController.Replyname_controller}",
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
                                      controller:
                                          homepageController.comment_controller,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      (homepageController.Replyname_controller
                                                  .isNotEmpty &&
                                              homepageController
                                                  .Replying_comment_id
                                                  .isNotEmpty
                                          ? homepageController
                                              .ReplyCommentPostApi(
                                              context: context,
                                              news_id: widget.PostID,
                                            )
                                          : homepageController.CommentPostApi(
                                              post_id: widget.PostID,
                                              news_id: widget.PostID,
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
    );
  }
}
