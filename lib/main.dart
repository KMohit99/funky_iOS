import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funky_new/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/providers/auth_provider.dart';
import 'chat/providers/chat_provider.dart';
import 'chat/providers/home_provider.dart';
import 'chat_quickblox/bloc/app_info/app_info_screen_bloc.dart';
import 'chat_quickblox/bloc/chat/chat_screen_bloc.dart';
import 'chat_quickblox/bloc/chat_info/chat_info_screen_bloc.dart';
import 'chat_quickblox/bloc/delivered_to/delivered_viewed_screen_bloc.dart';
import 'chat_quickblox/bloc/dialogs/dialogs_screen_bloc.dart';
import 'chat_quickblox/bloc/enter_chat_name/enter_chat_name_screen_bloc.dart';
import 'chat_quickblox/bloc/login/login_screen_bloc.dart';
import 'chat_quickblox/bloc/select_users/select_users_screen_bloc.dart';
import 'chat_quickblox/bloc/splash/splash_screen_bloc.dart';
import 'getx_pagination/Bindings_class.dart';
import 'getx_pagination/binding_utils.dart';
import 'getx_pagination/page_route.dart';

const String DEFAULT_USER_PASSWORD = "quickblox";

const String APPLICATION_ID = "97645";
const String AUTH_KEY = "zMfg3CY5hGOQ62N";
const String AUTH_SECRET = "TXXHYs7OpENOPsR";
const String ACCOUNT_KEY = "R1aFtjU24PBd5wN9qg3n";


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
  //     PlayIntegrityAppCheckProviderFactory.getInstance())
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await Hive.initFlutter();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

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
        Provider<SplashScreenBloc>.value(value: SplashScreenBloc()),
        Provider<LoginScreenBloc>.value(value: LoginScreenBloc()),
        Provider<DialogsScreenBloc>.value(value: DialogsScreenBloc()),
        Provider<AppInfoScreenBloc>.value(value: AppInfoScreenBloc()),
        Provider<SelectUsersScreenBloc>.value(value: SelectUsersScreenBloc()),
        Provider<ChatScreenBloc>.value(value: ChatScreenBloc()),
        Provider<DeliveredViewedScreenBloc>.value(value: DeliveredViewedScreenBloc()),
        Provider<EnterChatNameScreenBloc>.value(value: EnterChatNameScreenBloc()),
        Provider<ChatInfoScreenBloc>.value(value: ChatInfoScreenBloc())
        // ChangeNotifierProvider<AuthProvider>(
        //   create: (_) => AuthProvider(
        //     firebaseAuth: FirebaseAuth.instance,
        //     googleSignIn: GoogleSignIn(),
        //     prefs: this.prefs,
        //     firebaseFirestore: this.firebaseFirestore,
        //   ),
        // ),
        // // Provider<SettingProvider>(
        // //   create: (_) => SettingProvider(
        // //     prefs: this.prefs,
        // //     firebaseFirestore: this.firebaseFirestore,
        // //     firebaseStorage: this.firebaseStorage,
        // //   ),
        // // ),
        // Provider<HomeProvider>(
        //   create: (_) => HomeProvider(
        //     firebaseFirestore: this.firebaseFirestore,
        //   ),
        // ),
        // Provider<ChatProvider>(
        //   create: (_) => ChatProvider(
        //     prefs: prefs,
        //     firebaseFirestore: this.firebaseFirestore,
        //     firebaseStorage: this.firebaseStorage,
        //   ),
        // ),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key,}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _imageList = [];
  List<int> _selectedIndexList = [];
  List<String> _selectedList = [];
  bool _selectionMode = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttons = [];
    if (_selectionMode) {
      _buttons.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _selectedIndexList.sort();
            print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
          }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
        actions: _buttons,
      ),
      body: _createBody(),
    );
  }

  @override
  void initState() {
    super.initState();

    _imageList.add('https://picsum.photos/800/600/?image=280');
    _imageList.add('https://picsum.photos/800/600/?image=281');
    _imageList.add('https://picsum.photos/800/600/?image=282');
    _imageList.add('https://picsum.photos/800/600/?image=283');
    _imageList.add('https://picsum.photos/800/600/?image=284');
  }

  void _changeSelection({bool? enable, int? index}) {
    _selectionMode = enable!;
    _selectedIndexList.add(index!);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      primary: false,
      itemCount: _imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
          header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
            ),
          ),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 30.0)),
              child: Image.network(
                _imageList[index],
                fit: BoxFit.cover,
              ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                  _selectedList.remove(_imageList[index]);
                } else {
                  _selectedIndexList.add(index);
                  _selectedList.add(_imageList[index]);
                }
              });
              print(_selectedList[0]);
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: Image.network(
            _imageList[index],
            fit: BoxFit.cover,
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
        ),
      );
    }
  }
}