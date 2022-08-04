import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:get/utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

import '../../../bloc/chat_info/chat_info_screen_bloc.dart';
import '../../../bloc/chat_info/chat_info_screen_events.dart';
import '../../../bloc/chat_info/chat_info_screen_states.dart';
import '../../../bloc/stream_builder_with_listener.dart';
import '../../utils/notification_utils.dart';
import '../../utils/random_util.dart';
import '../../widgets/decorated_app_bar.dart';
import '../../widgets/progress.dart';
import '../base_screen_state.dart';
import '../select_users/select_users_screen.dart';
import 'chat_info_screen_list_item.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class ChatInfoScreen extends StatefulWidget {
  static const int NO_USERS_SELECTED = -1;
  final String _dialogId;

  ChatInfoScreen(this._dialogId);

  @override
  _ChatInfoScreenState createState() => _ChatInfoScreenState(_dialogId);
}

class _ChatInfoScreenState extends BaseScreenState<ChatInfoScreenBloc> {
  String _dialogId;
  int? _currentUserId;

  _ChatInfoScreenState(this._dialogId);

  @override
  Widget build(BuildContext context) {
    initBloc(context);
    bloc?.setArgs(_dialogId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: DecoratedAppBar(appBar: _buildAppBar()),
      body: StreamProvider<ChatInfoScreenStates>(
        create: (context) =>
            bloc?.states?.stream as Stream<ChatInfoScreenStates>,
        initialData: ChatConnectingState(),
        child: Selector<ChatInfoScreenStates, ChatInfoScreenStates>(
          selector: (_, state) => state,
          shouldRebuild: (previous, next) {
            return next is ChatConnectingState ||
                next is UpdateChatErrorState ||
                next is SavedUserErrorState ||
                next is LoadUsersSuccessState;
          },
          builder: (_, state, __) {
            return Stack(
                children: [_buildUsersList(state), _buildProgress(state)]);
          },
        ),
      ),
    );
  }

  Widget _buildProgress(ChatInfoScreenStates state) {
    if (state is ChatConnectingState) {
      return Progress(Alignment.center);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildUsersList(ChatInfoScreenStates state) {
    if (state is LoadUsersSuccessState && state.users.isNotEmpty) {
      List<QBUser?> users = state.users;

      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: ChatInfoListItem(Key(RandomUtil.getRandomString(10)),
                  _currentUserId!, users[index]!));
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  AppBar _buildAppBar() {
    String dialogName = "Unknown Chat";
    int? participantsCount = 0;
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xff000000),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            NotificationBarUtils.hideSnackBar(context);
            Navigator.pop(context, [ChatInfoScreen.NO_USERS_SELECTED]);
          }),
      actions: <Widget>[
        Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
                icon: Icon(Icons.add_circle,color: HexColor(CommonColor.pinkFont),),
                onPressed: () async {
                  NotificationBarUtils.hideSnackBar(context);
                  var resultList = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectUsersScreen(_dialogId),
                      ));
                  Navigator.pop(context,
                      resultList ?? [ChatInfoScreen.NO_USERS_SELECTED]);
                }))
      ],
      title: StreamBuilderWithListener<ChatInfoScreenStates>(
          stream: bloc?.states?.stream as Stream<ChatInfoScreenStates>,
          listener: (state) {
            if (state is ChatConnectedState) {
              _currentUserId = state.userId;
              bloc?.events?.add(UpdateChatEvent());
            }
            if (state is UpdateChatSuccessState) {
              dialogName = state.dialog.name!;
              participantsCount =
                  state.dialog.occupantsIds?.length ?? participantsCount;
            }
            if (state is IncomingSystemMessageState) {
              bloc?.events?.add(UpdateChatEvent());
            }
            if (state is UpdateChatErrorState) {
              NotificationBarUtils.showSnackBarError(context, state.error,
                  errorCallback: () {
                bloc?.events?.add(UpdateChatEvent());
              });
            }
            if (state is ChatConnectingErrorState) {
              NotificationBarUtils.showSnackBarError(context, state.error,
                  errorCallback: () {
                bloc?.events?.add(UpdateChatEvent());
              });
            }
          },
          builder: (context, state) {
            if (state.data is UpdateChatInProgressState) {
              return Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                alignment: Alignment.center,
                child: SizedBox(
                    height: 15,
                    width: 15,
                    child: Progress(Alignment.center, color: Colors.white)),
              );
            }

            if (state.data is UpdateChatSuccessState ||
                state.data is LoadUsersSuccessState) {
              return Column(
                children: <Widget>[
                  Text(
                    dialogName.capitalize!,
                    style: TextStyle(
                        fontFamily: "PM", fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  _buildMembersCountSubtitle(participantsCount!)
                ],
              );
            }

            return SizedBox.shrink();
          }),
    );
  }

  Widget _buildMembersCountSubtitle(int number) {
    String subtitle = number.toString() + " member" + (number != 1 ? "s" : "");
    return Text(
      '$subtitle',
      style: TextStyle(fontFamily: "PM", fontSize: 13, color: Colors.white60),
    );
  }
}
