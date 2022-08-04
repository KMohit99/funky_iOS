import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:funky_project/Authentication/authentication_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../chat/constants/firestore_constants.dart';
import '../../../custom_widget/page_loader.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../authentication_screen.dart';
import '../../creator_login/controller/creator_login_controller.dart';
import '../../creator_login/model/creator_loginModel.dart';
import 'package:http/http.dart' as http;

import '../../kids_login/model/parents_otp_model.dart';
import '../model/CountryModel.dart';
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
  TextEditingController gender_controller = new TextEditingController();
  TextEditingController reffralCode_controller = new TextEditingController();
  TextEditingController countryCode_controller = new TextEditingController();
  TextEditingController aboutMe_controller = new TextEditingController();

  RxBool isLoading = false.obs;
  LoginModel? loginModel;
  File? imgFile;

  // Future<dynamic> creator_signup(BuildContext context) async {
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
  //     'parent_email': '',
  //     'password': password_controller.text,
  //     'gender': gender_controller.text,
  //     'location': selected_country,
  //     'referral_code': reffralCode_controller.text,
  //     // 'image': photoBase64!,
  //     'image': img64!.substring(0, 100),
  //     'countryCode': selected_country_code,
  //     'about': aboutMe_controller.text,
  //     'type': 'creator',
  //   };
  //   // print(data);
  //   // String body = json.encode(data);
  //
  //   var url = ("http://foxyserver.com/funky/api/signup.php");
  //   print("url : $url");
  //   print("body : $data");
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: data,
  //   );
  //   // print(response.body);
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
  //       CommonWidget().showToaster(msg: 'Please verify the OTP');
  //       if(loginModel!.message == 'User Already Exists'){
  //         CommonWidget().showErrorToaster(msg: loginModel!.message!);
  //       }else{
  //         CommonWidget().showToaster(msg: loginModel!.message!);
  //         Get.to(CreatorOtpVerification());
  //         await CreatorsendOtp(context);
  //       }
  //
  //       // Get.to(Dashboard());
  //     } else {
  //       print('Please try again');
  //     }
  //   } else {
  //     print('Please try again');
  //   }
  // }
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<dynamic> creator_signup({required BuildContext context}) async {
    // showLoader(context);
    var url = URLConstants.base_url + URLConstants.SignUpApi;
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
    request.fields['parent_email'] = '';
    request.fields['password'] = password_controller.text;
    request.fields['gender'] = gender_controller.text;
    request.fields['location'] = selected_country!;
    request.fields['referral_code'] = reffralCode_controller.text;
    request.fields['countryCode'] = selected_country_code!;
    request.fields['about'] = aboutMe_controller.text;
    request.fields['type'] = 'creator';

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
        if (loginModel!.message == 'User Already Exists') {
          CommonWidget().showErrorToaster(msg: loginModel!.message!);
        } else {
          // CommonWidget().showToaster(msg: loginModel!.message!);

          final QuerySnapshot result = await firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .where(FirestoreConstants.id, isEqualTo: loginModel!.user![0].id)
              .get();
          final List<DocumentSnapshot> documents = result.docs;
          if (documents.isEmpty) {
            // Writing data to server because here is a new user
            firebaseFirestore
                .collection(FirestoreConstants.pathUserCollection)
                .doc(loginModel!.user![0].id)
                .set({
              FirestoreConstants.nickname: fullname_controller.text,
              FirestoreConstants.photoUrl:
                  "https://foxytechnologies.com/funky/images/${imgFile!.path.split('/').last}",
              FirestoreConstants.id: loginModel!.user![0].id,
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              FirestoreConstants.chattingWith: null
            });

            // Write data to local storage
            // User? currentUser = firebaseUser;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                FirestoreConstants.id, loginModel!.user![0].id!);
            await prefs.setString(
                FirestoreConstants.nickname, fullname_controller.text ?? "");
            await prefs.setString(
                FirestoreConstants.photoUrl,
                "https://foxytechnologies.com/funky/images/${imgFile!.path}" ??
                    "");
          }

          await Get.to(Dashboard(
            page: 0,
          ));
        }
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

  Future<dynamic> Update_user_profile({
    required BuildContext context,
    required String usertype,
    required String socialtype,
  }) async {
    // debugPrint('0-0-0-0-0-0-0 username');
    // // try {
    // //
    // // } catch (e) {
    // //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // // }
    // isLoading(true);
    // Map data = {
    //   'fullName': fullname_controller.text,
    //   'userName': username_controller.text,
    //   'email': email_controller.text,
    //   'phone': phone_controller.text,
    //   // 'parent_email': parentEmail_controller.text,
    //   // 'password': password_controller.text,
    //   'gender': selected_gender,
    //   'location': selectedcountry!.name,
    //   'referral_code': reffralCode_controller.text,
    //   'image': (_creator_login_screen_controller
    //           .userInfoModel_email!.data![0].profileUrl!.isNotEmpty
    //       ? _creator_login_screen_controller
    //           .userInfoModel_email!.data![0].profileUrl!
    //           .toString()
    //       : img64!.substring(0, 100)),
    //   // 'countryCode': countryCode_controller.text,
    //   'about': aboutMe_controller.text,
    //   'type': usertype,
    //   'social_type': socialtype
    // };
    // print(data);
    // // String body = json.encode(data);
    //
    // var url = ("http://foxyserver.com/funky/api/editProfile.php");
    // print("url : $url");
    // print("body : $data");
    //
    // var response = await http.post(
    //   Uri.parse(url),
    //   body: data,
    // );
    // print(response.body);
    // print(response.request);
    // print(response.statusCode);
    // // var final_data = jsonDecode(response.body);
    //
    // // print('final data $final_data');
    //
    // if (response.statusCode == 200) {
    //   isLoading(false);
    //   var data = jsonDecode(response.body);
    //   loginModel = LoginModel.fromJson(data);
    //   if (loginModel!.error == false) {
    //     CommonWidget().showToaster(msg: 'Please verify the OTP');
    //     Get.to(AuthenticationScreen());
    //     // await CreatorsendOtp(context);
    //     // Get.to(Dashboard());
    //   } else {
    //     print('Please try again');
    //   }
    // } else {
    //   print('Please try again');
    // }

    var url = '${URLConstants.base_url}editProfile.php';
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
    } else {
      var files = await http.MultipartFile.fromString(
          'image',
          // File(imgFile!.path).readAsBytes().asStream(),
          // File(imgFile!.path).lengthSync(),
          _creator_login_screen_controller
              .userInfoModel_email!.data![0].image!);
      request.files.add(files);
    }

    request.fields['fullName'] = fullname_controller.text;
    request.fields['userName'] = username_controller.text;
    request.fields['email'] = email_controller.text;
    request.fields['phone'] = phone_controller.text;
    request.fields['parent_email'] = '';
    request.fields['password'] = password_controller.text;
    request.fields['gender'] = gender_controller.text;
    request.fields['location'] = selected_country!;
    request.fields['referral_code'] = reffralCode_controller.text;
    request.fields['countryCode'] = selected_country_code!;
    request.fields['about'] = aboutMe_controller.text;
    request.fields['type'] = usertype;

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
        if (loginModel!.message == 'User Already Exists') {
          CommonWidget().showErrorToaster(msg: loginModel!.message!);
        } else {
          CommonWidget().showToaster(msg: loginModel!.message!);
          await Get.to(Dashboard(
            page: 0,
          ));
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

  Future<dynamic> CreatorsendOtp(BuildContext context) async {
    debugPrint('0-0-0-0-0-0-0 username');
    isotpLoading(true);
    Map data = {
      'email': email_controller.text,
      'phone': selected_country_code! + phone_controller.text
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
        Get.to(CreatorOtpVerification());

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
        CommonWidget().showToaster(msg: otpverifyModel!.message!);
        await creator_signup(context: context);
      } else {
        print('Please try again');
        CommonWidget().showErrorToaster(msg: 'Enter valid Otp');
      }
    } else {
      print('Please try again');
    }
  }

  CountryModel? countrymodelList;

  var getAllCountriesModelList = countryModel().obs;
  RxBool iscountryLoading = false.obs;

  List<CountryList> data_country = [];
  CountryList? selectedcountry;
  String? selected_country;
  String? selected_country_code = '+91';

  TextEditingController query_followers = TextEditingController();

  Future<void> getcountry() async {
    countrymodelList = CountryModel.fromJson({
      "countryList": [
        {"name": "Afghanistan", "dial_code": "+93", "code": "AF"},
        {"name": "Aland Islands", "dial_code": "+358", "code": "AX"},
        {"name": "Albania", "dial_code": "+355", "code": "AL"},
        {"name": "Algeria", "dial_code": "+213", "code": "DZ"},
        {"name": "AmericanSamoa", "dial_code": "+1 684", "code": "AS"},
        {"name": "Andorra", "dial_code": "+376", "code": "AD"},
        {"name": "Angola", "dial_code": "+244", "code": "AO"},
        {"name": "Anguilla", "dial_code": "+1 264", "code": "AI"},
        {"name": "Antarctica", "dial_code": "+672", "code": "AQ"},
        {"name": "Antigua and Barbuda", "dial_code": "+1 268", "code": "AG"},
        {"name": "Argentina", "dial_code": "+54", "code": "AR"},
        {"name": "Armenia", "dial_code": "+374", "code": "AM"},
        {"name": "Aruba", "dial_code": "+297", "code": "AW"},
        {"name": "Australia", "dial_code": "+61", "code": "AU"},
        {"name": "Austria", "dial_code": "+43", "code": "AT"},
        {"name": "Azerbaijan", "dial_code": "+994", "code": "AZ"},
        {"name": "Bahamas", "dial_code": "+1 242", "code": "BS"},
        {"name": "Bahrain", "dial_code": "+973", "code": "BH"},
        {"name": "Bangladesh", "dial_code": "+880", "code": "BD"},
        {"name": "Barbados", "dial_code": "+1 246", "code": "BB"},
        {"name": "Belarus", "dial_code": "+375", "code": "BY"},
        {"name": "Belgium", "dial_code": "+32", "code": "BE"},
        {"name": "Belize", "dial_code": "+501", "code": "BZ"},
        {"name": "Benin", "dial_code": "+229", "code": "BJ"},
        {"name": "Bermuda", "dial_code": "+1 441", "code": "BM"},
        {"name": "Bhutan", "dial_code": "+975", "code": "BT"},
        {
          "name": "Bolivia, Plurinational State of",
          "dial_code": "+591",
          "code": "BO"
        },
        {"name": "Bosnia and Herzegovina", "dial_code": "+387", "code": "BA"},
        {"name": "Botswana", "dial_code": "+267", "code": "BW"},
        {"name": "Brazil", "dial_code": "+55", "code": "BR"},
        {
          "name": "British Indian Ocean Territory",
          "dial_code": "+246",
          "code": "IO"
        },
        {"name": "Brunei Darussalam", "dial_code": "+673", "code": "BN"},
        {"name": "Bulgaria", "dial_code": "+359", "code": "BG"},
        {"name": "Burkina Faso", "dial_code": "+226", "code": "BF"},
        {"name": "Burundi", "dial_code": "+257", "code": "BI"},
        {"name": "Cambodia", "dial_code": "+855", "code": "KH"},
        {"name": "Cameroon", "dial_code": "+237", "code": "CM"},
        {"name": "Canada", "dial_code": "+1", "code": "CA"},
        {"name": "Cape Verde", "dial_code": "+238", "code": "CV"},
        {"name": "Cayman Islands", "dial_code": "+ 345", "code": "KY"},
        {"name": "Central African Republic", "dial_code": "+236", "code": "CF"},
        {"name": "Chad", "dial_code": "+235", "code": "TD"},
        {"name": "Chile", "dial_code": "+56", "code": "CL"},
        {"name": "China", "dial_code": "+86", "code": "CN"},
        {"name": "Christmas Island", "dial_code": "+61", "code": "CX"},
        {"name": "Cocos (Keeling) Islands", "dial_code": "+61", "code": "CC"},
        {"name": "Colombia", "dial_code": "+57", "code": "CO"},
        {"name": "Comoros", "dial_code": "+269", "code": "KM"},
        {"name": "Congo", "dial_code": "+242", "code": "CG"},
        {
          "name": "Congo, The Democratic Republic of the Congo",
          "dial_code": "+243",
          "code": "CD"
        },
        {"name": "Cook Islands", "dial_code": "+682", "code": "CK"},
        {"name": "Costa Rica", "dial_code": "+506", "code": "CR"},
        {"name": "Cote d'Ivoire", "dial_code": "+225", "code": "CI"},
        {"name": "Croatia", "dial_code": "+385", "code": "HR"},
        {"name": "Cuba", "dial_code": "+53", "code": "CU"},
        {"name": "Cyprus", "dial_code": "+357", "code": "CY"},
        {"name": "Czech Republic", "dial_code": "+420", "code": "CZ"},
        {"name": "Denmark", "dial_code": "+45", "code": "DK"},
        {"name": "Djibouti", "dial_code": "+253", "code": "DJ"},
        {"name": "Dominica", "dial_code": "+1 767", "code": "DM"},
        {"name": "Dominican Republic", "dial_code": "+1 849", "code": "DO"},
        {"name": "Ecuador", "dial_code": "+593", "code": "EC"},
        {"name": "Egypt", "dial_code": "+20", "code": "EG"},
        {"name": "El Salvador", "dial_code": "+503", "code": "SV"},
        {"name": "Equatorial Guinea", "dial_code": "+240", "code": "GQ"},
        {"name": "Eritrea", "dial_code": "+291", "code": "ER"},
        {"name": "Estonia", "dial_code": "+372", "code": "EE"},
        {"name": "Ethiopia", "dial_code": "+251", "code": "ET"},
        {
          "name": "Falkland Islands (Malvinas)",
          "dial_code": "+500",
          "code": "FK"
        },
        {"name": "Faroe Islands", "dial_code": "+298", "code": "FO"},
        {"name": "Fiji", "dial_code": "+679", "code": "FJ"},
        {"name": "Finland", "dial_code": "+358", "code": "FI"},
        {"name": "France", "dial_code": "+33", "code": "FR"},
        {"name": "French Guiana", "dial_code": "+594", "code": "GF"},
        {"name": "French Polynesia", "dial_code": "+689", "code": "PF"},
        {"name": "Gabon", "dial_code": "+241", "code": "GA"},
        {"name": "Gambia", "dial_code": "+220", "code": "GM"},
        {"name": "Georgia", "dial_code": "+995", "code": "GE"},
        {"name": "Germany", "dial_code": "+49", "code": "DE"},
        {"name": "Ghana", "dial_code": "+233", "code": "GH"},
        {"name": "Gibraltar", "dial_code": "+350", "code": "GI"},
        {"name": "Greece", "dial_code": "+30", "code": "GR"},
        {"name": "Greenland", "dial_code": "+299", "code": "GL"},
        {"name": "Grenada", "dial_code": "+1 473", "code": "GD"},
        {"name": "Guadeloupe", "dial_code": "+590", "code": "GP"},
        {"name": "Guam", "dial_code": "+1 671", "code": "GU"},
        {"name": "Guatemala", "dial_code": "+502", "code": "GT"},
        {"name": "Guernsey", "dial_code": "+44", "code": "GG"},
        {"name": "Guinea", "dial_code": "+224", "code": "GN"},
        {"name": "Guinea-Bissau", "dial_code": "+245", "code": "GW"},
        {"name": "Guyana", "dial_code": "+595", "code": "GY"},
        {"name": "Haiti", "dial_code": "+509", "code": "HT"},
        {
          "name": "Holy See (Vatican City State)",
          "dial_code": "+379",
          "code": "VA"
        },
        {"name": "Honduras", "dial_code": "+504", "code": "HN"},
        {"name": "Hong Kong", "dial_code": "+852", "code": "HK"},
        {"name": "Hungary", "dial_code": "+36", "code": "HU"},
        {"name": "Iceland", "dial_code": "+354", "code": "IS"},
        {"name": "India", "dial_code": "+91", "code": "IN"},
        {"name": "Indonesia", "dial_code": "+62", "code": "ID"},
        {
          "name": "Iran, Islamic Republic of Persian Gulf",
          "dial_code": "+98",
          "code": "IR"
        },
        {"name": "Iraq", "dial_code": "+964", "code": "IQ"},
        {"name": "Ireland", "dial_code": "+353", "code": "IE"},
        {"name": "Isle of Man", "dial_code": "+44", "code": "IM"},
        {"name": "Israel", "dial_code": "+972", "code": "IL"},
        {"name": "Italy", "dial_code": "+39", "code": "IT"},
        {"name": "Jamaica", "dial_code": "+1 876", "code": "JM"},
        {"name": "Japan", "dial_code": "+81", "code": "JP"},
        {"name": "Jersey", "dial_code": "+44", "code": "JE"},
        {"name": "Jordan", "dial_code": "+962", "code": "JO"},
        {"name": "Kazakhstan", "dial_code": "+77", "code": "KZ"},
        {"name": "Kenya", "dial_code": "+254", "code": "KE"},
        {"name": "Kiribati", "dial_code": "+686", "code": "KI"},
        {
          "name": "Korea, Democratic People's Republic of Korea",
          "dial_code": "+850",
          "code": "KP"
        },
        {
          "name": "Korea, Republic of South Korea",
          "dial_code": "+82",
          "code": "KR"
        },
        {"name": "Kuwait", "dial_code": "+965", "code": "KW"},
        {"name": "Kyrgyzstan", "dial_code": "+996", "code": "KG"},
        {"name": "Laos", "dial_code": "+856", "code": "LA"},
        {"name": "Latvia", "dial_code": "+371", "code": "LV"},
        {"name": "Lebanon", "dial_code": "+961", "code": "LB"},
        {"name": "Lesotho", "dial_code": "+266", "code": "LS"},
        {"name": "Liberia", "dial_code": "+231", "code": "LR"},
        {"name": "Libyan Arab Jamahiriya", "dial_code": "+218", "code": "LY"},
        {"name": "Liechtenstein", "dial_code": "+423", "code": "LI"},
        {"name": "Lithuania", "dial_code": "+370", "code": "LT"},
        {"name": "Luxembourg", "dial_code": "+352", "code": "LU"},
        {"name": "Macao", "dial_code": "+853", "code": "MO"},
        {"name": "Macedonia", "dial_code": "+389", "code": "MK"},
        {"name": "Madagascar", "dial_code": "+261", "code": "MG"},
        {"name": "Malawi", "dial_code": "+265", "code": "MW"},
        {"name": "Malaysia", "dial_code": "+60", "code": "MY"},
        {"name": "Maldives", "dial_code": "+960", "code": "MV"},
        {"name": "Mali", "dial_code": "+223", "code": "ML"},
        {"name": "Malta", "dial_code": "+356", "code": "MT"},
        {"name": "Marshall Islands", "dial_code": "+692", "code": "MH"},
        {"name": "Martinique", "dial_code": "+596", "code": "MQ"},
        {"name": "Mauritania", "dial_code": "+222", "code": "MR"},
        {"name": "Mauritius", "dial_code": "+230", "code": "MU"},
        {"name": "Mayotte", "dial_code": "+262", "code": "YT"},
        {"name": "Mexico", "dial_code": "+52", "code": "MX"},
        {
          "name": "Micronesia, Federated States of Micronesia",
          "dial_code": "+691",
          "code": "FM"
        },
        {"name": "Moldova", "dial_code": "+373", "code": "MD"},
        {"name": "Monaco", "dial_code": "+377", "code": "MC"},
        {"name": "Mongolia", "dial_code": "+976", "code": "MN"},
        {"name": "Montenegro", "dial_code": "+382", "code": "ME"},
        {"name": "Montserrat", "dial_code": "+1 664", "code": "MS"},
        {"name": "Morocco", "dial_code": "+212", "code": "MA"},
        {"name": "Mozambique", "dial_code": "+258", "code": "MZ"},
        {"name": "Myanmar", "dial_code": "+95", "code": "MM"},
        {"name": "Namibia", "dial_code": "+264", "code": "NA"},
        {"name": "Nauru", "dial_code": "+674", "code": "NR"},
        {"name": "Nepal", "dial_code": "+977", "code": "NP"},
        {"name": "Netherlands", "dial_code": "+31", "code": "NL"},
        {"name": "Netherlands Antilles", "dial_code": "+599", "code": "AN"},
        {"name": "New Caledonia", "dial_code": "+687", "code": "NC"},
        {"name": "New Zealand", "dial_code": "+64", "code": "NZ"},
        {"name": "Nicaragua", "dial_code": "+505", "code": "NI"},
        {"name": "Niger", "dial_code": "+227", "code": "NE"},
        {"name": "Nigeria", "dial_code": "+234", "code": "NG"},
        {"name": "Niue", "dial_code": "+683", "code": "NU"},
        {"name": "Norfolk Island", "dial_code": "+672", "code": "NF"},
        {
          "name": "Northern Mariana Islands",
          "dial_code": "+1 670",
          "code": "MP"
        },
        {"name": "Norway", "dial_code": "+47", "code": "NO"},
        {"name": "Oman", "dial_code": "+968", "code": "OM"},
        {"name": "Pakistan", "dial_code": "+92", "code": "PK"},
        {"name": "Palau", "dial_code": "+680", "code": "PW"},
        {
          "name": "Palestinian Territory, Occupied",
          "dial_code": "+970",
          "code": "PS"
        },
        {"name": "Panama", "dial_code": "+507", "code": "PA"},
        {"name": "Papua New Guinea", "dial_code": "+675", "code": "PG"},
        {"name": "Paraguay", "dial_code": "+595", "code": "PY"},
        {"name": "Peru", "dial_code": "+51", "code": "PE"},
        {"name": "Philippines", "dial_code": "+63", "code": "PH"},
        {"name": "Pitcairn", "dial_code": "+872", "code": "PN"},
        {"name": "Poland", "dial_code": "+48", "code": "PL"},
        {"name": "Portugal", "dial_code": "+351", "code": "PT"},
        {"name": "Puerto Rico", "dial_code": "+1 939", "code": "PR"},
        {"name": "Qatar", "dial_code": "+974", "code": "QA"},
        {"name": "Romania", "dial_code": "+40", "code": "RO"},
        {"name": "Russia", "dial_code": "+7", "code": "RU"},
        {"name": "Rwanda", "dial_code": "+250", "code": "RW"},
        {"name": "Reunion", "dial_code": "+262", "code": "RE"},
        {"name": "Saint Barthelemy", "dial_code": "+590", "code": "BL"},
        {
          "name": "Saint Helena, Ascension and Tristan Da Cunha",
          "dial_code": "+290",
          "code": "SH"
        },
        {"name": "Saint Kitts and Nevis", "dial_code": "+1 869", "code": "KN"},
        {"name": "Saint Lucia", "dial_code": "+1 758", "code": "LC"},
        {"name": "Saint Martin", "dial_code": "+590", "code": "MF"},
        {
          "name": "Saint Pierre and Miquelon",
          "dial_code": "+508",
          "code": "PM"
        },
        {
          "name": "Saint Vincent and the Grenadines",
          "dial_code": "+1 784",
          "code": "VC"
        },
        {"name": "Samoa", "dial_code": "+685", "code": "WS"},
        {"name": "San Marino", "dial_code": "+378", "code": "SM"},
        {"name": "Sao Tome and Principe", "dial_code": "+239", "code": "ST"},
        {"name": "Saudi Arabia", "dial_code": "+966", "code": "SA"},
        {"name": "Senegal", "dial_code": "+221", "code": "SN"},
        {"name": "Serbia", "dial_code": "+381", "code": "RS"},
        {"name": "Seychelles", "dial_code": "+248", "code": "SC"},
        {"name": "Sierra Leone", "dial_code": "+232", "code": "SL"},
        {"name": "Singapore", "dial_code": "+65", "code": "SG"},
        {"name": "Slovakia", "dial_code": "+421", "code": "SK"},
        {"name": "Slovenia", "dial_code": "+386", "code": "SI"},
        {"name": "Solomon Islands", "dial_code": "+677", "code": "SB"},
        {"name": "Somalia", "dial_code": "+252", "code": "SO"},
        {"name": "South Africa", "dial_code": "+27", "code": "ZA"},
        {"name": "South Sudan", "dial_code": "+211", "code": "SS"},
        {
          "name": "South Georgia and the South Sandwich Islands",
          "dial_code": "+500",
          "code": "GS"
        },
        {"name": "Spain", "dial_code": "+34", "code": "ES"},
        {"name": "Sri Lanka", "dial_code": "+94", "code": "LK"},
        {"name": "Sudan", "dial_code": "+249", "code": "SD"},
        {"name": "Suriname", "dial_code": "+597", "code": "SR"},
        {"name": "Svalbard and Jan Mayen", "dial_code": "+47", "code": "SJ"},
        {"name": "Swaziland", "dial_code": "+268", "code": "SZ"},
        {"name": "Sweden", "dial_code": "+46", "code": "SE"},
        {"name": "Switzerland", "dial_code": "+41", "code": "CH"},
        {"name": "Syrian Arab Republic", "dial_code": "+963", "code": "SY"},
        {"name": "Taiwan", "dial_code": "+886", "code": "TW"},
        {"name": "Tajikistan", "dial_code": "+992", "code": "TJ"},
        {
          "name": "Tanzania, United Republic of Tanzania",
          "dial_code": "+255",
          "code": "TZ"
        },
        {"name": "Thailand", "dial_code": "+66", "code": "TH"},
        {"name": "Timor-Leste", "dial_code": "+670", "code": "TL"},
        {"name": "Togo", "dial_code": "+228", "code": "TG"},
        {"name": "Tokelau", "dial_code": "+690", "code": "TK"},
        {"name": "Tonga", "dial_code": "+676", "code": "TO"},
        {"name": "Trinidad and Tobago", "dial_code": "+1 868", "code": "TT"},
        {"name": "Tunisia", "dial_code": "+216", "code": "TN"},
        {"name": "Turkey", "dial_code": "+90", "code": "TR"},
        {"name": "Turkmenistan", "dial_code": "+993", "code": "TM"},
        {
          "name": "Turks and Caicos Islands",
          "dial_code": "+1 649",
          "code": "TC"
        },
        {"name": "Tuvalu", "dial_code": "+688", "code": "TV"},
        {"name": "Uganda", "dial_code": "+256", "code": "UG"},
        {"name": "Ukraine", "dial_code": "+380", "code": "UA"},
        {"name": "United Arab Emirates", "dial_code": "+971", "code": "AE"},
        {"name": "United Kingdom", "dial_code": "+44", "code": "GB"},
        {"name": "United States", "dial_code": "+1", "code": "US"},
        {"name": "Uruguay", "dial_code": "+598", "code": "UY"},
        {"name": "Uzbekistan", "dial_code": "+998", "code": "UZ"},
        {"name": "Vanuatu", "dial_code": "+678", "code": "VU"},
        {
          "name": "Venezuela, Bolivarian Republic of Venezuela",
          "dial_code": "+58",
          "code": "VE"
        },
        {"name": "Vietnam", "dial_code": "+84", "code": "VN"},
        {
          "name": "Virgin Islands, British",
          "dial_code": "+1 284",
          "code": "VG"
        },
        {"name": "Virgin Islands, U.S.", "dial_code": "+1 340", "code": "VI"},
        {"name": "Wallis and Futuna", "dial_code": "+681", "code": "WF"},
        {"name": "Yemen", "dial_code": "+967", "code": "YE"},
        {"name": "Zambia", "dial_code": "+260", "code": "ZM"},
        {"name": "Zimbabwe", "dial_code": "+263", "code": "ZW"}
      ]
    });
    data_country = countrymodelList!.countryList!;
    print(data_country);
  }

  Future<List<CountryList>> getAllCountriesFromAPI(String query) async {
    // iscountryLoading(true);
    // print('inside xountry');
    // String url = (URLConstants.base_url + URLConstants.CountryListApi);
    //
    // // debugPrint('Get Sales Token ${tokens.toString()}');
    // try {
    //   http.Response response = await http.get(Uri.parse(url));
    //
    //   print('Response request: ${response.request}');
    //   print('Response status: ${response.statusCode}');
    //   print('Response body: ${response.body}');
    //   var data = jsonDecode(response.body);
    //
    //   if (response == null) {
    //     return null;
    //   } else if (response.statusCode == 200) {
    //     final status = data["success"];
    //     countrymodelList = countryModel.fromJson(data);
    //     getAllCountriesModelList(countrymodelList);
    //     if (countrymodelList!.error == false) {
    //       debugPrint(
    //           '2-2-2-2-2-2 Inside the product Controller Details ${countrymodelList!.data!.length}');
    //       iscountryLoading(false);
    //       data_country = getAllCountriesModelList.value.data!.obs;
    //       print("data ${data_country}");
    //       return countrymodelList;
    //     } else {
    //       CommonWidget().showToaster(msg: 'Error');
    //       return null;
    //     }
    //   } else if (response.statusCode == 422) {
    //     CommonWidget().showToaster(msg: "Error 422");
    //   } else {
    //     CommonWidget().showToaster(msg: '');
    //   }
    // } catch (e) {
    //   print('1-1-1-1 Get Purchase ${e.toString()}');
    // }

    countrymodelList = CountryModel.fromJson({
      "countryList": [
        {"name": "Afghanistan", "dial_code": "+93", "code": "AF"},
        {"name": "Aland Islands", "dial_code": "+358", "code": "AX"},
        {"name": "Albania", "dial_code": "+355", "code": "AL"},
        {"name": "Algeria", "dial_code": "+213", "code": "DZ"},
        {"name": "AmericanSamoa", "dial_code": "+1 684", "code": "AS"},
        {"name": "Andorra", "dial_code": "+376", "code": "AD"},
        {"name": "Angola", "dial_code": "+244", "code": "AO"},
        {"name": "Anguilla", "dial_code": "+1 264", "code": "AI"},
        {"name": "Antarctica", "dial_code": "+672", "code": "AQ"},
        {"name": "Antigua and Barbuda", "dial_code": "+1 268", "code": "AG"},
        {"name": "Argentina", "dial_code": "+54", "code": "AR"},
        {"name": "Armenia", "dial_code": "+374", "code": "AM"},
        {"name": "Aruba", "dial_code": "+297", "code": "AW"},
        {"name": "Australia", "dial_code": "+61", "code": "AU"},
        {"name": "Austria", "dial_code": "+43", "code": "AT"},
        {"name": "Azerbaijan", "dial_code": "+994", "code": "AZ"},
        {"name": "Bahamas", "dial_code": "+1 242", "code": "BS"},
        {"name": "Bahrain", "dial_code": "+973", "code": "BH"},
        {"name": "Bangladesh", "dial_code": "+880", "code": "BD"},
        {"name": "Barbados", "dial_code": "+1 246", "code": "BB"},
        {"name": "Belarus", "dial_code": "+375", "code": "BY"},
        {"name": "Belgium", "dial_code": "+32", "code": "BE"},
        {"name": "Belize", "dial_code": "+501", "code": "BZ"},
        {"name": "Benin", "dial_code": "+229", "code": "BJ"},
        {"name": "Bermuda", "dial_code": "+1 441", "code": "BM"},
        {"name": "Bhutan", "dial_code": "+975", "code": "BT"},
        {
          "name": "Bolivia, Plurinational State of",
          "dial_code": "+591",
          "code": "BO"
        },
        {"name": "Bosnia and Herzegovina", "dial_code": "+387", "code": "BA"},
        {"name": "Botswana", "dial_code": "+267", "code": "BW"},
        {"name": "Brazil", "dial_code": "+55", "code": "BR"},
        {
          "name": "British Indian Ocean Territory",
          "dial_code": "+246",
          "code": "IO"
        },
        {"name": "Brunei Darussalam", "dial_code": "+673", "code": "BN"},
        {"name": "Bulgaria", "dial_code": "+359", "code": "BG"},
        {"name": "Burkina Faso", "dial_code": "+226", "code": "BF"},
        {"name": "Burundi", "dial_code": "+257", "code": "BI"},
        {"name": "Cambodia", "dial_code": "+855", "code": "KH"},
        {"name": "Cameroon", "dial_code": "+237", "code": "CM"},
        {"name": "Canada", "dial_code": "+1", "code": "CA"},
        {"name": "Cape Verde", "dial_code": "+238", "code": "CV"},
        {"name": "Cayman Islands", "dial_code": "+ 345", "code": "KY"},
        {"name": "Central African Republic", "dial_code": "+236", "code": "CF"},
        {"name": "Chad", "dial_code": "+235", "code": "TD"},
        {"name": "Chile", "dial_code": "+56", "code": "CL"},
        {"name": "China", "dial_code": "+86", "code": "CN"},
        {"name": "Christmas Island", "dial_code": "+61", "code": "CX"},
        {"name": "Cocos (Keeling) Islands", "dial_code": "+61", "code": "CC"},
        {"name": "Colombia", "dial_code": "+57", "code": "CO"},
        {"name": "Comoros", "dial_code": "+269", "code": "KM"},
        {"name": "Congo", "dial_code": "+242", "code": "CG"},
        {
          "name": "Congo, The Democratic Republic of the Congo",
          "dial_code": "+243",
          "code": "CD"
        },
        {"name": "Cook Islands", "dial_code": "+682", "code": "CK"},
        {"name": "Costa Rica", "dial_code": "+506", "code": "CR"},
        {"name": "Cote d'Ivoire", "dial_code": "+225", "code": "CI"},
        {"name": "Croatia", "dial_code": "+385", "code": "HR"},
        {"name": "Cuba", "dial_code": "+53", "code": "CU"},
        {"name": "Cyprus", "dial_code": "+357", "code": "CY"},
        {"name": "Czech Republic", "dial_code": "+420", "code": "CZ"},
        {"name": "Denmark", "dial_code": "+45", "code": "DK"},
        {"name": "Djibouti", "dial_code": "+253", "code": "DJ"},
        {"name": "Dominica", "dial_code": "+1 767", "code": "DM"},
        {"name": "Dominican Republic", "dial_code": "+1 849", "code": "DO"},
        {"name": "Ecuador", "dial_code": "+593", "code": "EC"},
        {"name": "Egypt", "dial_code": "+20", "code": "EG"},
        {"name": "El Salvador", "dial_code": "+503", "code": "SV"},
        {"name": "Equatorial Guinea", "dial_code": "+240", "code": "GQ"},
        {"name": "Eritrea", "dial_code": "+291", "code": "ER"},
        {"name": "Estonia", "dial_code": "+372", "code": "EE"},
        {"name": "Ethiopia", "dial_code": "+251", "code": "ET"},
        {
          "name": "Falkland Islands (Malvinas)",
          "dial_code": "+500",
          "code": "FK"
        },
        {"name": "Faroe Islands", "dial_code": "+298", "code": "FO"},
        {"name": "Fiji", "dial_code": "+679", "code": "FJ"},
        {"name": "Finland", "dial_code": "+358", "code": "FI"},
        {"name": "France", "dial_code": "+33", "code": "FR"},
        {"name": "French Guiana", "dial_code": "+594", "code": "GF"},
        {"name": "French Polynesia", "dial_code": "+689", "code": "PF"},
        {"name": "Gabon", "dial_code": "+241", "code": "GA"},
        {"name": "Gambia", "dial_code": "+220", "code": "GM"},
        {"name": "Georgia", "dial_code": "+995", "code": "GE"},
        {"name": "Germany", "dial_code": "+49", "code": "DE"},
        {"name": "Ghana", "dial_code": "+233", "code": "GH"},
        {"name": "Gibraltar", "dial_code": "+350", "code": "GI"},
        {"name": "Greece", "dial_code": "+30", "code": "GR"},
        {"name": "Greenland", "dial_code": "+299", "code": "GL"},
        {"name": "Grenada", "dial_code": "+1 473", "code": "GD"},
        {"name": "Guadeloupe", "dial_code": "+590", "code": "GP"},
        {"name": "Guam", "dial_code": "+1 671", "code": "GU"},
        {"name": "Guatemala", "dial_code": "+502", "code": "GT"},
        {"name": "Guernsey", "dial_code": "+44", "code": "GG"},
        {"name": "Guinea", "dial_code": "+224", "code": "GN"},
        {"name": "Guinea-Bissau", "dial_code": "+245", "code": "GW"},
        {"name": "Guyana", "dial_code": "+595", "code": "GY"},
        {"name": "Haiti", "dial_code": "+509", "code": "HT"},
        {
          "name": "Holy See (Vatican City State)",
          "dial_code": "+379",
          "code": "VA"
        },
        {"name": "Honduras", "dial_code": "+504", "code": "HN"},
        {"name": "Hong Kong", "dial_code": "+852", "code": "HK"},
        {"name": "Hungary", "dial_code": "+36", "code": "HU"},
        {"name": "Iceland", "dial_code": "+354", "code": "IS"},
        {"name": "India", "dial_code": "+91", "code": "IN"},
        {"name": "Indonesia", "dial_code": "+62", "code": "ID"},
        {
          "name": "Iran, Islamic Republic of Persian Gulf",
          "dial_code": "+98",
          "code": "IR"
        },
        {"name": "Iraq", "dial_code": "+964", "code": "IQ"},
        {"name": "Ireland", "dial_code": "+353", "code": "IE"},
        {"name": "Isle of Man", "dial_code": "+44", "code": "IM"},
        {"name": "Israel", "dial_code": "+972", "code": "IL"},
        {"name": "Italy", "dial_code": "+39", "code": "IT"},
        {"name": "Jamaica", "dial_code": "+1 876", "code": "JM"},
        {"name": "Japan", "dial_code": "+81", "code": "JP"},
        {"name": "Jersey", "dial_code": "+44", "code": "JE"},
        {"name": "Jordan", "dial_code": "+962", "code": "JO"},
        {"name": "Kazakhstan", "dial_code": "+77", "code": "KZ"},
        {"name": "Kenya", "dial_code": "+254", "code": "KE"},
        {"name": "Kiribati", "dial_code": "+686", "code": "KI"},
        {
          "name": "Korea, Democratic People's Republic of Korea",
          "dial_code": "+850",
          "code": "KP"
        },
        {
          "name": "Korea, Republic of South Korea",
          "dial_code": "+82",
          "code": "KR"
        },
        {"name": "Kuwait", "dial_code": "+965", "code": "KW"},
        {"name": "Kyrgyzstan", "dial_code": "+996", "code": "KG"},
        {"name": "Laos", "dial_code": "+856", "code": "LA"},
        {"name": "Latvia", "dial_code": "+371", "code": "LV"},
        {"name": "Lebanon", "dial_code": "+961", "code": "LB"},
        {"name": "Lesotho", "dial_code": "+266", "code": "LS"},
        {"name": "Liberia", "dial_code": "+231", "code": "LR"},
        {"name": "Libyan Arab Jamahiriya", "dial_code": "+218", "code": "LY"},
        {"name": "Liechtenstein", "dial_code": "+423", "code": "LI"},
        {"name": "Lithuania", "dial_code": "+370", "code": "LT"},
        {"name": "Luxembourg", "dial_code": "+352", "code": "LU"},
        {"name": "Macao", "dial_code": "+853", "code": "MO"},
        {"name": "Macedonia", "dial_code": "+389", "code": "MK"},
        {"name": "Madagascar", "dial_code": "+261", "code": "MG"},
        {"name": "Malawi", "dial_code": "+265", "code": "MW"},
        {"name": "Malaysia", "dial_code": "+60", "code": "MY"},
        {"name": "Maldives", "dial_code": "+960", "code": "MV"},
        {"name": "Mali", "dial_code": "+223", "code": "ML"},
        {"name": "Malta", "dial_code": "+356", "code": "MT"},
        {"name": "Marshall Islands", "dial_code": "+692", "code": "MH"},
        {"name": "Martinique", "dial_code": "+596", "code": "MQ"},
        {"name": "Mauritania", "dial_code": "+222", "code": "MR"},
        {"name": "Mauritius", "dial_code": "+230", "code": "MU"},
        {"name": "Mayotte", "dial_code": "+262", "code": "YT"},
        {"name": "Mexico", "dial_code": "+52", "code": "MX"},
        {
          "name": "Micronesia, Federated States of Micronesia",
          "dial_code": "+691",
          "code": "FM"
        },
        {"name": "Moldova", "dial_code": "+373", "code": "MD"},
        {"name": "Monaco", "dial_code": "+377", "code": "MC"},
        {"name": "Mongolia", "dial_code": "+976", "code": "MN"},
        {"name": "Montenegro", "dial_code": "+382", "code": "ME"},
        {"name": "Montserrat", "dial_code": "+1 664", "code": "MS"},
        {"name": "Morocco", "dial_code": "+212", "code": "MA"},
        {"name": "Mozambique", "dial_code": "+258", "code": "MZ"},
        {"name": "Myanmar", "dial_code": "+95", "code": "MM"},
        {"name": "Namibia", "dial_code": "+264", "code": "NA"},
        {"name": "Nauru", "dial_code": "+674", "code": "NR"},
        {"name": "Nepal", "dial_code": "+977", "code": "NP"},
        {"name": "Netherlands", "dial_code": "+31", "code": "NL"},
        {"name": "Netherlands Antilles", "dial_code": "+599", "code": "AN"},
        {"name": "New Caledonia", "dial_code": "+687", "code": "NC"},
        {"name": "New Zealand", "dial_code": "+64", "code": "NZ"},
        {"name": "Nicaragua", "dial_code": "+505", "code": "NI"},
        {"name": "Niger", "dial_code": "+227", "code": "NE"},
        {"name": "Nigeria", "dial_code": "+234", "code": "NG"},
        {"name": "Niue", "dial_code": "+683", "code": "NU"},
        {"name": "Norfolk Island", "dial_code": "+672", "code": "NF"},
        {
          "name": "Northern Mariana Islands",
          "dial_code": "+1 670",
          "code": "MP"
        },
        {"name": "Norway", "dial_code": "+47", "code": "NO"},
        {"name": "Oman", "dial_code": "+968", "code": "OM"},
        {"name": "Pakistan", "dial_code": "+92", "code": "PK"},
        {"name": "Palau", "dial_code": "+680", "code": "PW"},
        {
          "name": "Palestinian Territory, Occupied",
          "dial_code": "+970",
          "code": "PS"
        },
        {"name": "Panama", "dial_code": "+507", "code": "PA"},
        {"name": "Papua New Guinea", "dial_code": "+675", "code": "PG"},
        {"name": "Paraguay", "dial_code": "+595", "code": "PY"},
        {"name": "Peru", "dial_code": "+51", "code": "PE"},
        {"name": "Philippines", "dial_code": "+63", "code": "PH"},
        {"name": "Pitcairn", "dial_code": "+872", "code": "PN"},
        {"name": "Poland", "dial_code": "+48", "code": "PL"},
        {"name": "Portugal", "dial_code": "+351", "code": "PT"},
        {"name": "Puerto Rico", "dial_code": "+1 939", "code": "PR"},
        {"name": "Qatar", "dial_code": "+974", "code": "QA"},
        {"name": "Romania", "dial_code": "+40", "code": "RO"},
        {"name": "Russia", "dial_code": "+7", "code": "RU"},
        {"name": "Rwanda", "dial_code": "+250", "code": "RW"},
        {"name": "Reunion", "dial_code": "+262", "code": "RE"},
        {"name": "Saint Barthelemy", "dial_code": "+590", "code": "BL"},
        {
          "name": "Saint Helena, Ascension and Tristan Da Cunha",
          "dial_code": "+290",
          "code": "SH"
        },
        {"name": "Saint Kitts and Nevis", "dial_code": "+1 869", "code": "KN"},
        {"name": "Saint Lucia", "dial_code": "+1 758", "code": "LC"},
        {"name": "Saint Martin", "dial_code": "+590", "code": "MF"},
        {
          "name": "Saint Pierre and Miquelon",
          "dial_code": "+508",
          "code": "PM"
        },
        {
          "name": "Saint Vincent and the Grenadines",
          "dial_code": "+1 784",
          "code": "VC"
        },
        {"name": "Samoa", "dial_code": "+685", "code": "WS"},
        {"name": "San Marino", "dial_code": "+378", "code": "SM"},
        {"name": "Sao Tome and Principe", "dial_code": "+239", "code": "ST"},
        {"name": "Saudi Arabia", "dial_code": "+966", "code": "SA"},
        {"name": "Senegal", "dial_code": "+221", "code": "SN"},
        {"name": "Serbia", "dial_code": "+381", "code": "RS"},
        {"name": "Seychelles", "dial_code": "+248", "code": "SC"},
        {"name": "Sierra Leone", "dial_code": "+232", "code": "SL"},
        {"name": "Singapore", "dial_code": "+65", "code": "SG"},
        {"name": "Slovakia", "dial_code": "+421", "code": "SK"},
        {"name": "Slovenia", "dial_code": "+386", "code": "SI"},
        {"name": "Solomon Islands", "dial_code": "+677", "code": "SB"},
        {"name": "Somalia", "dial_code": "+252", "code": "SO"},
        {"name": "South Africa", "dial_code": "+27", "code": "ZA"},
        {"name": "South Sudan", "dial_code": "+211", "code": "SS"},
        {
          "name": "South Georgia and the South Sandwich Islands",
          "dial_code": "+500",
          "code": "GS"
        },
        {"name": "Spain", "dial_code": "+34", "code": "ES"},
        {"name": "Sri Lanka", "dial_code": "+94", "code": "LK"},
        {"name": "Sudan", "dial_code": "+249", "code": "SD"},
        {"name": "Suriname", "dial_code": "+597", "code": "SR"},
        {"name": "Svalbard and Jan Mayen", "dial_code": "+47", "code": "SJ"},
        {"name": "Swaziland", "dial_code": "+268", "code": "SZ"},
        {"name": "Sweden", "dial_code": "+46", "code": "SE"},
        {"name": "Switzerland", "dial_code": "+41", "code": "CH"},
        {"name": "Syrian Arab Republic", "dial_code": "+963", "code": "SY"},
        {"name": "Taiwan", "dial_code": "+886", "code": "TW"},
        {"name": "Tajikistan", "dial_code": "+992", "code": "TJ"},
        {
          "name": "Tanzania, United Republic of Tanzania",
          "dial_code": "+255",
          "code": "TZ"
        },
        {"name": "Thailand", "dial_code": "+66", "code": "TH"},
        {"name": "Timor-Leste", "dial_code": "+670", "code": "TL"},
        {"name": "Togo", "dial_code": "+228", "code": "TG"},
        {"name": "Tokelau", "dial_code": "+690", "code": "TK"},
        {"name": "Tonga", "dial_code": "+676", "code": "TO"},
        {"name": "Trinidad and Tobago", "dial_code": "+1 868", "code": "TT"},
        {"name": "Tunisia", "dial_code": "+216", "code": "TN"},
        {"name": "Turkey", "dial_code": "+90", "code": "TR"},
        {"name": "Turkmenistan", "dial_code": "+993", "code": "TM"},
        {
          "name": "Turks and Caicos Islands",
          "dial_code": "+1 649",
          "code": "TC"
        },
        {"name": "Tuvalu", "dial_code": "+688", "code": "TV"},
        {"name": "Uganda", "dial_code": "+256", "code": "UG"},
        {"name": "Ukraine", "dial_code": "+380", "code": "UA"},
        {"name": "United Arab Emirates", "dial_code": "+971", "code": "AE"},
        {"name": "United Kingdom", "dial_code": "+44", "code": "GB"},
        {"name": "United States", "dial_code": "+1", "code": "US"},
        {"name": "Uruguay", "dial_code": "+598", "code": "UY"},
        {"name": "Uzbekistan", "dial_code": "+998", "code": "UZ"},
        {"name": "Vanuatu", "dial_code": "+678", "code": "VU"},
        {
          "name": "Venezuela, Bolivarian Republic of Venezuela",
          "dial_code": "+58",
          "code": "VE"
        },
        {"name": "Vietnam", "dial_code": "+84", "code": "VN"},
        {
          "name": "Virgin Islands, British",
          "dial_code": "+1 284",
          "code": "VG"
        },
        {"name": "Virgin Islands, U.S.", "dial_code": "+1 340", "code": "VI"},
        {"name": "Wallis and Futuna", "dial_code": "+681", "code": "WF"},
        {"name": "Yemen", "dial_code": "+967", "code": "YE"},
        {"name": "Zambia", "dial_code": "+260", "code": "ZM"},
        {"name": "Zimbabwe", "dial_code": "+263", "code": "ZW"}
      ]
    });
    var data = {
      "countryList": [
        {"name": "Afghanistan", "dial_code": "+93", "code": "AF"},
        {"name": "Aland Islands", "dial_code": "+358", "code": "AX"},
        {"name": "Albania", "dial_code": "+355", "code": "AL"},
        {"name": "Algeria", "dial_code": "+213", "code": "DZ"},
        {"name": "AmericanSamoa", "dial_code": "+1 684", "code": "AS"},
        {"name": "Andorra", "dial_code": "+376", "code": "AD"},
        {"name": "Angola", "dial_code": "+244", "code": "AO"},
        {"name": "Anguilla", "dial_code": "+1 264", "code": "AI"},
        {"name": "Antarctica", "dial_code": "+672", "code": "AQ"},
        {"name": "Antigua and Barbuda", "dial_code": "+1 268", "code": "AG"},
        {"name": "Argentina", "dial_code": "+54", "code": "AR"},
        {"name": "Armenia", "dial_code": "+374", "code": "AM"},
        {"name": "Aruba", "dial_code": "+297", "code": "AW"},
        {"name": "Australia", "dial_code": "+61", "code": "AU"},
        {"name": "Austria", "dial_code": "+43", "code": "AT"},
        {"name": "Azerbaijan", "dial_code": "+994", "code": "AZ"},
        {"name": "Bahamas", "dial_code": "+1 242", "code": "BS"},
        {"name": "Bahrain", "dial_code": "+973", "code": "BH"},
        {"name": "Bangladesh", "dial_code": "+880", "code": "BD"},
        {"name": "Barbados", "dial_code": "+1 246", "code": "BB"},
        {"name": "Belarus", "dial_code": "+375", "code": "BY"},
        {"name": "Belgium", "dial_code": "+32", "code": "BE"},
        {"name": "Belize", "dial_code": "+501", "code": "BZ"},
        {"name": "Benin", "dial_code": "+229", "code": "BJ"},
        {"name": "Bermuda", "dial_code": "+1 441", "code": "BM"},
        {"name": "Bhutan", "dial_code": "+975", "code": "BT"},
        {
          "name": "Bolivia, Plurinational State of",
          "dial_code": "+591",
          "code": "BO"
        },
        {"name": "Bosnia and Herzegovina", "dial_code": "+387", "code": "BA"},
        {"name": "Botswana", "dial_code": "+267", "code": "BW"},
        {"name": "Brazil", "dial_code": "+55", "code": "BR"},
        {
          "name": "British Indian Ocean Territory",
          "dial_code": "+246",
          "code": "IO"
        },
        {"name": "Brunei Darussalam", "dial_code": "+673", "code": "BN"},
        {"name": "Bulgaria", "dial_code": "+359", "code": "BG"},
        {"name": "Burkina Faso", "dial_code": "+226", "code": "BF"},
        {"name": "Burundi", "dial_code": "+257", "code": "BI"},
        {"name": "Cambodia", "dial_code": "+855", "code": "KH"},
        {"name": "Cameroon", "dial_code": "+237", "code": "CM"},
        {"name": "Canada", "dial_code": "+1", "code": "CA"},
        {"name": "Cape Verde", "dial_code": "+238", "code": "CV"},
        {"name": "Cayman Islands", "dial_code": "+ 345", "code": "KY"},
        {"name": "Central African Republic", "dial_code": "+236", "code": "CF"},
        {"name": "Chad", "dial_code": "+235", "code": "TD"},
        {"name": "Chile", "dial_code": "+56", "code": "CL"},
        {"name": "China", "dial_code": "+86", "code": "CN"},
        {"name": "Christmas Island", "dial_code": "+61", "code": "CX"},
        {"name": "Cocos (Keeling) Islands", "dial_code": "+61", "code": "CC"},
        {"name": "Colombia", "dial_code": "+57", "code": "CO"},
        {"name": "Comoros", "dial_code": "+269", "code": "KM"},
        {"name": "Congo", "dial_code": "+242", "code": "CG"},
        {
          "name": "Congo, The Democratic Republic of the Congo",
          "dial_code": "+243",
          "code": "CD"
        },
        {"name": "Cook Islands", "dial_code": "+682", "code": "CK"},
        {"name": "Costa Rica", "dial_code": "+506", "code": "CR"},
        {"name": "Cote d'Ivoire", "dial_code": "+225", "code": "CI"},
        {"name": "Croatia", "dial_code": "+385", "code": "HR"},
        {"name": "Cuba", "dial_code": "+53", "code": "CU"},
        {"name": "Cyprus", "dial_code": "+357", "code": "CY"},
        {"name": "Czech Republic", "dial_code": "+420", "code": "CZ"},
        {"name": "Denmark", "dial_code": "+45", "code": "DK"},
        {"name": "Djibouti", "dial_code": "+253", "code": "DJ"},
        {"name": "Dominica", "dial_code": "+1 767", "code": "DM"},
        {"name": "Dominican Republic", "dial_code": "+1 849", "code": "DO"},
        {"name": "Ecuador", "dial_code": "+593", "code": "EC"},
        {"name": "Egypt", "dial_code": "+20", "code": "EG"},
        {"name": "El Salvador", "dial_code": "+503", "code": "SV"},
        {"name": "Equatorial Guinea", "dial_code": "+240", "code": "GQ"},
        {"name": "Eritrea", "dial_code": "+291", "code": "ER"},
        {"name": "Estonia", "dial_code": "+372", "code": "EE"},
        {"name": "Ethiopia", "dial_code": "+251", "code": "ET"},
        {
          "name": "Falkland Islands (Malvinas)",
          "dial_code": "+500",
          "code": "FK"
        },
        {"name": "Faroe Islands", "dial_code": "+298", "code": "FO"},
        {"name": "Fiji", "dial_code": "+679", "code": "FJ"},
        {"name": "Finland", "dial_code": "+358", "code": "FI"},
        {"name": "France", "dial_code": "+33", "code": "FR"},
        {"name": "French Guiana", "dial_code": "+594", "code": "GF"},
        {"name": "French Polynesia", "dial_code": "+689", "code": "PF"},
        {"name": "Gabon", "dial_code": "+241", "code": "GA"},
        {"name": "Gambia", "dial_code": "+220", "code": "GM"},
        {"name": "Georgia", "dial_code": "+995", "code": "GE"},
        {"name": "Germany", "dial_code": "+49", "code": "DE"},
        {"name": "Ghana", "dial_code": "+233", "code": "GH"},
        {"name": "Gibraltar", "dial_code": "+350", "code": "GI"},
        {"name": "Greece", "dial_code": "+30", "code": "GR"},
        {"name": "Greenland", "dial_code": "+299", "code": "GL"},
        {"name": "Grenada", "dial_code": "+1 473", "code": "GD"},
        {"name": "Guadeloupe", "dial_code": "+590", "code": "GP"},
        {"name": "Guam", "dial_code": "+1 671", "code": "GU"},
        {"name": "Guatemala", "dial_code": "+502", "code": "GT"},
        {"name": "Guernsey", "dial_code": "+44", "code": "GG"},
        {"name": "Guinea", "dial_code": "+224", "code": "GN"},
        {"name": "Guinea-Bissau", "dial_code": "+245", "code": "GW"},
        {"name": "Guyana", "dial_code": "+595", "code": "GY"},
        {"name": "Haiti", "dial_code": "+509", "code": "HT"},
        {
          "name": "Holy See (Vatican City State)",
          "dial_code": "+379",
          "code": "VA"
        },
        {"name": "Honduras", "dial_code": "+504", "code": "HN"},
        {"name": "Hong Kong", "dial_code": "+852", "code": "HK"},
        {"name": "Hungary", "dial_code": "+36", "code": "HU"},
        {"name": "Iceland", "dial_code": "+354", "code": "IS"},
        {"name": "India", "dial_code": "+91", "code": "IN"},
        {"name": "Indonesia", "dial_code": "+62", "code": "ID"},
        {
          "name": "Iran, Islamic Republic of Persian Gulf",
          "dial_code": "+98",
          "code": "IR"
        },
        {"name": "Iraq", "dial_code": "+964", "code": "IQ"},
        {"name": "Ireland", "dial_code": "+353", "code": "IE"},
        {"name": "Isle of Man", "dial_code": "+44", "code": "IM"},
        {"name": "Israel", "dial_code": "+972", "code": "IL"},
        {"name": "Italy", "dial_code": "+39", "code": "IT"},
        {"name": "Jamaica", "dial_code": "+1 876", "code": "JM"},
        {"name": "Japan", "dial_code": "+81", "code": "JP"},
        {"name": "Jersey", "dial_code": "+44", "code": "JE"},
        {"name": "Jordan", "dial_code": "+962", "code": "JO"},
        {"name": "Kazakhstan", "dial_code": "+77", "code": "KZ"},
        {"name": "Kenya", "dial_code": "+254", "code": "KE"},
        {"name": "Kiribati", "dial_code": "+686", "code": "KI"},
        {
          "name": "Korea, Democratic People's Republic of Korea",
          "dial_code": "+850",
          "code": "KP"
        },
        {
          "name": "Korea, Republic of South Korea",
          "dial_code": "+82",
          "code": "KR"
        },
        {"name": "Kuwait", "dial_code": "+965", "code": "KW"},
        {"name": "Kyrgyzstan", "dial_code": "+996", "code": "KG"},
        {"name": "Laos", "dial_code": "+856", "code": "LA"},
        {"name": "Latvia", "dial_code": "+371", "code": "LV"},
        {"name": "Lebanon", "dial_code": "+961", "code": "LB"},
        {"name": "Lesotho", "dial_code": "+266", "code": "LS"},
        {"name": "Liberia", "dial_code": "+231", "code": "LR"},
        {"name": "Libyan Arab Jamahiriya", "dial_code": "+218", "code": "LY"},
        {"name": "Liechtenstein", "dial_code": "+423", "code": "LI"},
        {"name": "Lithuania", "dial_code": "+370", "code": "LT"},
        {"name": "Luxembourg", "dial_code": "+352", "code": "LU"},
        {"name": "Macao", "dial_code": "+853", "code": "MO"},
        {"name": "Macedonia", "dial_code": "+389", "code": "MK"},
        {"name": "Madagascar", "dial_code": "+261", "code": "MG"},
        {"name": "Malawi", "dial_code": "+265", "code": "MW"},
        {"name": "Malaysia", "dial_code": "+60", "code": "MY"},
        {"name": "Maldives", "dial_code": "+960", "code": "MV"},
        {"name": "Mali", "dial_code": "+223", "code": "ML"},
        {"name": "Malta", "dial_code": "+356", "code": "MT"},
        {"name": "Marshall Islands", "dial_code": "+692", "code": "MH"},
        {"name": "Martinique", "dial_code": "+596", "code": "MQ"},
        {"name": "Mauritania", "dial_code": "+222", "code": "MR"},
        {"name": "Mauritius", "dial_code": "+230", "code": "MU"},
        {"name": "Mayotte", "dial_code": "+262", "code": "YT"},
        {"name": "Mexico", "dial_code": "+52", "code": "MX"},
        {
          "name": "Micronesia, Federated States of Micronesia",
          "dial_code": "+691",
          "code": "FM"
        },
        {"name": "Moldova", "dial_code": "+373", "code": "MD"},
        {"name": "Monaco", "dial_code": "+377", "code": "MC"},
        {"name": "Mongolia", "dial_code": "+976", "code": "MN"},
        {"name": "Montenegro", "dial_code": "+382", "code": "ME"},
        {"name": "Montserrat", "dial_code": "+1 664", "code": "MS"},
        {"name": "Morocco", "dial_code": "+212", "code": "MA"},
        {"name": "Mozambique", "dial_code": "+258", "code": "MZ"},
        {"name": "Myanmar", "dial_code": "+95", "code": "MM"},
        {"name": "Namibia", "dial_code": "+264", "code": "NA"},
        {"name": "Nauru", "dial_code": "+674", "code": "NR"},
        {"name": "Nepal", "dial_code": "+977", "code": "NP"},
        {"name": "Netherlands", "dial_code": "+31", "code": "NL"},
        {"name": "Netherlands Antilles", "dial_code": "+599", "code": "AN"},
        {"name": "New Caledonia", "dial_code": "+687", "code": "NC"},
        {"name": "New Zealand", "dial_code": "+64", "code": "NZ"},
        {"name": "Nicaragua", "dial_code": "+505", "code": "NI"},
        {"name": "Niger", "dial_code": "+227", "code": "NE"},
        {"name": "Nigeria", "dial_code": "+234", "code": "NG"},
        {"name": "Niue", "dial_code": "+683", "code": "NU"},
        {"name": "Norfolk Island", "dial_code": "+672", "code": "NF"},
        {
          "name": "Northern Mariana Islands",
          "dial_code": "+1 670",
          "code": "MP"
        },
        {"name": "Norway", "dial_code": "+47", "code": "NO"},
        {"name": "Oman", "dial_code": "+968", "code": "OM"},
        {"name": "Pakistan", "dial_code": "+92", "code": "PK"},
        {"name": "Palau", "dial_code": "+680", "code": "PW"},
        {
          "name": "Palestinian Territory, Occupied",
          "dial_code": "+970",
          "code": "PS"
        },
        {"name": "Panama", "dial_code": "+507", "code": "PA"},
        {"name": "Papua New Guinea", "dial_code": "+675", "code": "PG"},
        {"name": "Paraguay", "dial_code": "+595", "code": "PY"},
        {"name": "Peru", "dial_code": "+51", "code": "PE"},
        {"name": "Philippines", "dial_code": "+63", "code": "PH"},
        {"name": "Pitcairn", "dial_code": "+872", "code": "PN"},
        {"name": "Poland", "dial_code": "+48", "code": "PL"},
        {"name": "Portugal", "dial_code": "+351", "code": "PT"},
        {"name": "Puerto Rico", "dial_code": "+1 939", "code": "PR"},
        {"name": "Qatar", "dial_code": "+974", "code": "QA"},
        {"name": "Romania", "dial_code": "+40", "code": "RO"},
        {"name": "Russia", "dial_code": "+7", "code": "RU"},
        {"name": "Rwanda", "dial_code": "+250", "code": "RW"},
        {"name": "Reunion", "dial_code": "+262", "code": "RE"},
        {"name": "Saint Barthelemy", "dial_code": "+590", "code": "BL"},
        {
          "name": "Saint Helena, Ascension and Tristan Da Cunha",
          "dial_code": "+290",
          "code": "SH"
        },
        {"name": "Saint Kitts and Nevis", "dial_code": "+1 869", "code": "KN"},
        {"name": "Saint Lucia", "dial_code": "+1 758", "code": "LC"},
        {"name": "Saint Martin", "dial_code": "+590", "code": "MF"},
        {
          "name": "Saint Pierre and Miquelon",
          "dial_code": "+508",
          "code": "PM"
        },
        {
          "name": "Saint Vincent and the Grenadines",
          "dial_code": "+1 784",
          "code": "VC"
        },
        {"name": "Samoa", "dial_code": "+685", "code": "WS"},
        {"name": "San Marino", "dial_code": "+378", "code": "SM"},
        {"name": "Sao Tome and Principe", "dial_code": "+239", "code": "ST"},
        {"name": "Saudi Arabia", "dial_code": "+966", "code": "SA"},
        {"name": "Senegal", "dial_code": "+221", "code": "SN"},
        {"name": "Serbia", "dial_code": "+381", "code": "RS"},
        {"name": "Seychelles", "dial_code": "+248", "code": "SC"},
        {"name": "Sierra Leone", "dial_code": "+232", "code": "SL"},
        {"name": "Singapore", "dial_code": "+65", "code": "SG"},
        {"name": "Slovakia", "dial_code": "+421", "code": "SK"},
        {"name": "Slovenia", "dial_code": "+386", "code": "SI"},
        {"name": "Solomon Islands", "dial_code": "+677", "code": "SB"},
        {"name": "Somalia", "dial_code": "+252", "code": "SO"},
        {"name": "South Africa", "dial_code": "+27", "code": "ZA"},
        {"name": "South Sudan", "dial_code": "+211", "code": "SS"},
        {
          "name": "South Georgia and the South Sandwich Islands",
          "dial_code": "+500",
          "code": "GS"
        },
        {"name": "Spain", "dial_code": "+34", "code": "ES"},
        {"name": "Sri Lanka", "dial_code": "+94", "code": "LK"},
        {"name": "Sudan", "dial_code": "+249", "code": "SD"},
        {"name": "Suriname", "dial_code": "+597", "code": "SR"},
        {"name": "Svalbard and Jan Mayen", "dial_code": "+47", "code": "SJ"},
        {"name": "Swaziland", "dial_code": "+268", "code": "SZ"},
        {"name": "Sweden", "dial_code": "+46", "code": "SE"},
        {"name": "Switzerland", "dial_code": "+41", "code": "CH"},
        {"name": "Syrian Arab Republic", "dial_code": "+963", "code": "SY"},
        {"name": "Taiwan", "dial_code": "+886", "code": "TW"},
        {"name": "Tajikistan", "dial_code": "+992", "code": "TJ"},
        {
          "name": "Tanzania, United Republic of Tanzania",
          "dial_code": "+255",
          "code": "TZ"
        },
        {"name": "Thailand", "dial_code": "+66", "code": "TH"},
        {"name": "Timor-Leste", "dial_code": "+670", "code": "TL"},
        {"name": "Togo", "dial_code": "+228", "code": "TG"},
        {"name": "Tokelau", "dial_code": "+690", "code": "TK"},
        {"name": "Tonga", "dial_code": "+676", "code": "TO"},
        {"name": "Trinidad and Tobago", "dial_code": "+1 868", "code": "TT"},
        {"name": "Tunisia", "dial_code": "+216", "code": "TN"},
        {"name": "Turkey", "dial_code": "+90", "code": "TR"},
        {"name": "Turkmenistan", "dial_code": "+993", "code": "TM"},
        {
          "name": "Turks and Caicos Islands",
          "dial_code": "+1 649",
          "code": "TC"
        },
        {"name": "Tuvalu", "dial_code": "+688", "code": "TV"},
        {"name": "Uganda", "dial_code": "+256", "code": "UG"},
        {"name": "Ukraine", "dial_code": "+380", "code": "UA"},
        {"name": "United Arab Emirates", "dial_code": "+971", "code": "AE"},
        {"name": "United Kingdom", "dial_code": "+44", "code": "GB"},
        {"name": "United States", "dial_code": "+1", "code": "US"},
        {"name": "Uruguay", "dial_code": "+598", "code": "UY"},
        {"name": "Uzbekistan", "dial_code": "+998", "code": "UZ"},
        {"name": "Vanuatu", "dial_code": "+678", "code": "VU"},
        {
          "name": "Venezuela, Bolivarian Republic of Venezuela",
          "dial_code": "+58",
          "code": "VE"
        },
        {"name": "Vietnam", "dial_code": "+84", "code": "VN"},
        {
          "name": "Virgin Islands, British",
          "dial_code": "+1 284",
          "code": "VG"
        },
        {"name": "Virgin Islands, U.S.", "dial_code": "+1 340", "code": "VI"},
        {"name": "Wallis and Futuna", "dial_code": "+681", "code": "WF"},
        {"name": "Yemen", "dial_code": "+967", "code": "YE"},
        {"name": "Zambia", "dial_code": "+260", "code": "ZM"},
        {"name": "Zimbabwe", "dial_code": "+263", "code": "ZW"}
      ]
    };
    data_country = countrymodelList!.countryList!;
    print(data_country);

    List? books = [];
    books = data["countryList"]?.cast<dynamic>();

    return books!.map((json) => CountryList.fromJson(json)).where((book) {
      final titleLower = book.name!.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();
  }
}
