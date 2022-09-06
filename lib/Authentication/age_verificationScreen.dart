import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/controller/controllers_class.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../controller/controllers_class.dart';
import '../custom_widget/common_buttons.dart';
import '../getx_pagination/binding_utils.dart';

class AgeVerification extends StatefulWidget {
  const AgeVerification({Key? key}) : super(key: key);

  @override
  State<AgeVerification> createState() => _AgeVerificationState();
}

class _AgeVerificationState extends State<AgeVerification> {
  final Age_screen_controller _age_screen_controller =
      Get.put(Age_screen_controller(), tag: Age_screen_controller().toString());

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GetBuilder<Age_screen_controller>(
      init: _age_screen_controller,
      builder: (GetxController controller) {
        return Stack(
          children: [
            // Container(
            //   color: Colors.black,
            //   height: MediaQuery.of(context).size.height,
            // ),
            Container(
              // decoration: BoxDecoration(
              //
              //   image: DecorationImage(
              //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
              //     fit: BoxFit.cover,
              //   ),
              // ),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   // stops: [0.1, 0.5, 0.7, 0.9],
                //   colors: [
                //     HexColor("#000000").withOpacity(0.67),
                //     HexColor("#000000").withOpacity(0.67),
                //     HexColor("#C12265").withOpacity(0.3),
                //     HexColor("#C12265").withOpacity(0.3),
                //     HexColor("#C12265").withOpacity(0.4),
                //     HexColor("#C12265").withOpacity(0.5),
                //     HexColor("#FFFFFF").withOpacity(0.5),
                //   ],
                // ),
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  // colorFilter: new ColorFilter.mode(
                  //     Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new AssetImage(
                    AssetUtils.backgroundImage5,
                  ),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              // <-- SCAFFOLD WITH TRANSPARENT BG
              body: SingleChildScrollView(
                child: Container(
                  width: screenwidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 86),
                        child: Image.asset(
                          AssetUtils.logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Container(
                        child: Text(
                          'Creator Signup',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PB',
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 41,
                      ),
                      Container(
                        // height: 45,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(67)),
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                              vertical: 35,
                            ),
                            child: Text(
                              "Are you 16 years old or above?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PR',
                                  fontSize: 16),
                            )),
                      ),
                      SizedBox(
                        height: 41,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(BindingUtils.signupOption);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 45,
                              // width:(width ?? 300) ,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  child: Text(
                                    'YES',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'PR',
                                        fontSize: 14),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(BindingUtils.kids_signup);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              // height: 45,
                              // width:(width ?? 300) ,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  child: Text(
                                    'NO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PR',
                                        fontSize: 14),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
