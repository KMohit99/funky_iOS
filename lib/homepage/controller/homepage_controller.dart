import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Utils/App_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Utils/toaster_widget.dart';
import '../../sharePreference.dart';
import '../model/ImageList_model.dart';
import '../model/Post_comment_like_model.dart';
import '../model/Postcomment_mdoel.dart';
import '../model/VideoList_model.dart';
import '../model/post_comment_reply_like_unlike_model.dart';
import '../model/post_image_comment_post_model.dart';
import '../model/post_like_unlike_model.dart';
import '../model/post_reply_comment_post_model.dart';

class HomepageController extends GetxController {
  bool isPasswordVisible = false;
  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }
  RxBool isVideoLoading = false.obs;
  VideoListModel? videoListModel;
  var getVideoModelList = VideoListModel().obs;

  Future<dynamic> getAllVideosList() async {
    isVideoLoading(true);
    String url = (URLConstants.base_url + URLConstants.VideoListApi);
    String msg = '';

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      videoListModel = VideoListModel.fromJson(data);
      getVideoModelList(videoListModel);
      if (videoListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${videoListModel!.data!.length}');
        isVideoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return videoListModel;
      } else {
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isimageLoading = false.obs;
  ImageListModel? imageListModel;
  var getimageModelList = ImageListModel().obs;

  Future<dynamic> getAllImagesList() async {
    isimageLoading(true);
    String url = (URLConstants.base_url + URLConstants.ImagewListApi);
    String msg = '';

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      imageListModel = ImageListModel.fromJson(data);
      getimageModelList(imageListModel);
      if (imageListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${imageListModel!.data!.length}');
        isimageLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return imageListModel;
      } else {
        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }


  RxBool isLikeLoading = false.obs;
  PostLikeUnlikeModel? postLikeUnlikeModel;

  Future<dynamic> PostLikeUnlikeApi({required BuildContext context,
    required String post_id,
    required String post_id_type,
    required String post_likeStatus}) async {
    debugPrint('0-0-0-0-0-0-0 PostLikeUnlike');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isLikeLoading(true);

    Map data = {
      'userid': id_user,
      'postid': post_id,
      'type': post_id_type,
      'likeStatus': post_likeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.PostLike_Unlike_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      // isLikeLoading(false);
      var data = jsonDecode(response.body);
      postLikeUnlikeModel = PostLikeUnlikeModel.fromJson(data);
      print(postLikeUnlikeModel);
      if (postLikeUnlikeModel!.error == false) {
        CommonWidget().showToaster(msg: postLikeUnlikeModel!.message!);

        // await getAllNewsFeedList();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }


  RxBool iscommentsLoading = true.obs;
  PostCommnetModel? postcommentModel;

  Future<dynamic> getPostCommments(
      {required BuildContext context, required String newsfeedID}) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    iscommentsLoading(true);
    String url =
    ('${URLConstants.base_url}${URLConstants
        .Post_get_Comment_Api}?postid=$newsfeedID');

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    http.Response response = await http.get(Uri.parse(url));

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      postcommentModel = PostCommnetModel.fromJson(data);
      // getVideoModelList(newsfeedModel);
      if (postcommentModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${postcommentModel!
                .data!.length}');
        iscommentsLoading(false);
        CommonWidget().showToaster(msg: postcommentModel!.message!.toString());
        return postcommentModel;
      } else {
        iscommentsLoading(false);
        CommonWidget().showToaster(msg: postcommentModel!.message!);
        return null;
      }
    } else if (response.statusCode == 422) {
      CommonWidget().showToaster(msg: postcommentModel!.message!);
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      CommonWidget().showToaster(msg: postcommentModel!.message!);
    }
  }


  RxBool isCommentLikeLoading = true.obs;
  PostCommentLikeModel? postCommentLikeModel;

  Future<dynamic> CommentLikeUnlikeApi({required BuildContext context,
    required String comment_id,
    required String comment_type,
    required String comment_likeStatus,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isCommentLikeLoading(true);

    Map data = {
      'userId': id_user,
      'likeID': comment_id,
      'comment_type': comment_type,
      'likeStatus': comment_likeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.Post_Comment_like_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      isCommentLikeLoading(false);
      var data = jsonDecode(response.body);
      postCommentLikeModel = PostCommentLikeModel.fromJson(data);
      print(postCommentLikeModel);
      if (postCommentLikeModel!.error == false) {
        CommonWidget().showToaster(msg: postCommentLikeModel!.message!);
        // await getNewsFeedCommnets(newsfeedID: news_id, context: context);
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isCommentReplyLikeLoading = true.obs;
  PostCommentReplyLikeModel? postCommentReplyLikeModel;

  Future<dynamic> CommentReplyLikeUnlikeApi({required BuildContext context,
    required String comment_id,
    required String comment_type,
    required String comment_likeStatus,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isCommentReplyLikeLoading(true);

    Map data = {
      'userId': id_user,
      'likeID': comment_id,
      'comment_type': comment_type,
      'likeStatus': comment_likeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url +
        URLConstants.Post_Comment_reply_like_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      isCommentReplyLikeLoading(false);
      var data = jsonDecode(response.body);
      postCommentReplyLikeModel = PostCommentReplyLikeModel.fromJson(data);
      print(postCommentReplyLikeModel);
      if (postCommentReplyLikeModel!.error == false) {
        CommonWidget().showToaster(msg: postCommentReplyLikeModel!.message!);
        // await getNewsFeedCommnets(newsfeedID: news_id, context: context);
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isCommentPostLoading = true.obs;
  postImageCommentPostModel? postcommentPostModel;
  TextEditingController comment_controller = new TextEditingController();
  String Replyname_controller = '';
  String Replying_comment_id = '';

  Future<dynamic> CommentPostApi({required BuildContext context,
    required String post_id,
    required String news_id,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isCommentPostLoading(true);

    Map data = {
      'postid': post_id,
      'userId': id_user,
      'message': comment_controller.text,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.Post_Comment_Post_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      isCommentPostLoading(false);
      var data = jsonDecode(response.body);
      postcommentPostModel = postImageCommentPostModel.fromJson(data);
      print(postcommentPostModel);
      if (postcommentPostModel!.error == false) {
        CommonWidget().showToaster(msg: postcommentPostModel!.message!);
        await getPostCommments(newsfeedID: news_id, context: context);
        await clear();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }


  RxBool isReplyCommentPostLoading = true.obs;
  PostReplyCommentPostModel? postReplyCommentPostModel;
  Future<dynamic> ReplyCommentPostApi({required BuildContext context,
    required String news_id,

  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isReplyCommentPostLoading(true);

    Map data = {
      'userid': idUser,
      'comId': Replying_comment_id,
      'comment': "@$Replyname_controller ${comment_controller.text}",
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.Post_reply_Comment_Post_Api);
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    print(response.body);
    print(response.request);
    print(response.statusCode);
    // var final_data = jsonDecode(response.body);

    // print('final data $final_data');

    if (response.statusCode == 200) {
      isReplyCommentPostLoading(false);
      var data = jsonDecode(response.body);
      postReplyCommentPostModel = PostReplyCommentPostModel.fromJson(data);
      print(postReplyCommentPostModel);
      if (postReplyCommentPostModel!.error == false) {
        CommonWidget().showToaster(msg: postReplyCommentPostModel!.message!);
        await getPostCommments(newsfeedID: news_id, context: context);
        await clear();
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  clear() {
    comment_controller.clear();
  }


}
