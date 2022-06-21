import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:funky_project/Authentication/creator_login/model/creator_loginModel.dart';
// import 'package:funky_project/dashboard/dashboard_screen.dart';
// import 'package:funky_project/getx_pagination/binding_utils.dart';
import 'package:get/get.dart';

// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
// import 'package:twitter_login/twitter_login.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/page_loader.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../sharePreference.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';

class Advertiser_Login_screen_controller extends GetxController {
  RxBool isLoading = false.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginModel? loginModel;
  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  Future<dynamic> checkLogin(
      {required BuildContext context, required String login_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    isLoading(true);
    showLoader(context);
    Map data = {
      'userName': usernameController.text,
      'password': passwordController.text,
      'type': login_type,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.loginApi);
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
      isLoading(false);
      var data = jsonDecode(response.body);
      loginModel = LoginModel.fromJson(data);
      print(loginModel);
      if (loginModel!.error == false) {
        Fluttertoast.showToast(
          msg: "login successfully",
          textColor: Colors.white,
          backgroundColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        await PreferenceManager()
            .setPref(URLConstants.id, loginModel!.user![0].id!);
        await PreferenceManager()
            .setPref(URLConstants.type, loginModel!.user![0].type!);

        await PreferenceManager()
            .setPref(URLConstants.social_type, "");
        await _creator_login_screen_controller.CreatorgetUserInfo_Email(
            UserId: loginModel!.user![0].id!);

        await clear();

        await Get.to(Dashboard());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }
  clear() {
    usernameController.clear();
    passwordController.clear();
  }
}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
