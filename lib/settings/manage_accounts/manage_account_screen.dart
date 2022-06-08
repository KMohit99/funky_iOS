import 'package:flutter/material.dart';
import 'package:funky_new/settings/manage_accounts/post_settings.dart';
import 'package:funky_new/settings/manage_accounts/privacy_screen.dart';
import 'package:funky_new/settings/manage_accounts/request_verification.dart';
import 'package:funky_new/settings/manage_accounts/security_checkup/security_checkup_screen.dart';
import 'package:funky_new/settings/manage_accounts/terms_services.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import 'package:get/get.dart';

import '../../Authentication/authentication_screen.dart';
import '../../Utils/asset_utils.dart';
import '../blockList_screen.dart';
import 'comment_settings.dart';
import 'email_settings.dart';
import 'email_sms.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key? key}) : super(key: key);

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
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
  ];

  List icon_name = [
    "Privacy",
    "Add account",
    "Logout adult / kids account",
    "Logout all account",
    "Request verification",
    "Security checkup",
    "Post Setting",
    "Comment Setting",
    "Email",
    "Email & SMS",
    "Privacy policy",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Manage Account',
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
                        ? Get.to(PrivcacyScreen())
                        : (index == 1
                            ? Get.to(AuthenticationScreen())
                            : (index == 2
                                ? Get.to(AuthenticationScreen())
                                : (index == 3
                                    ? Get.to(AuthenticationScreen())
                                    : (index == 4
                                        ? Get.to(RequestVerification())
                                        : (index == 6
                                            ? Get.to(PostSettings())
                                            : (index == 7
                                                ? Get.to(CommentSettins())
                                                : (index == 8
                                                    ? Get.to(EmailSettings())
                                                    : (index == 9
                                                        ? Get.to(
                                                            Email_sms_Screen())
                                                        : (index == 10
                                                            ? Get.to(
                                                                Temrs_servicesScreen())
                                                            : (index == 5
                                                                ? Get.to(
                                                                    SecurityCheckup())
                                                                : null)))))))))));
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        icon_list[index],
                        height: 20,
                        width: 20,
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
}
