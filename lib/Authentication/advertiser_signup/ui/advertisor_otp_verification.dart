import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Authentication/advertiser_signup/controller/advertiser_signup_controller.dart';
// import 'package:funky_project/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/common_buttons.dart';

class AdvertisorOtpVerification extends StatefulWidget {
  const AdvertisorOtpVerification({Key? key}) : super(key: key);

  @override
  State<AdvertisorOtpVerification> createState() => Creator_OtpVerification();
}

class Creator_OtpVerification extends State<AdvertisorOtpVerification> {
  final TextEditingController _pinOTPController = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();
  String? varification;

  final BoxDecoration pinOTPDecoration = BoxDecoration(
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        blurRadius: 10,
        offset: Offset(0, 0),
        spreadRadius: -8,
      ),
    ],
    color: Colors.white,
    borderRadius: BorderRadius.circular(21),
  );
  final BoxDecoration pinOTPDecoration2 = BoxDecoration(
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius: 10,
          offset: Offset(0, 0),
          spreadRadius: -8,
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(
        color: Colors.transparent,
      ));
  Timer? countdownTimer;
  Duration myDuration = Duration(seconds: 30);

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        print('timesup');
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  final Advertiser_signup_controller advertiser_signup_controller = Get.put(
      Advertiser_signup_controller(),
      tag: Advertiser_signup_controller().toString());

  @override
  Widget build(BuildContext context) {
    final seconds = myDuration.inSeconds.remainder(60);
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          // decoration: BoxDecoration(
          //
          //   image: DecorationImage(
          //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
          //     fit: BoxFit.cover,
          //   ),
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                HexColor("#000000").withOpacity(0.67),
                HexColor("#000000").withOpacity(0.67),
                HexColor("#C12265").withOpacity(0.67),
                HexColor("#FFFFFF").withOpacity(0.67),
              ],
            ),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: new AssetImage(
                AssetUtils.backgroundImage4,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Verify OTP',
                style: TextStyle(
                    fontSize: 16, fontFamily: 'PR', color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              width: screenwidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 96,
                  ),
                  Container(
                    child: Text(
                      'Enter Parents $seconds',
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'PB', color: Colors.white),
                    ),
                  ),
                    SizedBox(
                      height: 41,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      child: PinPut(
                        fieldsCount: 4,
                        textStyle: TextStyle(
                            fontFamily: 'PR', fontSize: 32, color: Colors.black),
                        eachFieldHeight: 60,
                        eachFieldWidth: 60,
                        eachFieldMargin: EdgeInsets.all(7),
                        focusNode: _pinOTPFocus,
                        controller: _pinOTPController,
                        submittedFieldDecoration: pinOTPDecoration,
                        selectedFieldDecoration: pinOTPDecoration,
                        followingFieldDecoration: pinOTPDecoration2,
                        pinAnimationType: PinAnimationType.rotation,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$seconds',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'PB', color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              AssetUtils.timer_icon,
                              width: 22,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height:20,
                    ),
                  common_button(
                    onTap: () {
                      advertiser_signup_controller.AdvertisorVerifyOtp(
                          context: context,
                          otp_controller: _pinOTPController.text);
                      // _kids_loginScreenController.ParentEmailVerification(context);
                    },
                    backgroud_color: Colors.black,
                    lable_text: 'Next',
                    lable_text_color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
