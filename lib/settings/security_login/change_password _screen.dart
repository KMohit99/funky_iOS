import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/asset_utils.dart';
import '../../Utils/colorUtils.dart';
import '../../Utils/custom_textfeild.dart';
import '../../custom_widget/common_buttons.dart';
import 'security_login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Change Password',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              CommonTextFormField(
                // controller: _loginScreenController.usernameController,
                title: 'Current Password',
                labelText: 'Password',
                image_path: AssetUtils.key_icon,
              ),
              SizedBox(
                height: 25,
              ),
              CommonTextFormField(
                // controller: _loginScreenController.usernameController,
                title: 'New Password',
                labelText: 'Enter Password',
                image_path: AssetUtils.key_icon,
              ),
              SizedBox(
                height: 25,
              ),
              CommonTextFormField(
                // controller: _loginScreenController.usernameController,
                title: 'Confirm new Password',
                labelText: 'Enter new Password',
                image_path: AssetUtils.key_icon,
              ),
              SizedBox(
                height: 50,
              ),
              common_button(
                onTap: () {
                  selectTowerBottomSheet(context);
                  // _loginScreenController.checkLogin(
                  //     context: context,
                  //     login_type: TxtUtils.Login_type_creator);
                },
                backgroud_color: HexColor(CommonColor.pinkFont),
                lable_text: 'Done',
                lable_text_color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
  selectTowerBottomSheet(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: StatefulBuilder(
            builder: (context, state) {
              return Container(
                height: screenheight * 0.43,
                width: screenwidth,
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
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.check,
                            size: 40,
                          ),
                        ),
                      ),
                      Text(
                        'Your password has been changed successfully',
                        textAlign: TextAlign.center ,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PR',
                            color: Colors.white),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 40,horizontal: 60),
                          child: common_button(
                            onTap: () {
                              Get.to(Security_Login());
                              // selectTowerBottomSheet(context);
                              // _kids_loginScreenController.ParentEmailVerification(context);
                            },
                            backgroud_color: Colors.white,
                            lable_text: 'OK',
                            lable_text_color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

}
