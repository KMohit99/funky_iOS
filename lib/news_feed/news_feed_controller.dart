import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Utils/App_utils.dart';
import '../sharePreference.dart';
import 'news_feedModel.dart';

class NewsFeed_screen_controller extends GetxController {

  RxBool isVideoLoading = true.obs;
  NewsFeedModel? newsfeedModel;
  var getVideoModelList = NewsFeedModel().obs;

  Future<dynamic> getAllNewsFeedList() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isVideoLoading(true);
    String url = (URLConstants.base_url + URLConstants.NewsFeedApi );

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
      newsfeedModel
      = NewsFeedModel.fromJson(data);
      getVideoModelList(newsfeedModel
      );
      if (newsfeedModel
      !.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${newsfeedModel
            !.data!.length}');
        isVideoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return newsfeedModel
        ;
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

}