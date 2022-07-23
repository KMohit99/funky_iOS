import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:funky_new/splash_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/providers/auth_provider.dart';
import 'chat/providers/chat_provider.dart';
import 'chat/providers/home_provider.dart';
import 'getx_pagination/Bindings_class.dart';
import 'getx_pagination/binding_utils.dart';
import 'getx_pagination/page_route.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
  //     PlayIntegrityAppCheckProviderFactory.getInstance())
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs,));

}
RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            firebaseAuth: FirebaseAuth.instance,
            googleSignIn: GoogleSignIn(),
            prefs: this.prefs,
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        // Provider<SettingProvider>(
        //   create: (_) => SettingProvider(
        //     prefs: this.prefs,
        //     firebaseFirestore: this.firebaseFirestore,
        //     firebaseStorage: this.firebaseStorage,
        //   ),
        // ),
        Provider<HomeProvider>(
          create: (_) => HomeProvider(
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            prefs: prefs,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
      ],
      child: GetMaterialApp(
        // navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Funky',
        initialRoute: BindingUtils.initialRoute,
        initialBinding: Splash_Bindnig(),
        getPages: AppPages.getPageList,
        navigatorObservers: [routeObserver], //HERE

        // home: (Token == '_' ||
        //         Token.toString() == 'null' ||
        //         Token.toString().isEmpty ||
        //         roles == '_' ||
        //         roles == 'null' ||
        //         roles.toString().isEmpty)
        //     ? loginScreen()
        //     : (roles == "company")
        //         ? addCompanyScreen()
        //         : (roles == "plan")
        //             ? subscription_Screen()
        //             : DashBoardScreen(),
        home: SplashScreen(),
        theme: ThemeData(
          primaryColor: Colors.yellow,
          dividerColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}