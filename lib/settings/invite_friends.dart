import 'package:flutter/material.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
// import 'package:funky_project/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
import '../custom_widget/common_buttons.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Invite friends',
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 75),
            child: Image.asset(AssetUtils.friends_icon),
          ),
          SizedBox(
            height: 41,
          ),
          SizedBox(
            width: 300,
            child: common_button(
              onTap: () {
                // selectTowerBottomSheet(context);
                // _kids_loginScreenController.ParentEmailVerification(context);
              },
              backgroud_color: HexColor(CommonColor.pinkFont),
              lable_text: 'Invite friends by',
              lable_text_color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
