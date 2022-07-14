import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:funky_project/Authentication/kids_signup/ui/kids_otp_verification.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
// import '../../../homepage/model/UserInfoModel.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../sharePreference.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';
import 'package:http/http.dart' as http;

import '../../creator_signup/model/countryModelclass.dart';
import '../../creator_signup/model/otpVerifyModel.dart';
import '../../creator_signup/ui/creator_otp_verification.dart';
import '../../kids_login/model/parents_otp_model.dart';
import 'dart:convert' as convert;

import '../../kids_login/ui/kids_email_verification.dart';
import '../ui/kids_otp_verification.dart';
import '../ui/kids_signup_email_verification.dart';
import '../ui/paretns_otp_screen.dart';

class Kids_signup_controller extends GetxController {
  bool isPasswordVisible = false;

  isPasswordVisibleUpdate(bool value) {
    isPasswordVisible = value;
    update();
  }
  final Creator_Login_screen_controller _creator_login_screen_controller =
  Get.put(Creator_Login_screen_controller(),
      tag: Creator_Login_screen_controller().toString());

  TextEditingController fullname_controller = new TextEditingController();
  TextEditingController username_controller = new TextEditingController();
  TextEditingController email_controller = new TextEditingController();
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController parentEmail_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();
  TextEditingController location_controller = new TextEditingController();
  TextEditingController gender_controller = new TextEditingController();
  TextEditingController reffralCode_controller = new TextEditingController();
  TextEditingController countryCode_controller = new TextEditingController();
  TextEditingController aboutMe_controller = new TextEditingController();


  RxBool isLoading = false.obs;
  LoginModel? loginModel;
  File? imgFile;

  String selected_gender = 'male';
  String? selected_country;
  String? selected_country_code = '+91';


  // Future<dynamic> kids_signup(BuildContext context) async {
  //   debugPrint('0-0-0-0-0-0-0 username');
  //   // try {
  //   //
  //   // } catch (e) {
  //   //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
  //   // }
  //   isLoading(true);
  //   Map data = {
  //     'fullName': fullname_controller.text,
  //     'userName': username_controller.text,
  //     'email': email_controller.text,
  //     'phone': phone_controller.text,
  //     'parent_email': parentEmail_controller.text,
  //     'password': password_controller.text,
  //     'gender': selected_gender,
  //     'location': location_controller.text,
  //     'referral_code': reffralCode_controller.text,
  //     'image': img64!.substring(0, 100),
  //     'countryCode': countryCode_controller.text,
  //     'about': aboutMe_controller.text,
  //     'type': 'kids',
  //   };
  //   print(data);
  //   // String body = json.encode(data);
  //
  //   var url = (URLConstants.base_url + URLConstants.SignUpApi);
  //   print("url : $url");
  //   print("body : $data");
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   print(response.body);
  //   print(response.request);
  //   print(response.statusCode);
  //   // var final_data = jsonDecode(response.body);
  //
  //   // print('final data $final_data');
  //
  //   if (response.statusCode == 200) {
  //     isLoading(false);
  //     var data = jsonDecode(response.body);
  //     loginModel = LoginModel.fromJson(data);
  //     print(loginModel);
  //     if (loginModel!.error == false) {
  //       print("---------${loginModel!.message}");
  //       if(loginModel!.message == 'User Already Exists'){
  //         CommonWidget().showErrorToaster(msg: loginModel!.message!);
  //       }else{
  //         CommonWidget().showToaster(msg: loginModel!.message!);
  //         Get.to(KidsOtpVerification());
  //         await KidsSendOtp(context);
  //       }
  //       // Get.to(Dashboard());
  //     } else {
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }

  Future<dynamic> kids_signup({required BuildContext context}) async {
    // showLoader(context);
    var url = 'https://foxytechnologies.com/funky/api/signup.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // List<int> imageBytes = imgFile!.readAsBytesSync();
    // String baseimage = base64Encode(imageBytes);

    if (imgFile != null) {
      var files = await http.MultipartFile(
          'image',
          File(imgFile!.path).readAsBytes().asStream(),
          File(imgFile!.path).lengthSync(),
          filename: imgFile!.path.split("/").last);
      request.files.add(files);
    }
    request.fields['fullName'] = fullname_controller.text;
    request.fields['userName'] = username_controller.text;
    request.fields['email'] = email_controller.text;
    request.fields['phone'] = phone_controller.text;
    request.fields['parent_email'] = parentEmail_controller.text;
    request.fields['password'] = password_controller.text;
    request.fields['gender'] = selected_gender;
    request.fields['location'] = selected_country!;
    request.fields['referral_code'] = reffralCode_controller.text;
    request.fields['countryCode'] = selected_country_code!;
    request.fields['about'] = aboutMe_controller.text;
    request.fields['type'] = 'kids';

    //userId,tagLine,description,address,postImage,uploadVideo,isVideo
    // request.files.add(await http.MultipartFile.fromPath(
    //     "image", widget.ImageFile.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    print(response.statusCode);
    print("response - ${response.statusCode}");

    if (response.statusCode == 200) {
      isLoading(false);
      var data = jsonDecode(responsed.body);
      loginModel = LoginModel.fromJson(data);
      print(loginModel);
      if (loginModel!.error == false) {
        if(loginModel!.message == 'User Already Exists'){
          CommonWidget().showErrorToaster(msg: loginModel!.message!);
        }else{
          CommonWidget().showToaster(msg: loginModel!.message!);
          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);
          await Get.to(Dashboard(page: 0,));
        }
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

  Future<dynamic> KidsSendOtp(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpLoading(true);
    Map data = {
      'email': email_controller.text,
      'phone' : selected_country_code! + phone_controller.text
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
        Get.to(KidsOtpVerification());

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
  parentsOtpModel? otpModel;

  Future<dynamic> KidsVerifyOtp(
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
        // _creator_login_screen_controller.CreatorgetUserInfo_Email(
        //     UserId: loginModel!.user![0].id!);
        await  Get.to(kids_signup_Email_verification());

        // await kids_signup(context: context);
        // Get.to(Dashboard());
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }


  Future<dynamic> ParentEmailVerification(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    Map data = {
      // 'userName': usernameController.text,
      'email': parentEmail_controller.text,
      // 'type': login_type,
    };
    print(data);
    // String body = json.encode(data);

    var url = (URLConstants.base_url + URLConstants.parentOtpVeri_Api);
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
      // isLoginLoading(false);
      var data = jsonDecode(response.body);
      otpModel = parentsOtpModel.fromJson(data);
      if (otpModel!.error == false) {
        CommonWidget().showToaster(msg: 'Enter Otp');
        print("otp ${otpModel!.user![0].body!}");
        Get.to(ParentsOtpScreen());
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Phone Number');
      }
    } else {
      print('Please try again');
    }
  }


  Future<dynamic> ParentsVerifyOtp(
      {required BuildContext context, required String otp_controller}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpVerifyLoading(true);
    // String id_user = await PreferenceManager().getPref(URLConstants.id);
    //
    // print("UserId ${id_user}");
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
        await kids_signup(context: context);

        // await _loginScreenController.CreatorgetUserInfo_Email(UserId: id_user);
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
  RxList<Data_country> data_country = <Data_country>[].obs;
  Data_country? selectedcountry;

  Future<dynamic> getAllCountriesFromAPI() async {
    print('inside country list');
    iscountryLoading(true);
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
