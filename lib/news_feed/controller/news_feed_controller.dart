import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Authentication/creator_signup/model/otpVerifyModel.dart';
import '../../Utils/App_utils.dart';
import '../../Utils/toaster_widget.dart';
import '../../sharePreference.dart';
import '../model/LikeUnlikeModel.dart';
import '../model/comment-_like_model.dart';
import '../model/comment_post_model.dart';
import '../model/comment_reply_like_model.dart';
import '../model/news_feedModel.dart';
import '../model/newsfeedCommentModel.dart';
import '../model/reply_comment_post_model.dart';

class NewsFeed_screen_controller extends GetxController {
  RxBool isVideoLoading = true.obs;
  NewsFeedModel? newsfeedModel;
  var getVideoModelList = NewsFeedModel().obs;
  String feedlikeCount= '';
  String feedlikeStatus='';

  Future<dynamic> getAllNewsFeedList() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isVideoLoading(true);
    String url = (URLConstants.base_url + URLConstants.NewsFeedApi);

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
      newsfeedModel = NewsFeedModel.fromJson(data);
      getVideoModelList(newsfeedModel);
      if (newsfeedModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${newsfeedModel!
                .data!.length}');
        isVideoLoading(false);

        // CommonWidget().showToaster(msg: data["success"].toString());
        return newsfeedModel;
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
  FeedLikeUnlikeModel? feedLikeUnlikeModel;

  Future<dynamic> FeedLikeUnlikeApi({required BuildContext context,
    required String news_post_id,
    required String news_post_id_type,
    required String news_post_feedlikeStatus}) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isLikeLoading(true);

    Map data = {
      'userId': id_user,
      'postid': news_post_id,
      'type': news_post_id_type,
      'feedlikeStatus': news_post_feedlikeStatus
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.NewsFeedLike_Unlike_Api);
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
      feedLikeUnlikeModel = FeedLikeUnlikeModel.fromJson(data);
      print(feedLikeUnlikeModel);
      if (feedLikeUnlikeModel!.error == false) {
        CommonWidget().showToaster(msg: feedLikeUnlikeModel!.message!);
        feedlikeStatus = feedLikeUnlikeModel!.user![0].feedlikeStatus!;
        feedlikeCount = feedLikeUnlikeModel!.user![0].feedLikeCount!;
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
  NewsFeedCommnetModel? newsFeedCommnetModel;

  Future<dynamic> getNewsFeedCommnets(
      {required BuildContext context, required String newsfeedID}) async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    iscommentsLoading(true);
    String url =
    ('${URLConstants.base_url}${URLConstants
        .NewsFeed_Comment_Api}?postid=$newsfeedID');

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
      newsFeedCommnetModel = NewsFeedCommnetModel.fromJson(data);
      // getVideoModelList(newsfeedModel);
      if (newsfeedModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${newsFeedCommnetModel!
                .data!.length}');
        iscommentsLoading(false);
        CommonWidget().showToaster(msg: newsFeedCommnetModel!.message!.toString());
        return newsFeedCommnetModel;
      } else {
        CommonWidget().showToaster(msg: newsFeedCommnetModel!.message!);
        return null;
      }
    } else if (response.statusCode == 422) {
      CommonWidget().showToaster(msg: newsFeedCommnetModel!.message!);
    } else if (response.statusCode == 401) {
      // CommonService().unAuthorizedUser();
    } else {
      CommonWidget().showToaster(msg: newsFeedCommnetModel!.message!);
    }
  }


  RxBool isCommentLikeLoading = true.obs;
  CommentLikeUnlikeModel? commentLikeUnlikeModel;

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

    var url = (URLConstants.base_url + URLConstants.NewsFeed_Comment_like_Api);
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
      commentLikeUnlikeModel = CommentLikeUnlikeModel.fromJson(data);
      print(commentLikeUnlikeModel);
      if (commentLikeUnlikeModel!.error == false) {
        CommonWidget().showToaster(msg: commentLikeUnlikeModel!.message!);
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
  CommentReplyLikeUnlikeModel? commentReplyLikeUnlikeModel;

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
        URLConstants.NewsFeed_Comment_reply_like_Api);
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
      commentReplyLikeUnlikeModel = CommentReplyLikeUnlikeModel.fromJson(data);
      print(commentReplyLikeUnlikeModel);
      if (commentReplyLikeUnlikeModel!.error == false) {
        CommonWidget().showToaster(msg: commentReplyLikeUnlikeModel!.message!);
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
  CommentPostModel? commentPostModel;
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

    var url = (URLConstants.base_url + URLConstants.NewsFeed_Comment_Post_Api);
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
      commentPostModel = CommentPostModel.fromJson(data);
      print(commentPostModel);
      if (commentPostModel!.error == false) {
        CommonWidget().showToaster(msg: commentPostModel!.message!);
        await getNewsFeedCommnets(newsfeedID: news_id, context: context);
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
  ReplyCommentPostModel? replyCommentPostModel;
  Future<dynamic> ReplyCommentPostApi({required BuildContext context,
    required String news_id,

  }) async {
    debugPrint('0-0-0-0-0-0-0 username');

    String idUser = await PreferenceManager().getPref(URLConstants.id);

    isReplyCommentPostLoading(true);

    Map data = {
      'userId': idUser,
      'comId': Replying_comment_id,
      'comment': "@$Replyname_controller ${comment_controller.text}",
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.NewsFeed_reply_Comment_Post_Api);
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
      replyCommentPostModel = ReplyCommentPostModel.fromJson(data);
      print(replyCommentPostModel);
      if (replyCommentPostModel!.error == false) {
        CommonWidget().showToaster(msg: replyCommentPostModel!.message!);
        await getNewsFeedCommnets(newsfeedID: news_id, context: context);
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
