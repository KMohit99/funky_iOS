import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Utils/App_utils.dart';
import '../sharePreference.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'model/blockModelList.dart';

class Settings_screen_controller extends GetxController {
  RxBool isSearchLoading = false.obs;
  BlockListModel? blockListModel;
  var getBlockModelList = BlockListModel().obs;

  Future<dynamic> getBlockList() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    isSearchLoading(true);
    String url = (URLConstants.base_url + URLConstants.blockListApi + "?id=${id_user}");
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
      blockListModel = BlockListModel.fromJson(data);
      getBlockModelList(blockListModel);
      if (blockListModel!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${blockListModel!.data!.length}');
        isSearchLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return blockListModel;
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


  RxBool block_unblockLoading = false.obs;

  Future<dynamic> Block_unblock_api(
      {required BuildContext context,
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

    var url = ("http://foxyserver.com/funky/api/blockUser.php");
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
        getBlockList();
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



}