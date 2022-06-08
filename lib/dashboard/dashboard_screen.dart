import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funky_new/global_key.dart';
// import 'package:funky_project/Authentication/creator_login/controller/creator_login_controller.dart';
// import 'package:funky_project/homepage/ui/homepage_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/asset_utils.dart';
import '../Utils/colorUtils.dart';
// import '../drawerScreen.dart';
// import '../news_feed/new_feed_screen.dart';
// import '../profile_screen/profile_screen.dart';
// import '../search_screen/search_screen.dart';
import 'dart:math' as math;

import '../drawerScreen.dart';
import '../homepage/ui/homepage_screen.dart';
import '../news_feed/new_feed_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../search_screen/search_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double screenHeight, screenWidth;
  int _page = 0;
  String? appbar_name;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget? get getPage {
    if (_page == 0) {
      return const HomePageScreen();
    } else if (_page == 1) {
      return const SearchScreen();
    } else if (_page == 2) {
      return const NewsFeedScreen();
    } else if (_page == 3) {
      return const Profile_Screen();
    }
  }

  GlobalKey<ScaffoldState>? _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _globalKey,
      // drawer: DrawerScreen(),
      backgroundColor: HexColor(CommonColor.appBackColor),
      extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   title: Text(
        //     "appbar_name",
        //     style:
        //     TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        //   ),
        //   centerTitle: true,
        //   actions: [
        //     Row(
        //       children: [
        //         InkWell(
        //           child: Padding(
        //             padding: const EdgeInsets.only(
        //                 right: 20.0, top: 0.0, bottom: 5.0),
        //             child: ClipRRect(
        //               child: Image.asset(
        //                 AssetUtils.noti_icon,
        //                 height: 20.0,
        //                 width: 20.0,
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //         ),
        //         InkWell(
        //           child: Padding(
        //             padding: const EdgeInsets.only(
        //                 right: 20.0, top: 0.0, bottom: 5.0),
        //             child: ClipRRect(
        //               child: Image.asset(
        //                 AssetUtils.chat_icon,
        //                 height: 20.0,
        //                 width: 20.0,
        //                 fit: BoxFit.contain,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     )
        //   ],
        //   leadingWidth: 100,
        //   leading: Row(
        //     children: [
        //       Container(
        //         margin: EdgeInsets.only(left: 16, top: 0, bottom: 0),
        //         child: IconButton(
        //             padding: EdgeInsets.zero,
        //             onPressed: () {
        //               print('oject');
        //               _globalKey!.currentState!.openDrawer();
        //             },
        //             icon: (Image.asset(
        //               AssetUtils.drawer_icon,
        //               color: Colors.white,
        //               height: 12.0,
        //               width: 19.0,
        //               fit: BoxFit.contain,
        //             ))),
        //       ),
        //       Expanded(
        //         child: Container(
        //           margin: EdgeInsets.only(left: 18, top: 0, bottom: 0),
        //           child: IconButton(
        //               padding: EdgeInsets.zero,
        //               onPressed: () {},
        //               icon: (Image.asset(
        //                 AssetUtils.user_icon,
        //                 color: Colors.white,
        //                 height: 20.0,
        //                 width: 20.0,
        //                 fit: BoxFit.contain,
        //               ))),
        //         ),
        //       ),
        //     ],
        //   ),
        // )   ,
        drawer: DrawerScreen(),

      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 80,
          child: BottomAppBar(
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.red,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    HexColor("#C12265"),
                    HexColor("#000000"),
                    HexColor("#000000"),
                    // HexColor("#FFFFFF").withOpacity(0.67),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 28.0),
                    decoration: BoxDecoration(
                        color: (_page == 0 ? Colors.white : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.home_icon,
                        color: (_page == 0 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _page = 0;
                          // _myPage.jumpToPage(0);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 28.0),
                    decoration: BoxDecoration(
                        color: (_page == 1 ? Colors.white : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.search_icon,
                        color: (_page == 1 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _page = 1;
                          // _myPage.jumpToPage(1);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28.0),
                    decoration: BoxDecoration(
                        color: (_page == 2 ? Colors.white : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.news_icon,
                        color: (_page == 2 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _page = 2;
                          // _myPage.jumpToPage(2);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 28.0),
                    decoration: BoxDecoration(
                        color: (_page == 3 ? Colors.white : Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                      iconSize: 25.0,
                      icon: Image.asset(
                        AssetUtils.user_icon2,
                        color: (_page == 3 ? Colors.black : Colors.white),
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _page = 3;

                          // _myPage.jumpToPage(3);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !showFab,
        child: Material(
          type: MaterialType.transparency,
          borderOnForeground:true ,
          child: Container(
            height: 80,
            width: 80,
            child: Stack(
              children: [
                Container(child: MyArc(diameter: 80),),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50.79,
                    width: 50.79,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.14), width: 5),
                      borderRadius: BorderRadius.circular(50),
                      // color: Colors.grey
                    ),
                    child: SizedBox(
                      height: 45.79,
                      width: 45.79,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                double width = MediaQuery.of(context).size.width;
                                double height = MediaQuery.of(context).size.height;
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      contentPadding: EdgeInsets.zero,
                                      elevation: 0.0,
                                      // title: Center(child: Text("Evaluation our APP")),
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 110, horizontal: 70),
                                            height: 122,
                                            // width: 133,
                                            // padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment(-1.0, 0.0),
                                                  end: Alignment(1.0, 0.0),
                                                  transform: GradientRotation(0.7853982),
                                                  // stops: [0.1, 0.5, 0.7, 0.9],
                                                  colors: [
                                                    HexColor("#000000"),
                                                    HexColor("#000000"),
                                                    HexColor("##E84F90"),
                                                    HexColor("#ffffff"),
                                                    // HexColor("#FFFFFF").withOpacity(0.67),
                                                  ],
                                                ),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.white, width: 1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(26.0))),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Post',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'PR',
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Divider(
                                                    color: Colors.black,
                                                    height: 20,
                                                  ),
                                                ),
                                                Text(
                                                  'Videos',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'PR',
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Divider(
                                                    color: Colors.black,
                                                    height: 20,
                                                  ),
                                                ),
                                                Text(
                                                  'Live',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'PR',
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                );
                              },
                            );
                          },
                          tooltip: 'Increment',
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          ),
                          elevation: 0.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: getPage!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({Key? key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}


// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = HexColor('#C12265');
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}