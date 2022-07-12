import 'package:get/get.dart';

import '../Utils/App_utils.dart';
import 'model/getStoryCountModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/App_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../sharePreference.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class Profile_screen_controller extends GetxController {


  StoryCountModel? storyCountModel;
  RxBool isStoryCountLoading = true.obs;

  Future<dynamic> get_story_count({required String story_id}) async {
    print('Inside creator get email');
    isStoryCountLoading(true);
    String url =
    ("${URLConstants.base_url}${URLConstants.StoryGetCountApi}?stoID=${story_id}");
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
      storyCountModel = StoryCountModel.fromJson(data);
      // getUSerModelList(userInfoModel_email);
      if (storyCountModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the Get UserInfo Controller Details ${storyCountModel!.data!.length}');
        // story_info = getStoryModel!.data!;

        // CommonWidget().showToaster(msg: data["success"].toString());
        // await Get.to(Dashboard());

        isStoryCountLoading(false);
        return storyCountModel;
      } else {
          isStoryCountLoading(false);
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

}