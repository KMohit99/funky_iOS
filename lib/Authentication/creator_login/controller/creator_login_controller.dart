import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/custom_widget/page_loader.dart';

// import 'package:funky_project/dashboard/dashboard_screen.dart';
// import 'package:funky_project/getx_pagination/binding_utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:twitter_login/twitter_login.dart';
import 'dart:convert' as convert;

import '../../../Utils/App_utils.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../homepage/model/UserInfoModel.dart';
import '../../../sharePreference.dart';
import '../../instagram/instagram_constanr.dart';
import '../model/creator_loginModel.dart';

class Creator_Login_screen_controller extends GetxController {
  RxBool isLoading = false.obs;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginModel? loginModel;

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
        CommonService().setStoreKey(
            setKey: 'type', setValue: loginModel!.user![0].type!.toString());
        CommonService().setStoreKey(
            setKey: 'id', setValue: loginModel!.user![0].id!.toString());
        await PreferenceManager()
            .setPref(URLConstants.id, loginModel!.user![0].id!);
        await PreferenceManager()
            .setPref(URLConstants.type, loginModel!.user![0].type!);

        await PreferenceManager().setPref(URLConstants.social_type, "");
        await CreatorgetUserInfo_Email(UserId: loginModel!.user![0].id!);

        await Fluttertoast.showToast(
          msg: "login successfully",
          textColor: Colors.white,
          backgroundColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        hideLoader(context);
        await clear();
        await Get.to(Dashboard(page: 0,));
      } else {
        hideLoader(context);
        CommonWidget().showErrorToaster(msg: "Invalid Details");
        print('Please try again');
        print('Please try again');
      }
    } else {}
  }

  clear() {
    usernameController.clear();
    passwordController.clear();
  }

  RxBool isuserinfoLoading = true.obs;
  UserInfoModel? userInfoModel_email;
  var getUSerModelList = UserInfoModel().obs;

  Future<dynamic> CreatorgetUserInfo_Email({required String UserId}) async {
    print('Inside creator get email');
    isuserinfoLoading(true);
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    print("UserID $id_user");
    String url =
        ("${URLConstants.base_url}${URLConstants.user_info_email_Api}?id=$id_user");
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
        // await Get.to(Dashboard());

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

  Future<dynamic> getUserInfo_social() async {
    isuserinfoLoading(true);
    String userId = CommonService().getStoreValue(keys: 'id');
    String id_user = await PreferenceManager().getPref(URLConstants.id);

    print("UserID $id_user");
    String url = (URLConstants.base_url +
        URLConstants.user_info_social_Api +
        "?id=$id_user");
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

  UserCredential? userCredential;

  Future<Resource?> signInWithFacebook(
      {required BuildContext context, required String login_type}) async {
    // try {
    // showLoader(context);
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]);

    switch (result.status) {
      case LoginStatus.success:
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);

        await social_group_login(
            login_type: login_type, context: context, socail_type: 'facebook');

        Fluttertoast.showToast(
          msg: "login successfully",
          textColor: Colors.white,
          backgroundColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        // Get.to(Dashboard());

        print(userCredential!.user!.displayName);
        return Resource(status: Status.Success);
      case LoginStatus.cancelled:
        return Resource(status: Status.Cancelled);
      case LoginStatus.failed:
        return Resource(status: Status.Error);
      default:
        return null;
    }

    // on FirebaseAuthException catch (e) {
    //   throw e;
    // }
  }

//   final fb = FacebookLogin();
//
//   Future SignInFacebook(
//       {required BuildContext context, required String login_type}) async {
// // Create an instance of FacebookLogin
//
// // Log in
//     final res = await fb.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);
//
// // Check result status
//     switch (res.status) {
//       case FacebookLoginStatus.success:
//         // Logged in
//
//         // Send access token to server for validation and auth
//         final FacebookAccessToken? accessToken = res.accessToken;
//         print('Access token: ${accessToken!.token}');
//
//         // Get profile data
//         final profile = await fb.getUserProfile();
//         print('Hello, ${profile!.name}! You ID: ${profile.userId}');
//         // Get user profile image url
//         final imageUrl = await fb.getProfileImageUrl(width: 100);
//         print('Your profile image: $imageUrl');
//
//         // Get email (since we request email permission)
//         final email = await fb.getUserEmail();
//         // But user can decline permission
//         if (email != null) print('And your email is $email');
//
//         // print(
//         //     "userCredential!.user!.displayName ${userCredential!.user!.displayName}");
//
//         await social_fb_login(
//             login_type: login_type,
//             context: context,
//             socail_type: 'facebook',
//             profileUrl: imageUrl!,
//             socialId: '',
//             username: profile.name!);
//
//         Fluttertoast.showToast(
//           msg: "login successfully",
//           textColor: Colors.white,
//           backgroundColor: Colors.black,
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//         );
//         break;
//       case FacebookLoginStatus.cancel:
//         // User cancel log in
//         break;
//       case FacebookLoginStatus.error:
//         // Log in failed
//         print('Error while log in: ${res.error}');
//         break;
//     }
//   }

  // fullName,userName,email,phone,parent_email,password,gender,location,referral_code,image,type,profileUrl,socialId,social_type
  Future social_group_login(
      {required BuildContext context,
      required String login_type,
      required String socail_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    showLoader(context);
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    try {
      isLoading(true);
      Map data = {
        'fullName': userCredential!.user!.displayName,
        'userName': userCredential!.user!.displayName,
        'email': "",
        'phone': "",
        'parent_email': "",
        'password': "",
        'gender': "",
        'location': "",
        'referral_code': "",
        'image': "",
        'profileUrl': userCredential!.user!.photoURL,
        'socialId': userCredential!.user!.uid,
        'social_type': socail_type,
        'type': login_type,
      };
      print(data);
      // String body = json.encode(data);

      var url = (URLConstants.base_url + URLConstants.socailsignUpApi);
      print("url : $url");
      print("body : $data");

      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print("response.body ${response.body}");
      print("response.request ${response.request}");
      print("response.statusCode ${response.statusCode}");
      // var final_data = jsonDecode(response.body);

      // print('final data $final_data');

      if (response.statusCode == 200) {
        isLoading(false);
        var data = jsonDecode(response.body);
        loginModel = LoginModel.fromJson(data);
        print("loginModel");
        if (loginModel!.error == false) {
          CommonService().setStoreKey(
              setKey: 'id', setValue: loginModel!.user![0].id!.toString());
          await PreferenceManager()
              .setPref(URLConstants.id, loginModel!.user![0].id!);
          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);
          await PreferenceManager()
              .setPref(URLConstants.social_type, socail_type);
          await getUserInfo_social();

          Fluttertoast.showToast(
            msg: "login successfully",
            textColor: Colors.white,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          hideLoader(context);
          await Get.to(Dashboard(page: 0,));
        } else {
          print('Please try again');
        }
      } else {
        print('Please try again');
      }
    } on Exception catch (e) {
      print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    }
  }

  Future social_fb_login(
      {required BuildContext context,
      required String username,
      required String profileUrl,
      required String socialId,
      required String login_type,
      required String socail_type}) async {
    debugPrint('0-0-0-0-0-0-0 username');
    showLoader(context);
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    try {
      isLoading(true);
      Map data = {
        'fullName': username,
        'userName': username,
        'email': "",
        'phone': "",
        'parent_email': "",
        'password': "",
        'gender': "",
        'location': "",
        'referral_code': "",
        'image': "",
        'profileUrl': profileUrl,
        'socialId': socialId,
        'social_type': socail_type,
        'type': login_type,
      };
      print(data);
      // String body = json.encode(data);

      var url = (URLConstants.base_url + URLConstants.socailsignUpApi);
      print("url : $url");
      print("body : $data");

      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print("response.body ${response.body}");
      print("response.request ${response.request}");
      print("response.statusCode ${response.statusCode}");
      // var final_data = jsonDecode(response.body);

      // print('final data $final_data');

      if (response.statusCode == 200) {
        isLoading(false);
        var data = jsonDecode(response.body);
        loginModel = LoginModel.fromJson(data);
        print("loginModel");
        if (loginModel!.error == false) {
          CommonService().setStoreKey(
              setKey: 'id', setValue: loginModel!.user![0].id!.toString());
          await PreferenceManager()
              .setPref(URLConstants.id, loginModel!.user![0].id!);
          await PreferenceManager()
              .setPref(URLConstants.type, loginModel!.user![0].type!);
          await PreferenceManager()
              .setPref(URLConstants.social_type, socail_type);
          await getUserInfo_social();

          Fluttertoast.showToast(
            msg: "login successfully",
            textColor: Colors.white,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          hideLoader(context);
          await Get.to(Dashboard(page: 0,));
        } else {
          print('Please try again');
        }
      } else {
        print('Please try again');
      }
    } on Exception catch (e) {
      print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //
  Future<String?> signInwithGoogle(
      {required BuildContext context, required String login_type}) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        await social_group_login(
            login_type: login_type, context: context, socail_type: 'google');

        // Get.to(Dashboard());
      }
      // User user = result.user;
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  //
  RxBool twitterloading = false.obs;

  Future<Resource?> signInWithTwitter(
      {required BuildContext context, required String login_type}) async {
    twitterloading(true);
    print('inside');
    try {
      final twitterLogin = TwitterLogin(
        // apiKey: "2vEtlVAfmb6J8r4qFpIgjxWEt",
        // apiSecretKey: "4WU6EQQ569gkBU9E4GwCiB5FhQz1vsupzFYGMT2vqEzpBE8l9J",
        // redirectURI: "flutter-twitter-practice://",
        apiKey: "eT1D5ufcCT0HbHQ6MG3jn2Lbw",
        apiSecretKey: "TnK8pyuSmt5wVsn8d5RKPgsHEkQsI25EZMQi2fd85Y6jv6cZhN",
        redirectURI: "twittersdk://",
      );
      final authResult = await twitterLogin.login();
      // // Trigger the sign-in flow
      // final authResult = await twitterLogin.login();
      // print("authResult.authToken! ${authResult.authToken!}");
      // // Create a credential from the access token
      // final twitterAuthCredential = TwitterAuthProvider.credential(
      //   accessToken: authResult.authToken!,
      //   secret: authResult.authTokenSecret!,
      // );
      //
      // // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          print('erorrrrr');

          final AuthCredential twitterAuthCredential =
              TwitterAuthProvider.credential(
                  accessToken: authResult.authToken!,
                  secret: authResult.authTokenSecret!);
          twitterloading(false);
          userCredential =
              await _auth.signInWithCredential(twitterAuthCredential);
          print("userCredential : ${userCredential!.user!.displayName!}");
          await social_group_login(
              login_type: login_type, context: context, socail_type: 'twitter');
          // print(userCredential!.user!.email!);
          Fluttertoast.showToast(
            msg: "login successfully",
            textColor: Colors.white,
            backgroundColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          return Resource(status: Status.Success);
        case TwitterLoginStatus.cancelledByUser:
          print('erorrrrrccccccccccc');
          return Resource(status: Status.Success);
        case TwitterLoginStatus.error:
          print('erorrrrwwwwr');
          return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
// void signInWithTwitter() async {
//   // Create a TwitterLogin instance
//   final twitterLogin = new TwitterLogin(
//     apiKey: "eT1D5ufcCT0HbHQ6MG3jn2Lbw",
//     apiSecretKey: "TnK8pyuSmt5wVsn8d5RKPgsHEkQsI25EZMQi2fd85Y6jv6cZhN",
//     // redirectURI: "flutter-twitter-practice://",
//     redirectURI: "twittersdk://",
//   );
//
//   // Trigger the sign-in flow
//   await twitterLogin.login().then((value) async {
//     final authToken = value.authToken;
//     final authTokenSecret = value.authTokenSecret;
//     if (authToken != null && authTokenSecret != null) {
//       final twitterAuthCredentials = TwitterAuthProvider.credential(
//           accessToken: authToken, secret: authTokenSecret);
//       await FirebaseAuth.instance
//           .signInWithCredential(twitterAuthCredentials);
//     }
//     else{
//       print('token missing');
//     }
//   });
// }

}

class Resource {
  final Status status;

  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
