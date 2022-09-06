import 'package:flutter/material.dart';
import 'package:funky_new/controller/controllers_class.dart';
import 'package:funky_new/guest_screen/ui/guest_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:funky_new/custom_widget/common_buttons.dart';

import '../Utils/asset_utils.dart';
import '../getx_pagination/binding_utils.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final Authentication_controller _authentication_controller = Get.put(
      Authentication_controller(),
      tag: Authentication_controller().toString());

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GetBuilder<Authentication_controller>(
      init: _authentication_controller,
      builder: (GetxController controller) {
        return Stack(
          children: [
            // Container(
            //   color: Colors.white,
            //   height: MediaQuery.of(context).size.height,
            // ),
            Container(
              height: double.infinity,
              width: double.infinity,
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
                      HexColor("#000000").withOpacity(0),
                      HexColor("#000000").withOpacity(1),
                    ],
                    tileMode: TileMode.decal),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  // colorFilter: ColorFilter.mode(
                  //     Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: const AssetImage(
                    AssetUtils.backgroundImage,
                  ),
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 86, right: 86, top: 50, bottom: 20),
                    child: Image.asset(
                      AssetUtils.logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Login As',
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'PB', color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 41,
                  ),
                  common_button(
                    onTap: () {
                      Get.toNamed(BindingUtils.creator_loginScreenRoute);
                    },
                    backgroud_color: Colors.black,
                    lable_text: 'Creator',
                    lable_text_color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  common_button(
                    onTap: () {
                      Get.toNamed(BindingUtils.kids_loginScreenRoute);
                    },
                    backgroud_color: Colors.white,
                    lable_text: 'Funky Kids',
                    lable_text_color: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  common_button(
                    onTap: () {
                      Get.toNamed(BindingUtils.advertiser_loginScreenRoute);
                    },
                    backgroud_color: Colors.black,
                    lable_text: 'Advertisor',
                    lable_text_color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(GuestScreen());
                    },
                    child: Container(
                      child: Text(
                        'Continue as guest',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PB',
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    // height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        Container(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(BindingUtils.ageVerification);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PB',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
