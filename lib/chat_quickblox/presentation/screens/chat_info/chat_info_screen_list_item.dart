import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:quickblox_sdk/models/qb_user.dart';

import '../../utils/color_util.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class ChatInfoListItem extends StatefulWidget {
  final QBUser _user;
  final int _currentUserId;

  const ChatInfoListItem(Key key, this._currentUserId, this._user)
      : super(key: key);

  @override
  _ChatInfoListItemState createState() =>
      _ChatInfoListItemState(_currentUserId);
}

class _ChatInfoListItemState extends State<ChatInfoListItem> {
  final int _currentUserId;

  _ChatInfoListItemState(this._currentUserId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right:0),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: -4),
        leading: Container(
          width: 50,
          height: 50,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 0,right: 5),
          child: CircleAvatar(
            radius: 200,
            backgroundColor:
            Color(ColorUtil.getColor(widget._user.fullName)),
            child: Text(
              '${userName(this.widget._user).substring(0, 1).toUpperCase()}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        title:   Text(userName(this.widget._user).capitalize!,
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'POPM',
                color: isCurrentUser()
                    ? Colors.white60
                    : Colors.white),
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
// SizedBox(width: 9),
  // Expanded(
  //     child: Container(
  //   padding: EdgeInsets.only(top: 12),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: <Widget>[
  //       Text(userName(this.widget._user),
  //           style: TextStyle(
  //               fontSize: 16,
  //               fontFamily: 'PM',
  //               color: isCurrentUser()
  //                   ? Colors.white60
  //                   : Colors.white),
  //           overflow: TextOverflow.ellipsis),
  //     ],
  //   ),
  // )),
  bool isCurrentUser() {
    return this.widget._user.id == _currentUserId;
  }

  String userName(QBUser user) {
    String? name = user.fullName != null ? user.fullName : user.login;
    if (isCurrentUser()) {
      name = name! + " (You)";
    }
    return name!;
  }
}
