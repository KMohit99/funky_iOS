import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:funky_new/custom_widget/page_loader.dart';
import 'package:funky_new/search_screen/model/getDiscoverModel.dart';
import 'package:funky_new/search_screen/model/searchModel.dart';

// import 'package:funky_project/Authentication/creator_login/controller/creator_login_controller.dart';
// import 'package:funky_project/search_screen/searchModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Utils/App_utils.dart';
import '../Utils/toaster_widget.dart';
import '../dashboard/dashboard_screen.dart';
import '../homepage/model/VideoList_model.dart';
import 'dart:convert' as convert;

import '../homepage/model/UserInfoModel.dart';
import '../profile_screen/model/followUnfollowModel.dart';
import '../profile_screen/model/followersModel.dart';
import '../sharePreference.dart';
import 'model/HashTagPostModel.dart';
import 'model/getFriendSuggestionModel.dart';
import 'model/hashTagsearchModel.dart';

class Search_screen_controller extends GetxController {
  // bool isPasswordVisible = false;
  // isPasswordVisibleUpdate(bool value) {
  //   isPasswordVisible = value;
  //   update();
  // }

  RxBool isSearchLoading = false.obs;
  RxBool taxfeildTapped = false.obs;
  SearchApiModel? searchlistModel;
  var getVideoModelList = SearchApiModel().obs;
  TextEditingController searchquery = new TextEditingController();

  Future<dynamic> getUserList() async {
    isSearchLoading(true);
    isHashSearchLoading(false);

    String url = (URLConstants.base_url + URLConstants.searchListApi);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    Map data = {
      'search': searchquery.text,
    };
    print(data);
    // String body = json.encode(data);

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );

    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      searchlistModel = SearchApiModel.fromJson(data);
      getVideoModelList(searchlistModel);
      if (searchlistModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${searchlistModel!.data!.length}');
        isSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return searchlistModel;
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

  RxBool isHashSearchLoading = false.obs;
  HashTagSearchModel? hashTagSearchModel;

  Future<dynamic> getHashtagList({required String hashtag}) async {
    isHashSearchLoading(true);
    isSearchLoading(false);
    String result1 =
    hashtag.replaceAll(RegExp('[^A-Za-z]'), '');
    print(result1);
    String url =
    ("${URLConstants.base_url}${URLConstants.SearchTag}?tagName=%23$result1");
    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    // String body = json.encode(data);

    http.Response response = await http.get(Uri.parse(url));


    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      hashTagSearchModel = HashTagSearchModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (hashTagSearchModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${hashTagSearchModel!.data!.length}');
        isHashSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return hashTagSearchModel;
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

  RxBool isPostHashSearchLoading = false.obs;
  GetDiscoverModel? hashTagPostModel;

  Future<dynamic> getPostByHashtag({required String hashtag}) async {
    isPostHashSearchLoading(true);
    String result1 =
    hashtag.replaceAll(RegExp('[^A-Za-z]'), '');
    print(result1);
    String url =
    ("${URLConstants.base_url}${URLConstants.SearchTagPosts}?description=%23$result1");
    // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    // String body = json.encode(data);

    http.Response response = await http.get(Uri.parse(url));


    print('Response request: ${response.request}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      hashTagPostModel = GetDiscoverModel.fromJson(data);
      // getVideoModelList(searchlistModel);
      if (hashTagPostModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${hashTagPostModel!.data!.length}');
        isPostHashSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return hashTagPostModel;
      } else {
        isPostHashSearchLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isPostHashSearchLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isPostHashSearchLoading(false);

      // CommonService().unAuthorizedUser();
    } else {
      // CommonWidget().showToaster(msg: msg.toString());
    }
  }


  RxBool block_unblockLoading = false.obs;

  Future<dynamic> Block_unblock_api({
    required BuildContext context,
    required String user_id,
    required String user_name,
    required String social_bloc_type,
    required String block_unblock,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');
    block_unblockLoading(true);
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String type_user = await PreferenceManager().getPref(URLConstants.type);

    Map data = {
      'userId': user_id,
      'blocID': id_user,
      'type': type_user,
      'social_type': social_bloc_type,
      'user_blockUnblock': block_unblock,
      'userName': user_name,
    };
    print(data);
    // String body = json.encode(data);

    var url = ("${URLConstants.base_url}blockUser.php");
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
      var data = jsonDecode(response.body);
      print(data);
      // print("loginModel!.user![0].id! ${_followUnfolloemodel!.user![0].id!}");
      if (data["error"] == false) {
        block_unblockLoading(false);

        // await PreferenceManager()
        CommonWidget()
            .showToaster(msg: "User status has been blocked".toString());
        Navigator.pop(context);
        //     .setPref(URLConstants.id, _followUnfolloemodel!.user![0].id!);
        // CommonService().setStoreKey(
        //     setKey: 'type', setValue: loginModel!.user![0].type!.toString());
        // print(CommonService().getStoreValue(keys: 'type').toString());
        // Get.to(kids_Email_verification());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  RxList<Data_followers>? FollowersData = RxList();
  RxList<Data_followers>? FollowingData = RxList();

  Future<List<Data_followers>> getFollowersList() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ('${URLConstants.base_url}${URLConstants.FollowersListApi}?id=$id_user');
    http.Response response = await http.get(Uri.parse(url));
    print(response);
    List books = [];

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      books = data["data"];
      print('Books =${books}');
    }
    return books.map((json) => Data_followers.fromJson(json)).toList();
  }

  Future<List<Data_followers>> getFollowingList() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String url = ('${URLConstants.base_url}${URLConstants.followingListApi}?id=$id_user');
    http.Response response = await http.get(Uri.parse(url));
    print(response);
    List books = [];

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      books = data["data"];
      print('Books =${books}');
    }
    return books.map((json) => Data_followers.fromJson(json)).toList();
  }

  Data_followers? is_follower;
  Data_followers? is_following;

  RxBool comapre_loading = true.obs;

  compare_data() async {
    await getAllFollowersList();
    await getAllFollowingList();
    comapre_loading(true);
    print("widget.search_user_data.id ${userInfoModel_email!.data![0].id}");
    print(
        "widget.search_user_data.id ${userInfoModel_email!.data![0].followerNumber}");
    // print("widget.search_user_data.id ${FollowersData[0].id}");
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    String id = userInfoModel_email!.data![0].id!;
    print("----${id}");
    print(id_user);

    Data_followers? last_out = FollowersData!.firstWhereOrNull(
      (element) => element.id == id,
    );
    if (last_out == null) {
      is_follower = last_out;
      print('no data found');
      comapre_loading(false);
    } else {
      is_follower = last_out;
      print('Followers true $is_follower');
      comapre_loading(false);
    }

    Data_followers? first_out = FollowingData!.firstWhereOrNull(
      (element) => element.id == id,
    );
    if (first_out == null) {
      is_following = first_out;
      print('no data found');
      comapre_loading(false);
    } else {
      is_following = first_out;
      print('Following true $is_following');
      comapre_loading(false);
    }
  }

  Future<dynamic> getAllFollowersList() async {
    final books = await getFollowersList();

    FollowersData = RxList(books);
    print(FollowersData!.length);
  }

  Future<dynamic> getAllFollowingList() async {
    final books = await getFollowingList();
    FollowingData = RxList(books);
    print(FollowingData!.length);
  }

  RxBool isuserinfoLoading = true.obs;
  UserInfoModel? userInfoModel_email;
  var getUSerModelList = UserInfoModel().obs;

  Future<dynamic> CreatorgetUserInfo_Email({required String UserId}) async {
    print('inside searche userinfo email----------');
    isuserinfoLoading(true);
    String url = ("${URLConstants.base_url}${URLConstants.user_info_email_Api}?id=${UserId}");
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
      userInfoModel_email = UserInfoModel.fromJson(data);
      getUSerModelList(userInfoModel_email);
      if (userInfoModel_email!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${userInfoModel_email!.data!.length}');
        isuserinfoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return userInfoModel_email;
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

  Future<dynamic> getUserInfo_social({required String UserId}) async {
    print('inside searche userinfo social----------');
    // showLoader(context);
    isuserinfoLoading(true);
    // String userId = CommonService().getStoreValue(keys:'id');
    // String id_user = await PreferenceManager().getPref(URLConstants.id);

    // print("UserID $id_user");
    String url = ("${URLConstants.base_url}${URLConstants.user_info_social_Api}?id=$UserId");
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
      userInfoModel_email = UserInfoModel.fromJson(data);
      getUSerModelList(userInfoModel_email);
      if (userInfoModel_email!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${userInfoModel_email!.data!.length}');
        isuserinfoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        // hideLoader(context);
        return userInfoModel_email;
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

  RxBool apiLoading = false.obs;
  followUnfollowModel? _followUnfolloemodel;

  Future<dynamic> Follow_unfollow_api(
      {required BuildContext context,
      required String follow_unfollow,
      required user_social,
      required user_id}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    showLoader(context);

    apiLoading;
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String type_user = await PreferenceManager().getPref(URLConstants.type);
    String type_social =
        await PreferenceManager().getPref(URLConstants.social_type);
    print("second_id ${type_social}");

    Map data = {
      'follower_id': id_user,
      'followed_user_id': user_id,
      'user_followUnfollow': follow_unfollow,
      'id': user_id,
      'type': type_user,
      'social_type': type_social,
    }; // String body = json.encode(data);

    var url = ("${URLConstants.base_url}followUnfollow.php");
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
      apiLoading(false);
      var data = jsonDecode(response.body);
      _followUnfolloemodel = followUnfollowModel.fromJson(data);
      print(_followUnfolloemodel);
      // print("loginModel!.user![0].id! ${_followUnfolloemodel!.user![0].id!}");
      if (_followUnfolloemodel!.error == false) {
        print("user -socail -- $user_social");
        (user_social == ""
            ? await CreatorgetUserInfo_Email(UserId: user_id)
            : await getUserInfo_social(UserId: user_id));
        await compare_data();
        hideLoader(context);
        // await PreferenceManager()
        //     .setPref(URLConstants.id, _followUnfolloemodel!.user![0].id!);
        // CommonService().setStoreKey(
        //     setKey: 'type', setValue: loginModel!.user![0].type!.toString());
        print(CommonService().getStoreValue(keys: 'type').toString());
        // Get.to(kids_Email_verification());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }



  RxBool isDiscoverLoading = true.obs;
  GetDiscoverModel? getDiscoverModel;
  var getDiscoverModelList = GetDiscoverModel().obs;

  List<File> test_thumb = [];

  Future<dynamic> getDiscoverFeed() async {
    print('inside searche userinfo email----------');
    isDiscoverLoading(true);
    String url = ("${URLConstants.base_url}${URLConstants.Discover_Search}");
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
      getDiscoverModel = GetDiscoverModel.fromJson(data);
      getDiscoverModelList(getDiscoverModel);
      if (getDiscoverModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getDiscoverModel!.data!.length}');
        isDiscoverLoading(false);
        CommonWidget().showToaster(msg: data["success"].toString());

        // for (int i = 0; i < getDiscoverModel!.data!.length; i++) {
        //   if (getDiscoverModel!.data![i].isVideo == 'true') {
        //     print(getDiscoverModel!.data![i].uploadVideo!);
        //     final uint8list = await VideoThumbnail.thumbnailFile(
        //       video:
        //       ("${URLConstants.base_data_url}video/${getDiscoverModel!.data![i].uploadVideo!}"),
        //       thumbnailPath: (await getTemporaryDirectory()).path,
        //       imageFormat: ImageFormat.PNG,
        //       maxHeight: 64,
        //       // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        //       quality: 20,
        //     );
        //     test_thumb.add(File(uint8list!));
        //     print(test_thumb[i].path);
        //   } else if (getDiscoverModel!.data![i].isVideo == 'false') {
        //     test_thumb
        //         .add(File(getDiscoverModel!.data![i].postImage!));
        //     // print(story_info[i].image);
        //   }
        //
        //   // print("test----------${test_thumb[i].path}");
        // }
        return getDiscoverModel;
      } else {
        isDiscoverLoading(false);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isDiscoverLoading(false);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isDiscoverLoading(false);

      // CommonService().unAuthorizedUser();
    } else {

      // CommonWidget().showToaster(msg: msg.toString());
    }
  }

  RxBool isSuggestionLoading = true.obs;
  GetFriendSuggestionModel? getFriendSuggestionModel;
  var getSuggestionModelList = GetFriendSuggestionModel().obs;

  Future<dynamic> friendSuggestionList({required BuildContext context,}) async {
    print('inside searche userinfo email----------');
    isSuggestionLoading(true);
    showLoader(context);
    String url = ("${URLConstants.base_url}${URLConstants.friend_suggestion}");
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
      getFriendSuggestionModel = GetFriendSuggestionModel.fromJson(data);
      getSuggestionModelList(getFriendSuggestionModel);
      if (getFriendSuggestionModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${getFriendSuggestionModel!.data!.length}');
        isSuggestionLoading(false);
        hideLoader(context);
        CommonWidget().showToaster(msg: data["success"].toString());

        return getFriendSuggestionModel;
      } else {
        isSuggestionLoading(false);
        hideLoader(context);

        // CommonWidget().showToaster(msg: msg.toString());
        return null;
      }
    } else if (response.statusCode == 422) {
      isSuggestionLoading(false);
      hideLoader(context);

      // CommonWidget().showToaster(msg: msg.toString());
    } else if (response.statusCode == 401) {
      isSuggestionLoading(false);
      hideLoader(context);

      // CommonService().unAuthorizedUser();
    } else {

      // CommonWidget().showToaster(msg: msg.toString());
    }
  }


}
