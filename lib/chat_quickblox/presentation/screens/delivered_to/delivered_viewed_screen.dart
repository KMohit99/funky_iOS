import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

import '../../../bloc/chat_info/chat_info_screen_bloc.dart';
import '../../../bloc/chat_info/chat_info_screen_events.dart';
import '../../../bloc/chat_info/chat_info_screen_states.dart';
import '../../../bloc/delivered_to/delivered_viewed_screen_bloc.dart';
import '../../../bloc/delivered_to/delivered_viewed_screen_events.dart';
import '../../../bloc/delivered_to/delivered_viewed_screen_states.dart';
import '../../../bloc/stream_builder_with_listener.dart';
import '../../utils/notification_utils.dart';
import '../../utils/random_util.dart';
import '../../widgets/decorated_app_bar.dart';
import '../../widgets/progress.dart';
import '../base_screen_state.dart';
import '../chat_info/chat_info_screen_list_item.dart';
import '../select_users/select_users_screen.dart';
/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class DeliveredViewedScreen extends StatefulWidget {
  final String _dialogId;
  final String _messageId;
  final bool _isDeliveredScreen;

  DeliveredViewedScreen(this._dialogId, this._messageId, this._isDeliveredScreen);

  @override
  _DeliveredViewedScreenState createState() =>
      _DeliveredViewedScreenState(_dialogId, _messageId, _isDeliveredScreen);
}

class _DeliveredViewedScreenState extends BaseScreenState<DeliveredViewedScreenBloc> {
  String _dialogId;
  String _messageId;
  bool _isDeliveredScreen;

  _DeliveredViewedScreenState(this._dialogId, this._messageId, this._isDeliveredScreen);

  @override
  Widget build(BuildContext context) {
    initBloc(context);
    bloc?.setArgs(DeliveredViewedScreenArguments(_dialogId, _messageId, _isDeliveredScreen));
    bloc?.events?.add(MessageDetailsEvent());

    return Scaffold(
      appBar: DecoratedAppBar(appBar: _buildAppBar()),
      body: StreamProvider<DeliveredViewedScreenStates>(
        create: (context) => bloc?.states?.stream as Stream<DeliveredViewedScreenStates>,
        initialData: MessageDetailInProgressState(),
        child: Selector<DeliveredViewedScreenStates, DeliveredViewedScreenStates>(
          selector: (_, state) => state,
          shouldRebuild: (previous, next) {
            return next is MessageDetailInProgressState || next is MessageDetailState;
          },
          builder: (_, state, __) {
            return Stack(
                children: [_buildUsersList(state), _buildProgress(state), _buildError(state)]);
          },
        ),
      ),
    );
  }

  Widget _buildProgress(DeliveredViewedScreenStates state) {
    if (state is MessageDetailInProgressState) {
      return Progress(Alignment.center);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildError(DeliveredViewedScreenStates state) {
    if (state is ErrorState) {
      NotificationBarUtils.showSnackBarError(context, state.error);
    }
    return SizedBox.shrink();
  }

  Widget _buildUsersList(DeliveredViewedScreenStates state) {
    if (state is MessageDetailState) {
      List<QBUser> users = [];
      state.users.where((element) => element != null).forEach((element) {
        users.add(element!);
      });

      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: ChatInfoListItem(
                  Key(RandomUtil.getRandomString(10)), state.currentUserId, users[index]));
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  AppBar _buildAppBar() {
    String title = "Message" + (_isDeliveredScreen ? " delivered to" : " viewed by");
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xff3978fc),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            NotificationBarUtils.hideSnackBar(context);
            bloc?.events?.add(MessageDetailCloseEvent());
            Navigator.pop(context);
          }),
      actions: <Widget>[Text("")],
      title: Column(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 17)),
          _buildMembersCountSubtitle()
        ],
      ),
    );
  }

  Widget _buildMembersCountSubtitle() {
    return StreamProvider<DeliveredViewedScreenStates>(
      create: (context) => bloc?.states?.stream as Stream<DeliveredViewedScreenStates>,
      initialData: MessageDetailInProgressState(),
      child: Selector<DeliveredViewedScreenStates, DeliveredViewedScreenStates>(
        selector: (_, state) => state,
        shouldRebuild: (previous, next) {
          return next is MessageDetailState;
        },
        builder: (_, state, __) {
          String subtitle = "";
          if (state is MessageDetailState) {
            int number = state.users.length;
            subtitle = number.toString() + " member" + (number != 1 ? "s" : "");
          }
          return Text('$subtitle',
              style: TextStyle(fontSize: 13, color: Colors.white60, fontWeight: FontWeight.normal));
        },
      ),
    );
  }
}
