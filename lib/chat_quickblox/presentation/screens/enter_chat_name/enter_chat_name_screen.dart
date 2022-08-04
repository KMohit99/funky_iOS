
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/chat/constants.dart';

import '../../../bloc/enter_chat_name/enter_chat_name_screen_bloc.dart';
import '../../../bloc/enter_chat_name/enter_chat_name_screen_events.dart';
import '../../../bloc/enter_chat_name/enter_chat_name_screen_states.dart';
import '../../../bloc/stream_builder_with_listener.dart';
import '../../utils/notification_utils.dart';
import '../../widgets/decorated_app_bar.dart';
import '../../widgets/progress.dart';
import '../base_screen_state.dart';
import '../chat/chat_screen.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class EnterChatNameScreen extends StatefulWidget {
  final int dialogType;
  final List<int> selectedUsersIds;

  EnterChatNameScreen(this.dialogType, this.selectedUsersIds);

  @override
  _EnterChatNameScreenState createState() =>
      _EnterChatNameScreenState(dialogType, selectedUsersIds);
}

class _EnterChatNameScreenState extends BaseScreenState<EnterChatNameScreenBloc> {
  int _dialogType;
  List<int> _selectedUsersIds;
  bool _allowFinish = false;

  _EnterChatNameScreenState(this._dialogType, this._selectedUsersIds);

  @override
  Widget build(BuildContext context) {
    initBloc(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: DecoratedAppBar(appBar: buildAppBar()),
        body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView(children: [
              Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Text('Group Name',
                      style: TextStyle(
                          fontFamily: 'PR',
                          fontSize: 16,
                          color: Colors.white60))),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                      spreadRadius: -5,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  // controller: ,
                  onChanged: (chatName) {
                    bloc?.events?.add(ChangedChatNameEvent(chatName));
                  },
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PM',
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, top: 14, bottom: 14),
                    filled: true,
                    // fillColor: Colors.white,
                    hintText: 'Enter group name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: InputBorder.none,

                    // focusedBorder: OutlineInputBorder(
                    //   borderSide:
                    //   BorderSide(color: ColorUtils.blueColor, width: 1),
                    //   borderRadius: BorderRadius.all(Radius.circular(10)),
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'PR',
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              StreamBuilderWithListener<EnterChatNameScreenStates>(
                  stream: bloc?.states?.stream as Stream<EnterChatNameScreenStates>,
                  listener: (state) {
                    if (state is ChangedChatNameState) {
                      _allowFinish = state.allowFinish;
                    }
                    if (state is CreationFinishedState) {
                      _navigateToChatScreen(state.dialogId);
                    }
                    if (state is ErrorState) {
                      NotificationBarUtils.showSnackBarError(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    if (!_allowFinish) {
                      return Container(
                          padding: EdgeInsets.only(top: 11),
                          child: Text("Must be in a range from 3 to 20 characters.",
                              style: new TextStyle(color: Color.fromRGBO(153, 169, 198, 1.0))));
                    }

                    return SizedBox.shrink();
                  }),
              _buildProgress(),
            ])));
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xff000000),
      title: Text("Create Group",style: TextStyle(
          fontFamily: 'PM',
          fontSize: 18,
          color: Colors.white)),
      leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        StreamProvider<EnterChatNameScreenStates>(
            create: (context) => bloc?.states?.stream as Stream<EnterChatNameScreenStates>,
            initialData: ChangedChatNameState(false),
            child: Selector<EnterChatNameScreenStates, EnterChatNameScreenStates>(
              selector: (_, state) => state,
              shouldRebuild: (previous, next) {
                return next is ChangedChatNameState ||
                    next is CreatingDialogState ||
                    next is ErrorState;
              },
              builder: (_, state, __) {
                if (state is ChangedChatNameState && state.allowFinish || state is ErrorState) {
                  return TextButton(
                    onPressed: () {
                      if (_dialogType == QBChatDialogTypes.GROUP_CHAT &&
                          state is! CreatingDialogState) {
                        bloc?.events?.add(CreateGroupChatEvent(_selectedUsersIds));
                      }
                    },
                    child: Text(
                      'Finish',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  );
                }
                return Text("");
              },
            ))
      ],
    );
  }

  Widget _buildProgress() {
    return StreamProvider<EnterChatNameScreenStates>(
        create: (context) => bloc?.states?.stream as Stream<EnterChatNameScreenStates>,
        initialData: ChangedChatNameState(false),
        child: Selector<EnterChatNameScreenStates, EnterChatNameScreenStates>(
            selector: (_, state) => state,
            shouldRebuild: (previous, next) {
              return next is ChangedChatNameState ||
                  next is CreatingDialogState ||
                  next is ErrorState;
            },
            builder: (_, state, __) {
              if (state is CreatingDialogState) {
                return Progress(Alignment.center);
              } else {
                return SizedBox.shrink();
              }
            }));
  }

  void _navigateToChatScreen(String dialogId) {
    Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(dialogId, true)),
        (route) => false);
  }
}
