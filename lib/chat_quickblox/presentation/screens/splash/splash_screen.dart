import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../bloc/splash/splash_screen_bloc.dart';
import '../../../bloc/splash/splash_screen_events.dart';
import '../../../bloc/splash/splash_screen_states.dart';
import '../../../bloc/stream_builder_with_listener.dart';
import '../../navigation/navigation_service.dart';
import '../../navigation/router.dart';
import '../../utils/notification_utils.dart';
import '../base_screen_state.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseScreenState<SplashScreenBloc> {
  @override
  Widget build(BuildContext context) {
    initBloc(context);
    bloc?.events?.add(AuthEvent());

    return Scaffold(
      body:  Container(
        color: Color(0xff3978fc),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            StreamBuilderWithListener<SplashScreenStates>(
              listener: (state) {
                if (state is NeedLoginState) {
                  NavigationService().pushReplacementNamed(LoginScreenRoute);
                }
                if (state is LoginSuccessState) {
                  NavigationService().pushReplacementNamed(DialogsScreenRoute);
                }
                if (state is AuthenticationErrorState) {
                  NotificationBarUtils.showSnackBarError(context, state.error, errorCallback: () {
                    bloc?.events?.add(AuthEvent());
                  });
                }
              },
              stream: bloc?.states?.stream as Stream<SplashScreenStates>,
              builder: (context, state) {
                if (state.data is LoginInProgressState) {
                  return Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 150),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 4.0),
                      ));
                }
                return Text("");
              },
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text('Flutter Chat Sample',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ))
          ],
        ),
      ),
    );
  }
}
