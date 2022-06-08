import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:funky_project/Authentication/authentication_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../authentication_screen.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';
import 'package:http/http.dart' as http;

import '../../kids_login/model/parents_otp_model.dart';
import '../model/countryModelclass.dart';
import '../model/otpVerifyModel.dart';
import '../ui/creator_otp_verification.dart';

class Creator_signup_controller extends GetxController {
  String? selected_gender;

// fullName,userName,email,phone,parent_email,password,gender,location,referral_code,image,countryCode,about,type

  TextEditingController fullname_controller = new TextEditingController();
  TextEditingController username_controller = new TextEditingController();
  TextEditingController email_controller = new TextEditingController();
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController parentEmail_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();
  TextEditingController location_controller = new TextEditingController();
  TextEditingController reffralCode_controller = new TextEditingController();
  TextEditingController countryCode_controller = new TextEditingController();
  TextEditingController aboutMe_controller = new TextEditingController();

  RxBool isLoading = false.obs;
  LoginModel? loginModel;

  Future<dynamic> creator_signup(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    isLoading(true);
    Map data = {
      'fullName': fullname_controller.text,
      'userName': username_controller.text,
      'email': email_controller.text,
      'phone': phone_controller.text,
      'parent_email': parentEmail_controller.text,
      'password': password_controller.text,
      'gender': selected_gender,
      'location': selectedcountry!.location.toString(),
      'referral_code': reffralCode_controller.text,
      // 'image': photoBase64!,
      'image': img64!.substring(0, 100),
      'countryCode': countryCode_controller.text,
      'about': aboutMe_controller.text,
      'type': 'creator',
    };
    // print(data);
    // String body = json.encode(data);

    var url = ("http://foxyserver.com/funky/api/signup.php");
    print("url : $url");
    print("body : $data");

    var response = await http.post(
      Uri.parse(url),
      body: data,
    );
    // print(response.body);
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
        CommonWidget().showToaster(msg: 'Please verify the OTP');
        Get.to(CreatorOtpVerification());
        await CreatorsendOtp(context);
        // Get.to(Dashboard());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  Future<dynamic> Update_user_profile({required BuildContext context , required String usertype, required String socialtype,}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    isLoading(true);
    Map data = {
      'fullName': fullname_controller.text,
        'userName': username_controller.text,
      'email': email_controller.text,
      'phone': phone_controller.text,
      // 'parent_email': parentEmail_controller.text,
      // 'password': password_controller.text,
      'gender': selected_gender,
      'location': selectedcountry!.location.toString(),
      'referral_code': reffralCode_controller.text,
      'image': (_creator_login_screen_controller
              .userInfoModel_email!.data![0].profileUrl!.isNotEmpty
          ? _creator_login_screen_controller
              .userInfoModel_email!.data![0].profileUrl!.toString()
          : img64!.substring(0, 100)),
      // 'countryCode': countryCode_controller.text,
      'about': aboutMe_controller.text,
      'type': usertype,
      'social_type' : socialtype
    };
    print(data);
    // String body = json.encode(data);

    var url = ("http://foxyserver.com/funky/api/editProfile.php");
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
      if (loginModel!.error == false) {
        CommonWidget().showToaster(msg: 'Please verify the OTP');
        Get.to(AuthenticationScreen());
        // await CreatorsendOtp(context);
        // Get.to(Dashboard());
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isotpLoading = false.obs;
  parentsOtpModel? otpsendModel;
  String? photoBase64;
  String? img64;

  Future<dynamic> CreatorsendOtp(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpLoading(true);
    Map data = {
      'email': email_controller.text,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.creatorsend_Api);
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
      isotpLoading(false);
      var data = jsonDecode(response.body);
      otpsendModel = parentsOtpModel.fromJson(data);
      print(loginModel);
      if (otpsendModel!.error == false) {
        CommonWidget().showToaster(msg: 'Enter Otp');
        // Get.to(OtpScreen(received_otp: otpModel!.user![0].body!,));
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Phone Number');
      }
    } else {
      print('Please try again');
    }
  }

  RxBool isotpVerifyLoading = false.obs;
  otpVerifyModel? otpverifyModel;

  Future<dynamic> CreatorVerifyOtp(
      {required BuildContext context, required String otp_controller}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
    Map data = {
      'otp': otp_controller,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.creatorverify_Api);
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
      isotpVerifyLoading(false);
      var data = jsonDecode(response.body);
      otpverifyModel = otpVerifyModel.fromJson(data);
      print(otpverifyModel);
      if (otpverifyModel!.error == false) {
        CommonWidget().showToaster(msg: 'Signed Up');
        await _creator_login_screen_controller.CreatorgetUserInfo_Email(UserId: loginModel!.user![0].id!);

        await Get.to(Dashboard());
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  countryModel? countrymodelList;
  var getAllCountriesModelList = countryModel().obs;
  RxBool iscountryLoading = false.obs;
  List<Data_country> data_country = <Data_country>[];
  Data_country? selectedcountry;

  Future<dynamic> getAllCountriesFromAPI() async {
    iscountryLoading(true);
    print('inside xountry');
    String url = (URLConstants.base_url + URLConstants.CountryListApi);

    // debugPrint('Get Sales Token ${tokens.toString()}');
    try {
      http.Response response = await http.get(Uri.parse(url));

      print('Response request: ${response.request}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var data = jsonDecode(response.body);

      if (response == null) {
        return null;
      } else if (response.statusCode == 200) {
        final status = data["success"];
        countrymodelList = countryModel.fromJson(data);
        getAllCountriesModelList(countrymodelList);
        if (countrymodelList!.error == false) {
          debugPrint(
              '2-2-2-2-2-2 Inside the product Controller Details ${countrymodelList!.data!.length}');
          iscountryLoading(false);
          data_country = getAllCountriesModelList.value.data!.obs;
          print("data ${data_country}");
          return countrymodelList;
        } else {
          CommonWidget().showToaster(msg: 'Error');
          return null;
        }
      } else if (response.statusCode == 422) {
        CommonWidget().showToaster(msg: "Error 422");
      } else {
        CommonWidget().showToaster(msg: '');
      }
    } catch (e) {
      print('1-1-1-1 Get Purchase ${e.toString()}');
    }
  }
}
