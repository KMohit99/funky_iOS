import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/toaster_widget.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../Utils/toaster_widget.dart';
import '../../../custom_widget/common_buttons.dart';
import '../controller/password_reset_controller.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({Key? key}) : super(key: key);

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final password_reset_controller _password_reset_controller = Get.put(
      password_reset_controller(),
      tag: password_reset_controller().toString());
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
        Scaffold(
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
                SizedBox(height: 0,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 86,vertical: 20),
                  child: Image.asset(AssetUtils.logo,fit: BoxFit.cover,),
                ),

                SizedBox(
                  height: 21,
                ),
                CommonTextFormField(
                  controller: _password_reset_controller.reset_password_controller,
                  title: 'Enter new Password',
                  labelText: 'Password',
                  // keyboardType: TextInputType.number,
                  image_path: AssetUtils.chat_icon,
                ),
                SizedBox(
                  height: 21,
                ),
                CommonTextFormField(
                  controller: _password_reset_controller.confirm_reset_password_controller,
                  title: 'Confirm new Password',
                  labelText: 'Confirm Password',
                  // keyboardType: TextInputType.number,
                  image_path: AssetUtils.chat_icon,
                ),
                SizedBox(
                  height: 37,
                ),
                common_button(
                  onTap: (){
                    if(_password_reset_controller.reset_password_controller.text != _password_reset_controller.confirm_reset_password_controller.text){
                      CommonWidget().showErrorToaster(msg: 'Password does not match');
                    }else{
                      _password_reset_controller.set_newPassword_api(context: context);
                    }
                     },
                  backgroud_color: Colors.black,
                  lable_text: 'Next',
                  lable_text_color: Colors.white,
                ),

              ],
            ),
          ),
        )
      ],
    );
  }
}
