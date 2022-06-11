import 'package:flutter/material.dart';
import 'package:funky_new/settings/privacy_setting_screen.dart';
import 'package:funky_new/settings/report_problem.dart';
import 'package:funky_new/settings/security_login/security_login.dart';

// import 'package:funky_project/settings/privacy_setting_screen.dart';
// import 'package:funky_project/settings/report_problem.dart';
// import 'package:funky_project/settings/security_login/security_login.dart';
import 'package:get/get.dart';

import '../Authentication/authentication_screen.dart';
import '../Utils/App_utils.dart';
import '../Utils/asset_utils.dart';
import '../Utils/toaster_widget.dart';
import '../sharePreference.dart';
import 'blockList_screen.dart';
import 'community_guide.dart';
import 'help_center.dart';
import 'invite_friends.dart';
import 'kids_account/kids_account_screen.dart';
import 'manage_accounts/manage_account_screen.dart';
import 'notification_settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // List icon_list = [
  //   AssetUtils.manage_icon,
  //   AssetUtils.privacy_icon,
  //   AssetUtils.security_icon,
  //   AssetUtils.rewards_icon,
  //   AssetUtils.kidsaccount_icon,
  //   AssetUtils.invite_icon,
  //   AssetUtils.notification_icon,
  //   AssetUtils.report_icon,
  //   AssetUtils.help_icon,
  //   AssetUtils.community_icon,
  //   AssetUtils.terms_service_icon,
  //   AssetUtils.copyright_icon,
  //   AssetUtils.copyright_icon,
  //   AssetUtils.logout_icon,
  // ];
  List icon_list = [
    AssetUtils.manage_icon,
    AssetUtils.manage_icon,
    AssetUtils.share_icon,
    AssetUtils.share_icon3,
    AssetUtils.hand_holding,
    AssetUtils.security,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
    AssetUtils.file_alt,
  ];

  List icon_name = [
    "Manage accounts",
    "Privacy",
    "Security and login",
    "Rewards",
    "Kids accocunt",
    "Invite friends",
    "Notifications",
    "Report a problem",
    "Help center",
    "Community guidelines",
    "Terms of service",
    "Copyright policy",
    "Blocked user",
    "Logout",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
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
          Expanded(
            child: ListView.builder(
              itemCount: icon_list.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    print(index);
                    (index == 0
                        ? Get.to(ManageAccount())
                        : (index == 1
                            ? Get.to(Privacy_Settings())
                            : (index == 2
                                ? Get.to(Security_Login())
                                : (index == 4
                                    ? Get.to(KidsAccount())
                                    : (index == 5
                                        ? Get.to(InviteFriends())
                                        : (index == 6
                                            ? Get.to(NotificationSettings())
                                            : (index == 7
                                                ? Get.to(ReportProblem())
                                                : (index == 8
                                                    ? Get.to(HelpCenterScreen())
                                                    : (index == 9
                                                        ? Get.to(
                                                            CommunityGuide())
                                                        : (index == 12
                                                            ? Get.to(
                                                                BlockListScreen())
                                                            : (index == 13
                                                                ? Get.to(
                                                                    logOut_function())
                                                                : null)))))))))));
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        icon_list[index],
                        height: 15,
                        width: 15,
                      ),
                    ),
                    title: Text(
                      icon_name[index],
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  logOut_function() async {
    await PreferenceManager().setPref(URLConstants.id, ' ');
    await PreferenceManager().setPref(URLConstants.type, '');
    await Get.to(AuthenticationScreen());
    setState(() {});
    CommonWidget().showToaster(msg: 'User LoggedOut');
  }
}
