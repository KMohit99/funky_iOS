
import 'package:flutter/material.dart';

import '../screens/app_info/app_info_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat_info/chat_info_screen.dart';
import '../screens/delivered_to/delivered_viewed_screen.dart';
import '../screens/dialogs/dialogs_screen.dart';
import '../screens/enter_chat_name/enter_chat_name_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/select_users/select_users_screen.dart';
import '../screens/splash/splash_screen.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

const String SplashScreenRoute = '/';
const String LoginScreenRoute = 'login';
const String AppInfoScreenRoute = 'app_info';
const String DialogsScreenRoute = 'dialogs_list';
const String ChatScreenRoute = 'chat';
const String ChatInfoScreenRoute = 'chat_info';
const String DeliveredViewedScreenRoute = 'delivered_viewed';
const String SelectUsersScreenRoute = 'select_users';
const String EnterChatNameScreenRoute = 'enter_chat_name';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case LoginScreenRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case DialogsScreenRoute:
      return MaterialPageRoute(builder: (context) => DialogsScreen());
    case AppInfoScreenRoute:
      return MaterialPageRoute(builder: (context) => AppInfoScreen());
    case SelectUsersScreenRoute:
      return MaterialPageRoute(builder: (context) => SelectUsersScreen(""));
    case EnterChatNameScreenRoute:
      return MaterialPageRoute(builder: (context) => EnterChatNameScreen(0, []));
    case ChatScreenRoute:
      return MaterialPageRoute(builder: (context) => ChatScreen("", false));
    case ChatInfoScreenRoute:
      return MaterialPageRoute(builder: (context) => ChatInfoScreen(""));
    case DeliveredViewedScreenRoute:
      return MaterialPageRoute(builder: (context) => DeliveredViewedScreen("", "", false));
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
