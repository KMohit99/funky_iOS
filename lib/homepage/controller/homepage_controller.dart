import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Utils/App_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../model/Homepage_model.dart';

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

}
