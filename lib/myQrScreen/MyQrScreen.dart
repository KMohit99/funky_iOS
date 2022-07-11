import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:funky_new/Utils/asset_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../Authentication/creator_login/controller/creator_login_controller.dart';
import '../Utils/App_utils.dart';
import '../Utils/colorUtils.dart';
import '../sharePreference.dart';
import 'Qr_scan_screen.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({Key? key}) : super(key: key);

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  GlobalKey globalKey = new GlobalKey();
  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    String id_user = await PreferenceManager().getPref(URLConstants.id);
    String social_type_user =
        await PreferenceManager().getPref(URLConstants.social_type);
    print("id----- $id_user");
    print("id----- $social_type_user");
    (social_type_user == ""
        ? await _creator_login_screen_controller.CreatorgetUserInfo_Email(
            UserId: id_user)
        : await _creator_login_screen_controller.getUserInfo_social());
  }

  static List<Color> gradientRed = [
    HexColor('#56ab2f'),
    HexColor('#a8e063'),
  ];
  static List<Color> gradientBlue = [Colors.blue, Colors.blueAccent];

  List gradientColor = [gradientBlue, gradientRed];

  List colors_grad = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ffafbd"),
        HexColor("#ffc3a0"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#2193b0"),
        HexColor("#6dd5ed"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#cc2b5e"),
        HexColor("#753a88"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ee9ca7"),
        HexColor("#ffdde1"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#bdc3c7"),
        HexColor("#2c3e50"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#de6262"),
        HexColor("#ffb88c"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#eb3349"),
        HexColor("#f45c43"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#dd5e89"),
        HexColor("#f7bb97"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#56ab2f"),
        HexColor("#a8e063"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#614385"),
        HexColor("#516395"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#eecda3"),
        HexColor("#ef629f"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#eacda3"),
        HexColor("#d6ae7b"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#02aab0"),
        HexColor("#00cdac"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#d66d75"),
        HexColor("#e29587"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#000428"),
        HexColor("#004e92"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ddd6f3"),
        HexColor("#faaca8"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#7b4397"),
        HexColor("#dc2430"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#43cea2"),
        HexColor("#185a9d"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ba5370"),
        HexColor("#f4e2d8"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ff512f"),
        HexColor("#dd2476"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#4568dc"),
        HexColor("#b06ab3"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ec6f66"),
        HexColor("#f3a183"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ed4264"),
        HexColor("#ffedbc"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#ff9966"),
        HexColor("#ff5e62"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#aa076b"),
        HexColor("#61045f"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#2b5876"),
        HexColor("#4e4376"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#141e30"),
        HexColor("#243b55"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#4ca1af"),
        HexColor("#c4e0e5"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#3a1c71"),
        HexColor("#d76d77"),
        HexColor("#ffaf7b"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        HexColor("#4ca1af"),
        HexColor("#c4e0e5"),
        HexColor("#ffaf7b"),
        // HexColor("#FFFFFF").withOpacity(0.67),
      ],
    ),
  ];

  int selected_gradient = -1;

  Future popUp() {
    return showDialog(
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
              content: Container(
                // height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width / 2,
                margin: const EdgeInsets.symmetric(vertical: 00, horizontal: 0),
                // height: 115,
                // width: 133,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      // stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        HexColor("#000000"),
                        HexColor("#000000"),
                        HexColor("#C12265"),
                        HexColor("#ffffff"),
                        // HexColor("#FFFFFF").withOpacity(0.67),
                      ],
                    ),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(26.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Change back Ground Theme',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'PB',
                                  color: Colors.white),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 50),
                              child: GridView.builder(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: colors_grad.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      print(index);
                                      setState(() {
                                        selected_gradient = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                          gradient: colors_grad[index]),
                                      height: 30,
                                      width: 30,
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // Navigator
                            //     //     .push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //         builder: (BuildContext context) =>
                            //     //             VideoRecorder()));
                            //   },
                            //   child: const Text(
                            //     'Live',
                            //     style: TextStyle(
                            //         fontSize: 15,
                            //         fontFamily: 'PR',
                            //         color: Colors.white),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    selected_gradient = -1;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15),
                                    child: Text(
                                      'Cancle',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'PB',
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15),
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'PB',
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            gradient: (selected_gradient >= 0
                ? colors_grad[selected_gradient]
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      HexColor("#000000"),
                      HexColor("#000000"),
                      HexColor("#C12265"),
                      HexColor("#C12265"),
                      HexColor("#ffffff"),
                    ],
                  )),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Scan',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'PB'),
            ),
            centerTitle: true,
            leadingWidth: 100,
            leading: Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
                top: 0.0,
                bottom: 5.0,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  top: 0.0,
                  bottom: 5.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    _captureAndSharePng(context);
                  },
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    child: Image.asset(AssetUtils.share_icon2),
                  ),
                ),
              )
            ],
          ),
          body: Obx(() =>
              (_creator_login_screen_controller.isuserinfoLoading.value == true
                  ? Center(
                      child: Container(
                          height: 80,
                          width: 100,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircularProgressIndicator(
                                color: HexColor('#FFFFFF'),
                              ),
                            ],
                          )
                          // Material(
                          //   color: Colors.transparent,
                          //   child: LoadingIndicator(
                          //     backgroundColor: Colors.transparent,
                          //     indicatorType: Indicator.ballScale,
                          //     colors: _kDefaultRainbowColors,
                          //     strokeWidth: 4.0,
                          //     pathBackgroundColor: Colors.yellow,
                          //     // showPathBackground ? Colors.black45 : null,
                          //   ),
                          // ),
                          ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                popUp();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 29),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 29),
                                  child: Text(
                                    'Color',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: 'Pr'),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 29),
                              child: Text(
                                'Friends can scan this to follow you.',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'PB'),
                              ),
                            ),
                            Container(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 26, horizontal: 50),
                              child: RepaintBoundary(
                                key: globalKey,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    // color: Colors.red,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white,width: 30)
                                    ),
                                    child: QrImage(
                                      data: _creator_login_screen_controller
                                          .userInfoModel_email!
                                          .data![0]
                                          .userName!,
                                      // size: 200,

                                      foregroundColor: Colors.white,
                                      // backgroundColor: Colors.black,
                                      padding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(QrScanScreen());
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Scan QR Code',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'PB'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
        ),
      ],
    );
  }

  File? file;

  Future<void> _captureAndSharePng(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//captures qr image
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
//app directory for storing images.
      final appDir = await getApplicationDocumentsDirectory();
//current time
      var datetime = DateTime.now();
//qr image file creation
      file = await File('${appDir.path}/$datetime.png').create();
//appending data
      await file?.writeAsBytes(pngBytes);
//Shares QR image
      await Share.shareFiles(
        [file!.path],
        mimeTypes: ["image/png"],
        text: "Share the QR Code",
      );
      print(file!.path);
      // final ByteData bytes = await rootBundle.load('assets/image1.png');
      // await Share.file(
      //     'esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png',
      //     text: 'My optional text.');
    } catch (e) {
      print(e.toString());
    }
  }
}
