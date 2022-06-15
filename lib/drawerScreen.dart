import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Authentication/authentication_screen.dart';
import 'package:funky_new/Utils/toaster_widget.dart';
// import 'package:funky_project/Utils/App_utils.dart';
// import 'package:funky_project/Utils/asset_utils.dart';
import 'package:funky_new/settings/settings_screen.dart';
import 'package:funky_new/sharePreference.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

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
            topRight: Radius.circular(100),
            bottomRight: Radius.circular(100)),
        child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
              color: Colors.black,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#000000"),
                  HexColor("#000000"),
                  HexColor("#C12265").withOpacity(0.4),
                  HexColor("#C12265").withOpacity(0.4),
                  HexColor("#C12265").withOpacity(0.5),
                  HexColor("#C12265").withOpacity(0.7),
                  HexColor("#C12265").withOpacity(0.8),
                  HexColor("#C12265").withOpacity(0.9),
                  HexColor("#C12265").withOpacity(0.9),
                  HexColor("#C12265"),
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
                          margin: EdgeInsets.only(left: 10, top: 40),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
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
                            margin: EdgeInsets.only(left: 20, top: 40),
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
                    SizedBox(height: 20,),
                    drawerItem(
                      itemIcon: AssetUtils.photosIcons,
                      itemName: TxtUtils.photos,
                      onTap: () {
                        Navigator.pop(context);
                        // gotoSalesListScreen(context);
                      },
                    ),
                    drawerItem(
                      itemIcon: AssetUtils.settingsIcons,
                      itemName: TxtUtils.settings,
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.of(context).push(_createRoute());
                        // gotoSalesListScreen(context);
                      },
                    ),
                    drawerItem(
                      itemIcon: AssetUtils.qrcodeIcons,
                      itemName: TxtUtils.qr_code,
                      onTap: () {
                        Navigator.pop(context);
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

                    SizedBox(
                      height: 36,
                    ),
                    (CommonService().getStoreValue(keys: 'type') == 'Kids'
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
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: Text(
                                  "Parent Interface",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PR',
                                      fontSize: 16),
                                )),
                          ],
                        ),
                      ),
                    )
                        : SizedBox.shrink()),
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
          visualDensity: const VisualDensity(vertical: 0.0, horizontal: -4.0),
          leading: SizedBox(
            height: 15.0,
            width: 15.0,
            child: Image.asset(
              itemIcon,
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


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SettingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0,0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  logOut_function() async {

    await PreferenceManager()
        .setPref(URLConstants.id, ' ');
    await PreferenceManager()
        .setPref(URLConstants.type, '');
    await Get.to(AuthenticationScreen());
    setState((){

    });
    CommonWidget().showToaster(msg: 'User LoggedOut');

  }
}
