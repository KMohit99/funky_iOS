import 'package:flutter/material.dart';
// import 'package:funky_project/Authentication/kids_login/controller/kids_login_controller.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../../getx_pagination/binding_utils.dart';
import '../controller/kids_login_controller.dart';

class kids_Email_verification extends StatefulWidget {
  const kids_Email_verification({Key? key}) : super(key: key);

  @override
  State<kids_Email_verification> createState() => _kids_Email_verificationState();
}

class _kids_Email_verificationState extends State<kids_Email_verification> {
  final _kids_loginScreenController = Get.put(Kids_Login_screen_controller());
  @override
  Widget build(BuildContext context) {
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
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: new AssetImage(
                AssetUtils.backgroundImage2,
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
                'Parent Verification',
                style: TextStyle(fontSize: 16, fontFamily: 'PB',color: Colors.white),
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
                  SizedBox(height: 60,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 86,vertical: 20),
                    child: Image.asset(AssetUtils.logo,fit: BoxFit.cover,),
                  ),
                  Container(
                    child: Text(
                      'Enter Parents email',
                      style: TextStyle(fontSize: 16, fontFamily: 'PB',color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 41,
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  CommonTextFormField(
                    controller: _kids_loginScreenController.parentEmailController,
                    title: 'Email',
                    labelText: 'Enter Email',
                    image_path: AssetUtils.chat_icon,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  common_button(
                    onTap: (){
                      _kids_loginScreenController.ParentEmailVerification(context);
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
