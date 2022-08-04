// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:funky_new/dashboard/dashboard_screen.dart';
import 'package:funky_new/sharePreference.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Utils/App_utils.dart';
import 'Utils/asset_utils.dart';
import 'chat_quickblox/bloc/splash/splash_screen_bloc.dart';
import 'chat_quickblox/bloc/splash/splash_screen_events.dart';
import 'chat_quickblox/presentation/screens/base_screen_state.dart';
import 'controller/controllers_class.dart';
import 'getx_pagination/binding_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseScreenState<SplashScreenBloc> {
  SplashScreenController _splashController =
      Get.find(tag: SplashScreenController().toString());

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      init();
      // Get.toNamed(BindingUtils.AuthenticationScreenRoute);
    });
  }

  init() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String type_user = await PreferenceManager().getPref(URLConstants.type);

    (id_user == 'id' ||
            id_user.isEmpty ||
            type_user == 'type' ||
            type_user.isEmpty)
        ? Get.toNamed(BindingUtils.AuthenticationScreenRoute)
        : Get.to(Dashboard(page: 0,));
  }

  @override
  Widget build(BuildContext context) {
    initBloc(context);
    bloc?.events?.add(AuthEvent());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 86),
            child: Image.asset(AssetUtils.logo)),
      ),
    );
  }
}
