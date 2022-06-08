import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:funky_new/Authentication/password_reset/ui/password_reset_otp_veri.dart';
// import 'package:funky_project/Authentication/kids_login_screen_login/controller/kids_login_controller.dart';
// import 'package:funky_project/Authentication/password_reset/ui/password_reset_otp_veri.dart';
// import 'package:funky_project/Utils/App_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../Utils/asset_utils.dart';
import '../../../../Utils/custom_textfeild.dart';
import '../../../../custom_widget/common_buttons.dart';
import '../../../../getx_pagination/binding_utils.dart';
import '../../../Utils/App_utils.dart';
import '../../../Utils/toaster_widget.dart';
import '../controller/password_reset_controller.dart';

class sendEmail extends StatefulWidget {
  const sendEmail({Key? key}) : super(key: key);

  @override
  State<sendEmail> createState() => _sendEmailState();
}

class _sendEmailState extends State<sendEmail> {
  final password_reset_controller _password_reset_controller = Get.put(
      password_reset_controller(),
      tag: password_reset_controller().toString());

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(52.0), topRight: Radius.circular(52.0))),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

          child: Container(
           decoration: BoxDecoration(

             gradient: LinearGradient(
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
               // stops: [0.1, 0.5, 0.7, 0.9],
               colors: [
                 HexColor("#C12265"),
                 HexColor("#000000"),
               ],
             ),
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(52.0),
               topRight: Radius.circular(52.0),
             ),
           ),
           height: MediaQuery.of(context).size.height/(2.55),
           width: MediaQuery.of(context).size.width,
           child: Column(
             children: [
               SizedBox(
                 height: 20,
               ),
               Container(
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(50)),
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Image.asset(AssetUtils.msg_icon,
                       height: 27,
                       width: 027,
                       fit: BoxFit.fill,
                       color: Colors.black),
                 ),
               ),
               SizedBox(
                 height:25,
               ),
               Container(
                 margin: EdgeInsets.symmetric(horizontal: 70),
                 child: Text(
                   TxtUtils.otp_details,
                   textAlign: TextAlign.center,
                   style: TextStyle(
                       fontSize: 16, fontFamily: 'PR', color: Colors.white),
                 ),
               ),
               // Text(
               //   '${MediaQuery.of(context).size.height/(2.55)}'
               // ),
               Container(
                 margin: EdgeInsets.symmetric(vertical: 30),
                 child: common_button(
                   onTap: () {
                     Get.to(Password_otp_verification());
                     // displayBottomSheet(context);
                   },
                   backgroud_color: Colors.white,
                   lable_text: 'Verify Now',
                   lable_text_color: Colors.black,
                 ),
               )
             ],
           ),
         ),
        );
      },
    );
  }

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
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
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
                TxtUtils.forgot_password,
                style: TextStyle(
                    fontSize: 16, fontFamily: 'PB', color: Colors.white),
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
                  Container(
                    // color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 86, vertical: 10),
                    child: Image.asset(
                      AssetUtils.logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    child: Text(
                      'Enter Email',
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'PB', color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 68,
                  ),
                  CommonTextFormField(
                    controller: _password_reset_controller.email_controller,
                    title: TxtUtils.Email,
                    labelText: TxtUtils.Email,
                    // keyboardType: TextInputType.number,
                    image_path: AssetUtils.chat_icon,
                  ),
                  SizedBox(
                    height: 76,
                  ),
                  common_button(
                    onTap: () async {
                      if(_password_reset_controller.email_controller.text.isEmpty){
                        CommonWidget().showErrorToaster(msg: "Enter valid Email");
                      }
                      else{
                        await _password_reset_controller.pass_reset_SendOtp(context);
                        if(_password_reset_controller.Forgot_passwordModel!.error! == true){
                          CommonWidget().showErrorToaster(msg: "Enter valid Email");
                        }
                        displayBottomSheet(context);
                      }
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
