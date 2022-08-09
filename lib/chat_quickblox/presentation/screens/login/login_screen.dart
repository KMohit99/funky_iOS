import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:funky_new/chat_quickblox/presentation/screens/login/user_name_text_field.dart';
import 'package:provider/provider.dart';

import '../../../bloc/login/login_screen_bloc.dart';
import '../../../bloc/login/login_screen_events.dart';
import '../../../bloc/login/login_screen_states.dart';
import '../../../bloc/stream_builder_with_listener.dart';
import '../../navigation/navigation_service.dart';
import '../../navigation/router.dart';
import '../../utils/notification_utils.dart';
import '../../widgets/decorated_app_bar.dart';
import '../../widgets/progress.dart';
import '../base_screen_state.dart';
import '../dialogs/dialogs_screen.dart';
import 'password_text_field.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreenBloc> {
  passwordTextField? _loginTextField;
  UserNameTextField? _userNameTextField;
  TextEditingController? newe_Email;
  TextEditingController? newe_Username;
  @override
  Widget build(BuildContext context) {
    initBloc(context);

    _loginTextField = passwordTextField(txtController : newe_Email! ,loginBloc: bloc as LoginScreenBloc);
    _userNameTextField = UserNameTextField(txtController: newe_Username!,loginBloc: bloc as LoginScreenBloc);

    return Scaffold(
      appBar: DecoratedAppBar(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Enter to chat'),
          backgroundColor: Color(0xff3978fc),
          leading: Container(),
          actions: <Widget>[
            IconButton(
                icon: SvgPicture.asset('assets/icons/info.svg'),
                onPressed: () {
                  NavigationService().pushNamed(AppInfoScreenRoute);
                })
          ],
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 16, right: 16),
          children: [
            Container(
              padding: EdgeInsets.only(top: 28),
              child: Text(
                'Please enter your login \n and display name',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 28),
                child: Text('Login',
                    style: TextStyle(color: Color(0x85333333), fontSize: 13))),
            Container(
              padding: EdgeInsets.only(top: 11),
              child: this._loginTextField,
            ),
            StreamProvider<LoginScreenStates>(
                create: (context) =>
                    bloc?.states?.stream as Stream<LoginScreenStates>,
                initialData: LoginFieldValidState(),
                child: Selector<LoginScreenStates, LoginScreenStates>(
                  selector: (_, state) => state,
                  shouldRebuild: (previous, next) {
                    return next is LoginFieldInvalidState ||
                        next is LoginFieldValidState ||
                        next is AllowLoginState;
                  },
                  builder: (_, state, __) {
                    if (state is LoginFieldInvalidState) {
                      return Container(
                          padding: EdgeInsets.only(top: 11),
                          child: Text(
                              "Use your email or alphanumeric characters in a range from 3 to 50. First character must be a letter.",
                              style: new TextStyle(
                                  color: Color.fromRGBO(153, 169, 198, 1.0))));
                    }
                    return Text("");
                  },
                )),
            Container(
                padding: EdgeInsets.only(top: 16),
                child: Text('Username',
                    style:
                        new TextStyle(color: Color(0x85333333), fontSize: 13))),
            Container(
              padding: EdgeInsets.only(top: 11),
              child: this._userNameTextField,
            ),
            StreamProvider<LoginScreenStates>(
                create: (context) =>
                    bloc?.states?.stream as Stream<LoginScreenStates>,
                initialData: UserNameFieldValidState(),
                child: Selector<LoginScreenStates, LoginScreenStates>(
                    selector: (_, state) => state,
                    shouldRebuild: (previous, next) {
                      return next is UserNameFieldInvalidState ||
                          next is UserNameFieldValidState ||
                          next is AllowLoginState;
                    },
                    builder: (_, state, __) {
                      if (state is UserNameFieldInvalidState) {
                        return Container(
                            padding: EdgeInsets.only(top: 11),
                            child: Text(
                                "Use alphanumeric characters and spaces in a range from 3 to 20. Cannot contain more than one space in a row.",
                                style: new TextStyle(
                                    color:
                                        Color.fromRGBO(153, 169, 198, 1.0))));
                      }
                      return Text("");
                    })),
            Container(
                padding: EdgeInsets.only(top: 42, left: 64, right: 64),
                child: StreamBuilderWithListener<LoginScreenStates>(
                  stream: bloc?.states?.stream as Stream<LoginScreenStates>,
                  listener: (state) {
                    if (state is LoginSuccessState) {
                      print("Login succesful");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DialogsScreen()));
                      // NavigationService()
                      //     .pushReplacementNamed(DialogsScreenRoute);
                    }
                    if (state is LoginErrorState) {
                      print("Login succesfulllllll");

                      NotificationBarUtils.showSnackBarError(
                          this.context, state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state.data is LoginInProgressState) {
                      return Progress(Alignment.center);
                    }
                    return TextButton(
                        onPressed: state.data is AllowLoginState ||
                                state.data is LoginErrorState
                            ? () {
                                bloc?.events?.add(LoginPressedEvent());
                                FocusScope.of(context).unfocus();
                              }
                            : null,
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.resolveWith(
                                (states) => states.contains(MaterialState.disabled)
                                    ? null
                                    : 3),
                            shadowColor: MaterialStateProperty.resolveWith(
                                (states) => states.contains(MaterialState.disabled)
                                    ? Color(0xff99A9C6)
                                    : Color(0x403978FC)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => states.contains(MaterialState.disabled)
                                    ? Color(0xff99A9C6)
                                    : Color(0xff3978FC))),
                        child: Container(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ));
                  },
                ))
          ],
        ),
      ),
    );
  }
}
