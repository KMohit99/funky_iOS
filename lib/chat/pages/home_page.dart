import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../utils/debouncer.dart';
import '../utils/utilities.dart';
import '../widgets/widgets.dart';
import 'pages.dart';

class HomePage_chat extends StatefulWidget {
  HomePage_chat({Key? key}) : super(key: key);

  @override
  State createState() => HomePage_chatState();
}

class HomePage_chatState extends State<HomePage_chat> {
  HomePage_chatState({Key? key});

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;

  late AuthProvider authProvider;
  late String currentUserId;
  late HomeProvider homeProvider;
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchBarTec = TextEditingController();

  List<PopupChoices> choices = <PopupChoices>[
    PopupChoices(title: 'Settings', icon: Icons.settings),
    PopupChoices(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();

    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
    registerNotification();
    configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  void registerNotification() {

    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        homeProvider.updateDataFirestore(FirestoreConstants.pathUserCollection,
            currentUserId, {'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onItemMenuPress(PopupChoices choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      // 'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: ColorConstants.themeColor,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Cancel',
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: ColorConstants.primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Yes',
                      style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  Future<void> handleSignOut() async {
    authProvider.handleSignOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: HexColor("#000000"),
          title: Text(
            "Chat",
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'PM'),
          ),
          centerTitle: true,
          // leadingWidth: 100,
          leading: Container(
            margin: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // List
          StreamBuilder<QuerySnapshot>(
            stream: homeProvider.getStreamFireStore(
                FirestoreConstants.pathUserCollection, _limit, _textSearch),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if ((snapshot.data?.docs.length ?? 0) > 0) {
                  return ListView.builder(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    controller: listScrollController,
                  );
                } else {
                  return Center(
                    child: Text(
                      "No users",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PR',
                          color: Colors.white),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.themeColor,
                  ),
                );
              }
            },
          ),

          // Loading
          Positioned(
            child: isLoading ? LoadingView() : SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstants.greyColor2,
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, color: ColorConstants.greyColor, size: 20),
          SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Search nickname (you have to type exactly string)',
                hintStyle:
                    TextStyle(fontSize: 13, color: ColorConstants.greyColor),
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchBarTec.clear();
                          btnClearController.add(false);
                          setState(() {
                            _textSearch = "";
                          });
                        },
                        child: Icon(Icons.clear_rounded,
                            color: ColorConstants.greyColor, size: 20))
                    : SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  Widget buildPopupMenu() {
    return PopupMenuButton<PopupChoices>(
      onSelected: onItemMenuPress,
      itemBuilder: (BuildContext context) {
        return choices.map((PopupChoices choice) {
          return PopupMenuItem<PopupChoices>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color: ColorConstants.primaryColor,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(color: ColorConstants.primaryColor),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      print(userChat.photoUrl);

      if (userChat.id == currentUserId) {
        return SizedBox.shrink();
      } else {
        return Container(
          margin: EdgeInsets.only(bottom: 0, left: 5, right: 5),
          child: TextButton(
              onPressed: () {
                if (Utilities.isKeyboardShowing()) {
                  Utilities.closeKeyboard(context);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      arguments: ChatPageArguments(
                        peerId: userChat.id,
                        peerAvatar: userChat.photoUrl,
                        peerNickname: userChat.nickname,
                      ),
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              child: ListTile(
                // tileColor: Colors.white,
                visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                leading: userChat.photoUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: Image.network(
                          userChat.photoUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.themeColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 50,
                              color: ColorConstants.greyColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50,
                        color: ColorConstants.greyColor,
                      ),
                title: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text(
                    '${userChat.nickname.capitalize}',
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white, fontFamily: 'PB'),
                  ),
                ),
                subtitle: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    'About me: ${userChat.id}',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 14,
                        color: HexColor(CommonColor.subHeaderColor),
                        fontFamily: 'PR'),
                  ),
                ),
              )
              // Row(
              //   children: <Widget>[
              //     Material(
              //       borderRadius: BorderRadius.all(Radius.circular(25)),
              //       clipBehavior: Clip.hardEdge,
              //       child: userChat.photoUrl.isNotEmpty
              //           ? Image.network(
              //               userChat.photoUrl,
              //               fit: BoxFit.cover,
              //               width: 50,
              //               height: 50,
              //               loadingBuilder: (BuildContext context, Widget child,
              //                   ImageChunkEvent? loadingProgress) {
              //                 if (loadingProgress == null) return child;
              //                 return Container(
              //                   width: 50,
              //                   height: 50,
              //                   child: Center(
              //                     child: CircularProgressIndicator(
              //                       color: ColorConstants.themeColor,
              //                       value: loadingProgress.expectedTotalBytes !=
              //                               null
              //                           ? loadingProgress.cumulativeBytesLoaded /
              //                               loadingProgress.expectedTotalBytes!
              //                           : null,
              //                     ),
              //                   ),
              //                 );
              //               },
              //               errorBuilder: (context, object, stackTrace) {
              //                 return Icon(
              //                   Icons.account_circle,
              //                   size: 50,
              //                   color: ColorConstants.greyColor,
              //                 );
              //               },
              //             )
              //           : Icon(
              //               Icons.account_circle,
              //               size: 50,
              //               color: ColorConstants.greyColor,
              //             ),
              //     ),
              //     Flexible(
              //       child: Container(
              //         margin: EdgeInsets.only(left: 20),
              //         child: Column(
              //           children: <Widget>[
              //             Container(
              //               alignment: Alignment.centerLeft,
              //               margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
              //               child: Text(
              //                 'Nickname: ${userChat.nickname}',
              //                 maxLines: 1,
              //                 style:
              //                     TextStyle(color: ColorConstants.primaryColor),
              //               ),
              //             ),
              //             Container(
              //               alignment: Alignment.centerLeft,
              //               margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              //               child: Text(
              //                 'About me: ${userChat.aboutMe}',
              //                 maxLines: 1,
              //                 style:
              //                     TextStyle(color: ColorConstants.primaryColor),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              ),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}
