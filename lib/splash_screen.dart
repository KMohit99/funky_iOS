// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Utils/asset_utils.dart';
import 'controller/controllers_class.dart';
import 'getx_pagination/binding_utils.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenController _splashController =
      Get.find(tag: SplashScreenController().toString());

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.toNamed(BindingUtils.AuthenticationScreenRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
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
