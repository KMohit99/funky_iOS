import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../../Utils/App_utils.dart';
import '../../chat/constants/firestore_constants.dart';
import '../../chat/models/user_chat.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../homepage/model/UserInfoModel.dart';
import '../../sharePreference.dart';
import '../creator_login/controller/creator_login_controller.dart';
import '../creator_login/model/creator_loginModel.dart';
import 'home.dart';
import 'instagram_constanr.dart';
import 'instagram_model.dart';

// import 'package:instagram_login/home.dart';
// import 'package:instagram_login/instagram_constant.dart';
// import 'package:instagram_login/instagram_model.dart';

class InstagramView extends StatelessWidget {
  final String login_type;
  final BuildContext context;

  InstagramView({Key? key, required this.login_type, required this.context})
      : super(key: key);

  LoginModel? loginModel;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final webview = FlutterWebviewPlugin();
      final InstagramModel instagram = InstagramModel();

      buildRedirectToHome(webview, instagram, context);

      return WebviewScaffold(
        url: InstagramConstant.instance.url,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context),
      );
    });
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<dynamic> social_group_login({
    required BuildContext context,
    required String login_type,
    required String username,
    required String fullname,
  }) async {
    debugPrint('0-0-0-0-0-0-0 username');
    // try {
    //
    // } catch (e) {
    //   print('0-0-0-0-0-0- SignIn Error :- ${e.toString()}');
    // }
    // isLoading(true);
    Map data = {
      'fullName': fullname,
      'userName': username,
      'email': " ",
      'phone': " ",
      'parent_email': " ",
      'password': " ",
      'gender': " ",
      'location': " ",
      'referral_code': " ",
      'image': " ",
      'profileUrl': " ",
      'socialId': " ",
      'social_type': "instagram",
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
      // isLoading(false);
      var data = jsonDecode(response.body);
      loginModel = LoginModel.fromJson(data);
      print("loginModel");
      print("wwwwwwwwwwwww ${loginModel!.user![0].type!}");
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

        await getUserInfo_social();

        /// Firebase database messaging method
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: loginModel!.user![0].id)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          print("new user created");
          // Writing data to server because here is a new user
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(loginModel!.user![0].id)
              .set({
            FirestoreConstants.nickname: fullname,
            FirestoreConstants.photoUrl: "",
            FirestoreConstants.id: loginModel!.user![0].id,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          // Write data to local storage
          // User? currentUser = firebaseUser;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              FirestoreConstants.id, loginModel!.user![0].id!);
          await prefs.setString(FirestoreConstants.nickname,
              fullname ?? "");
          await prefs.setString(FirestoreConstants.photoUrl, "");
        } else {
          print("user existed");
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(
              FirestoreConstants.nickname, userChat.nickname);
          await prefs.setString(
              FirestoreConstants.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        }
        ///
        await Get.to(Dashboard(page: 0,));
      } else {
        print('Please try again');
      }
    } else {
      print('Please try again');
    }
  }

  final Creator_Login_screen_controller _loginScreenController = Get.put(
      Creator_Login_screen_controller(),
      tag: Creator_Login_screen_controller().toString());
  Future<dynamic> getUserInfo_social() async {
    _loginScreenController.isuserinfoLoading(true);
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
      _loginScreenController.userInfoModel_email = UserInfoModel.fromJson(data);
      _loginScreenController.getUSerModelList(_loginScreenController.userInfoModel_email);
      if (_loginScreenController.userInfoModel_email!.error == false) {
        debugPrint(
            '2-2-2-2-2-2 Inside the product Controller Details ${_loginScreenController.userInfoModel_email!.data!.length}');
        _loginScreenController.isuserinfoLoading(false);
        // CommonWidget().showToaster(msg: data["success"].toString());
        return _loginScreenController.userInfoModel_email;
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


  Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
      InstagramModel instagram, BuildContext context) async {
    webview.onUrlChanged.listen((String url) async {
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        await instagram.getTokenAndUserID().then((isDone) {
          if (isDone) {
            instagram.getUserProfile().then((isDone) async {
              await webview.close();

              // isLoading(true);
              await social_group_login(
                  username: instagram.username.toString(),
                  login_type: login_type,
                  context: context,
                  fullname: instagram.username.toString());

              print('${instagram.username} logged in!');
              // await _loginScreenController.social_group_login(
              //     login_type: login_type,
              //     context: context,
              //     socail_type: 'twitter');

              await Get.to(Dashboard(page: 0,));
              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => HomeView(
              //       token: instagram.authorizationCode.toString(),
              //       name: instagram.username.toString(),
              //     ),
              //   ),
              // );
            });
          }
        });
      }
    });
  }

  AppBar buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Instagram Login',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black),
        ),
      );
}
