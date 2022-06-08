import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:funky_project/getx_pagination/binding_utils.dart';
import 'package:get/get.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
// import '../../../dashboard/dashboard_screen.dart';
import '../../../getx_pagination/binding_utils.dart';
import '../../creator_signup/model/otpVerifyModel.dart';
import '../../kids_login/model/parents_otp_model.dart';
import 'package:http/http.dart' as http;

import '../model/forgot_password_model.dart';
import '../ui/new_password_screen.dart';
import '../ui/password_reset_otp_veri.dart';

class password_reset_controller extends GetxController {

  RxBool isotpLoading = false.obs;
  forgot_passwordModel? Forgot_passwordModel;
  TextEditingController email_controller = new TextEditingController();


  Future<dynamic> pass_reset_SendOtp( BuildContext context ) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpLoading(true);
    Map data = {
      'email': email_controller.text,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.password_reset_Api);
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



    if (response.statusCode == 200 ) {
      isotpLoading(false);
      var data = jsonDecode(response.body);
      Forgot_passwordModel = forgot_passwordModel.fromJson(data);
      // print(loginModel);
      if(Forgot_passwordModel!.error == false){
        CommonWidget().showToaster(msg: 'Enter Otp');

      }
      else{
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Phone Number');
      }
    } else {
      print('Please try again');
    }

  }

  RxBool isotpVerifyLoading = false.obs;
  otpVerifyModel? otpverifyModel;

  Future<dynamic> pass_reset_VerifyOtp({required BuildContext context , required String otp_controller}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
    Map data = {
      'otp': otp_controller.toString(),
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.password_verify_Api);
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

    if (response.statusCode == 200 ) {
      isotpVerifyLoading(false);
      var data = jsonDecode(response.body);
      otpverifyModel = otpVerifyModel.fromJson(data);
      print(otpverifyModel);
      // Get.to(SetNewPassword());
      if(otpverifyModel!.error == false){
        CommonWidget().showToaster(msg: 'OTP verified');
        Get.to(SetNewPassword());
      }
      else{
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }

  }

  TextEditingController reset_password_controller = new TextEditingController();
  TextEditingController confirm_reset_password_controller = new TextEditingController();
  Future<dynamic> set_newPassword_api({required BuildContext context }) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
    Map data = {
      'email': email_controller.text,
      'id': Forgot_passwordModel!.user![0].id!,
      'password': reset_password_controller.text,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.new_password_Api);
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

    if (response.statusCode == 200 ) {
      isotpVerifyLoading(false);
      var data = jsonDecode(response.body);
      print(data["error"]);
      // otpverifyModel = otpVerifyModel.fromJson(data);
      // print(otpverifyModel);
      if(data["error"] == false){
        CommonWidget().showToaster(msg: 'Password reset successful');
        Get.toNamed(BindingUtils.creator_loginScreenRoute);
      }
      else{
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }

  }


}