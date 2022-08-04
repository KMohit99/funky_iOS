import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Authentication/creator_login/controller/creator_login_controller.dart';
import '../../../../Utils/asset_utils.dart';
import '../../../bloc/login/login_screen_bloc.dart';
import '../../../bloc/login/login_screen_events.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class UserNameTextField extends StatefulWidget {
  UserNameTextField({Key? key, this.textField, this.loginBloc, required this.txtController}) : super(key: key);

  final TextField? textField;
  final LoginScreenBloc? loginBloc;
  final TextEditingController txtController;
  @override
  State<UserNameTextField> createState() => _UserNameTextFieldState();
}

class _UserNameTextFieldState extends State<UserNameTextField> {
  // final TextEditingController txtController = TextEditingController();

  final Creator_Login_screen_controller _loginScreenController = Get.put(
      Creator_Login_screen_controller(),
      tag: Creator_Login_screen_controller().toString());


  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) {
    //   _loginScreenController.usernameController.text = 'jinal56';
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 18),
            child: Text(
              "Username",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'PR',
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                  spreadRadius: -5,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: TextFormField(

              controller: widget.txtController,
              onChanged: (userName) {
                if (userName.contains('  ')) {
                  userName = userName.replaceAll('  ', ' ');
                  widget.txtController
                    ..text = userName
                    ..selection = TextSelection.collapsed(offset: userName.length);
                } else {
                  widget.loginBloc?.events?.add(ChangedUsernameFieldEvent(userName));
                }
              },
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'PR',
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
                filled: false,
                isDense: true,
                fillColor: Colors.white,
                hintText: 'Username',
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                border: InputBorder.none,
                // focusedBorder: OutlineInputBorder(
                //   borderSide:
                //   BorderSide(color: ColorUtils.blueColor, width: 1),
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'PR',
                  color: Colors.grey,
                ),
                suffixIcon: Container(
                  child: IconButton(
                    icon: Image.asset(
                      AssetUtils.msg_icon,
                      color: Colors.black,
                      height: 20,
                      width: 20,
                    ),
                    onPressed:(){},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
