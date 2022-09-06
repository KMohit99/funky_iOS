import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Authentication/authentication_screen.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
import 'package:funky_new/myQrScreen/MyQrScreen.dart';

// import 'package:funky_project/Utils/App_utils.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
import 'package:funky_new/settings/settings_screen.dart';
import 'package:funky_new/sharePreference.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Authentication/creator_login/model/creator_loginModel.dart';
import 'Utils/App_utils.dart';
import 'Utils/asset_utils.dart';
import 'Utils/colorUtils.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String selectDrawerItem = 'Dashnoard';
  late double screenHeight;

  // final loginControllers = Get.put(Login());

  // final homepagecontroller = Get.put(HomepageController());

  @override
  void initState() {
    super.initState();
  }
  final Uri _url = Uri.parse('https://www.funky.global/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  LoginModel? loginModel;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 1.35,
      margin: const EdgeInsets.only(top: 0, left: 0, bottom: 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(100), bottomRight: Radius.circular(100)),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  // stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    HexColor("#000000"),
                    HexColor("#C12265"),
                    HexColor("#ffffff"),
                    // HexColor("#ffffff").withOpacity(1),
                    // HexColor("#ffffff").withOpacity(0.9),
                  ],
                ),
              ),
              child: Drawer(
                backgroundColor: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, top: 40),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 20, top: 40),
                              child: Image.asset(
                                AssetUtils.logo,
                                height: 120,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.photosIcons,
                        itemName: TxtUtils.photos,
                        onTap: () {
                          _launchUrl();
                          Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.settingsIcons,
                        itemName: TxtUtils.settings,
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.of(context).push(_createSettingsRoute());
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.qrcodeIcons,
                        itemName: TxtUtils.qr_code,
                        onTap: () {
                          Navigator.of(context).push(_createQrRoute());
                          // Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.analyticsIcons,
                        itemName: TxtUtils.analytics,
                        onTap: () {
                          Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.manageacIcons,
                        itemName: TxtUtils.manage_ac,
                        onTap: () {
                          Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.rewardsIcons,
                        itemName: TxtUtils.rewards,
                        onTap: () {
                          Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.termsIcons,
                        itemName: TxtUtils.t_c,
                        onTap: () {
                          Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.helpIcons,
                        itemName: TxtUtils.help,
                        onTap: () {
                          Navigator.pop(context);
                          // gotoSalesListScreen(context);
                        },
                      ),
                      drawerItem(
                        itemIcon: AssetUtils.logout_icon,
                        itemName: 'Logout',
                        onTap: () {
                          logOut_function();
                          // gotoSalesListScreen(context);
                        },
                      ),

                      const SizedBox(
                        height: 36,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 40.0, right: 20.0, top: 0.0, bottom: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '\u00a9',
                              style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.w400),
                            ) ,
                            Expanded(
                              child: Text(
                                '2021 - 2022 Funky Private Limited.\nAll Rights Reserved',
                                style: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'PM',fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      (PreferenceManager().getPref(URLConstants.type) == 'Kids'
                          ? GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 45),
                                // height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        AssetUtils.secret_parent,
                                        height: 25.0,
                                        width: 25.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: const Text(
                                          "Parent Interface",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'PR',
                                              fontSize: 16),
                                        )),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(
                        height: 20,
                      )),
                      // drawerItem(
                      //   itemIcon: CommonImage.logout_icons,
                      //   itemName: Texts.logout,
                      //   onTap: () => CommonWidget().showalertDialog(
                      //     context: context,
                      //     getMyWidget: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         const Text(
                      //           'Logout',
                      //           style: TextStyle(
                      //               fontFamily: AppDetails.fontSemiBold,
                      //               fontSize: 19,
                      //               color: Colors.black),
                      //         ),
                      //         const Padding(
                      //           padding: EdgeInsets.only(
                      //               left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                      //           child: Text(
                      //             'Are you sure you want to logout?',
                      //             style: TextStyle(
                      //               fontSize: 15,
                      //               fontFamily: AppDetails.fontMedium,
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 15.0,
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: <Widget>[
                      //             CommonWidget().CommonButton(
                      //               buttonText: 'Yes',
                      //               onPressed: () {
                      //                 showLoader(context);
                      //                 loginControllers.logoutUser(context);
                      //                 hideLoader(context);
                      //               },
                      //               context: context,
                      //             ),
                      //             const SizedBox(
                      //               width: 15.0,
                      //             ),
                      //             CommonWidget().CommonNoButton(
                      //               buttonText: 'No',
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //               },
                      //               context: context,
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell drawerItem({
    required String itemIcon,
    required String itemName,
    Color? text_color,
    void Function()? onTap,
  }) {
    return InkWell(
        onTap: onTap!,
        child: ListTile(
          contentPadding: const EdgeInsets.only(
              left: 40.0, right: 0.0, top: 0.0, bottom: 0.0),
          visualDensity: const VisualDensity(vertical: -2.0, horizontal: -4.0),
          leading: SizedBox(
            height: 15.0,
            width: 15.0,
            child: Image.asset(
              itemIcon,
              color: Colors.white,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            itemName.toString(),
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'PR',
              color: (text_color ?? Colors.white),
            ),
          ),
        ));
  }

  SizedBox setSpace() => SizedBox(
        height: screenHeight * 0.01,
      );

  Route _createSettingsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SettingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createQrRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MyQrScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  logOut_function() async {
    await PreferenceManager().setPref(URLConstants.id, '');
    await PreferenceManager().setPref(URLConstants.type, '');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
      (Route<dynamic> route) => false,
    );
    // await Get.to(AuthenticationScreen());
    setState(() {});
    CommonWidget().showToaster(msg: 'User LoggedOut');
  }
}
