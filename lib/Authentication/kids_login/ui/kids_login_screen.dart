import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:funky_project/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../Utils/App_utils.dart';
import '../../../Utils/asset_utils.dart';
import '../../../Utils/custom_textfeild.dart';
import '../../../chat_quickblox/bloc/login/login_screen_bloc.dart';
import '../../../chat_quickblox/bloc/login/login_screen_events.dart';
import '../../../chat_quickblox/bloc/login/login_screen_states.dart';
import '../../../chat_quickblox/bloc/stream_builder_with_listener.dart';
import '../../../chat_quickblox/presentation/screens/base_screen_state.dart';
import '../../../chat_quickblox/presentation/screens/login/password_text_field.dart';
import '../../../chat_quickblox/presentation/screens/login/user_name_text_field.dart';
import '../../../chat_quickblox/presentation/utils/notification_utils.dart';
import '../../../controller/controllers_class.dart';
import '../../../controller/controllers_class.dart';
import '../../../custom_widget/common_buttons.dart';
import '../../../dashboard/dashboard_screen.dart';
import '../../../getx_pagination/binding_utils.dart';

import '../../creator_login/controller/creator_login_controller.dart';
import '../../instagram/instagram_view.dart';
import '../controller/kids_login_controller.dart';
import 'kids_email_verification.dart';

class KidsLoginScreen extends StatefulWidget {
  const KidsLoginScreen({Key? key}) : super(key: key);

  @override
  _KidsLoginScreenState createState() => _KidsLoginScreenState();
}

class _KidsLoginScreenState extends BaseScreenState<LoginScreenBloc> {
  // final Kids_Login_screen_controller _kids_loginScreenController =
  // Get.put(Kids_Login_screen_controller(), tag: Kids_Login_screen_controller().toString());

  final _kids_loginScreenController = new Kids_Login_screen_controller();

  final Creator_Login_screen_controller _creator_login_screen_controller =
      Get.put(Creator_Login_screen_controller(),
          tag: Creator_Login_screen_controller().toString());
  bool _obscureText = true;

  String? _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  LoginScreenBloc? loginBloc;

  passwordTextField? _loginTextField;
  UserNameTextField? _userNameTextField;

  @override
  Widget build(BuildContext context) {
    initBloc(context);

    _loginTextField = passwordTextField(
        txtController: _kids_loginScreenController.passwordController,
        loginBloc: bloc as LoginScreenBloc);
    _userNameTextField = UserNameTextField(
        txtController: _kids_loginScreenController.usernameController,
        loginBloc: bloc as LoginScreenBloc);


    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            // decoration: BoxDecoration(
            //
            //   image: DecorationImage(
            //     image: AssetImage(AssetUtils.backgroundImage), // <-- BACKGROUND IMAGE
            //     fit: BoxFit.cover,
            //   ),
            // ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  HexColor("#000000"),
                  HexColor("#000000").withOpacity(0.97),
                  HexColor("#C12265").withOpacity(0.5),
                  HexColor("#C12265").withOpacity(0.5),
                  HexColor("#C12265").withOpacity(0.8),
                  HexColor("#FFFFFF").withOpacity(0.97),
                ],
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.25), BlendMode.dstATop),
                image: const AssetImage(
                  AssetUtils.backgroundImage3,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              body: Container(
                width: screenwidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 86),
                        child: Image.asset(
                          AssetUtils.logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Text(
                          'LogIn ${TxtUtils.Login_type_kids}',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PB',
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 41,
                      ),
                      // CommonTextFormField(
                      //   controller:
                      //       _kids_loginScreenController.usernameController,
                      //   title: 'Username',
                      //   labelText: 'Username',
                      //   image_path: AssetUtils.msg_icon,
                      // ),
                      Container(
                        child: this._userNameTextField,
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      // CommonTextFormField(
                      //     controller:
                      //         _kids_loginScreenController.passwordController,
                      //     title: 'Password',
                      //     labelText: 'Password',
                      //     isObscure: _obscureText,
                      //     maxLines: 1,
                      //     image_path: (_obscureText
                      //         ? AssetUtils.eye_open_icon
                      //         : AssetUtils.eye_close_icon),
                      //     onpasswordTap: () {
                      //       _toggle();
                      //     }),
                      Container(
                        child: this._loginTextField,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      // common_button(
                      //   onTap: () {
                      //     _kids_loginScreenController.checkLogin(
                      //         context: context,
                      //         login_type: TxtUtils.Login_type_kids);
                      //   },
                      //   backgroud_color: Colors.black,
                      //   lable_text: 'Login',
                      //   lable_text_color: Colors.white,
                      // ),
                      Container(
                          child: StreamBuilderWithListener<LoginScreenStates>(
                            stream:
                            bloc?.states?.stream as Stream<LoginScreenStates>,
                            listener: (state) {
                              if (state is LoginSuccessState) {
                                print("Login succesfullllllll");

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            kids_Email_verification()));
                                // NavigationService()
                                //     .pushReplacementNamed(DialogsScreenRoute);
                              }
                              if (state is LoginErrorState) {
                                print("Login failed");

                                NotificationBarUtils.showSnackBarError(
                                    this.context, state.error);
                              }
                            },
                            builder: (context, state) {
                              if (state.data is LoginInProgressState) {
                                return CircularProgressIndicator();
                              }
                              return GestureDetector(
                                  onTap: () async {
                                    _kids_loginScreenController.checkLogin(
                                        context: context,
                                        login_type: TxtUtils.Login_type_kids);
                                    await checkLogin();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    // height: 45,
                                    // width:(width ?? 300) ,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(25)),
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ),
                                  ));
                            },
                          )),

                      SizedBox(
                        height: 22,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(BindingUtils.passwordreset);
                        },
                        child: Container(
                          child: Text('Forgot Password ?',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PB',
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(
                                      vertical: -4, horizontal: -4),
                                  icon: Image.asset(
                                    AssetUtils.facebook_icon,
                                    height: 32,
                                    width: 32,
                                  ),
                                  onPressed: () {
                                    _creator_login_screen_controller.signInWithFacebook(
                                        login_type: 'creator', context: context);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.grey,
                                height: 18,
                                width: 1,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(
                                      vertical: -4, horizontal: -4),
                                  icon: Image.asset(
                                    AssetUtils.instagram_icon,
                                    height: 32,
                                    width: 32,
                                  ),
                                  onPressed: () {
                                    Get.to(InstagramView(context: context,login_type: 'Kids',));
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.grey,
                                height: 18,
                                width: 1,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(
                                      vertical: -4, horizontal: -4),
                                  icon: Image.asset(
                                    AssetUtils.email_icon,
                                    height: 32,
                                    width: 32,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await _creator_login_screen_controller
                                          .signInwithGoogle(
                                              context: context,
                                              login_type: 'Kids');
                                      // Get.to(Dashboard());
                                    } catch (e) {
                                      if (e is FirebaseAuthException) {
                                        Fluttertoast.showToast(
                                          msg: "login usuccessfull",
                                          textColor: Colors.white,
                                          backgroundColor: Colors.black,
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                color: Colors.grey,
                                height: 18,
                                width: 1,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(
                                      vertical: -4, horizontal: -4),
                                  icon: Image.asset(
                                    AssetUtils.twitter_icon,
                                    height: 32,
                                    width: 32,
                                  ),
                                  onPressed: () {
                                    _creator_login_screen_controller
                                        .signInWithTwitter(
                                            context: context,
                                            login_type: 'kids');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(BindingUtils.ageVerification);
                        },
                        child: Container(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16, fontFamily: 'PB'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Future checkLogin() async {
    print("Inside event");
    bloc?.events?.add(LoginPressedEvent());
  }
}
