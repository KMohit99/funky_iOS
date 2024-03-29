import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:funky_new/Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/chat/constants.dart';

import '../../../bloc/base_bloc.dart';
import '../../../bloc/chat/chat_screen_bloc.dart';
import '../../../bloc/chat/chat_screen_events.dart';
import '../../../models/message_wrapper.dart';
import '../../utils/color_util.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class ChatListItem extends StatefulWidget {
  final QBMessageWrapper _message;
  final int? _dialogType;

  const ChatListItem(Key key, this._message, this._dialogType)
      : super(key: key);

  @override
  _ChatListItemState createState() => _ChatListItemState(_message, _dialogType);
}

class _ChatListItemState extends State<ChatListItem> {
  QBMessageWrapper _message;
  int? _dialogType;
  Bloc? _bloc;

  _ChatListItemState(this._message, this._dialogType);

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<ChatScreenBloc>(context, listen: false);

    if (_message.qbMessage.readIds != null &&
        !_message.qbMessage.readIds!.contains(_message.currentUserId)) {
      _message.qbMessage.readIds!.add(_message.currentUserId);
      _bloc?.events?.add(MarkMessageRead(_message.qbMessage));
    }
    var messageProperties = _message.qbMessage.properties;
    bool isNotification = (messageProperties != null &&
        messageProperties.containsKey("notification_type"));

    if (isNotification) {
      if (_message.qbMessage.body == null) {
        _message.qbMessage.body = "empty message";
      }
      return Container(
        padding: EdgeInsets.all(14),
        alignment: Alignment.center,
        child: Text(_message.qbMessage.body!,
            maxLines: null,
            style: TextStyle(fontSize: 13, color: Color(0xff6c7a92),fontFamily: 'POPR'),
            overflow: TextOverflow.clip),
        constraints: BoxConstraints(maxWidth: 250),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 10, right: 12, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              child:
                  _message.isIncoming && _dialogType != QBChatDialogTypes.CHAT
                      ? _generateAvatarFromName(_message.senderName)
                      : null),
          Padding(padding: EdgeInsets.only(left: _dialogType == 3 ? 0 : 16)),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: _message.isIncoming
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: <Widget>[
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      _buildMessageBody(),
                      SizedBox(height: 5,),
                      Container(
                        // color: Colors.white60,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:_message.isIncoming? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: _buildNameTimeHeader(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  List<Widget> _buildNameTimeHeader() {
    return <Widget>[
      // _buildSenderName(),

      Padding(padding: EdgeInsets.only(left: 3)),
      _buildDateSent(),
      Padding(padding: EdgeInsets.only(left: 7)),
      _message.isIncoming ? SizedBox.shrink() : _buildMessageStatus(),
    ];
  }

  Widget _buildMessageStatus() {
    var deliveredIds = _message.qbMessage.deliveredIds;
    var readIds = _message.qbMessage.readIds;
    if (_dialogType == QBChatDialogTypes.PUBLIC_CHAT) {
      return SizedBox.shrink();
    }
    if (readIds != null && readIds.length > 1) {
      return SvgPicture.asset('assets/icons/read.svg',color: HexColor(CommonColor.pinkFont),);
    } else if (deliveredIds != null && deliveredIds.length > 1) {
      return SvgPicture.asset('assets/icons/delivered.svg');
    } else {
      return SvgPicture.asset('assets/icons/sent.svg');
    }
  }

  Widget _buildSenderName() {
    return Text(_message.senderName ?? "Noname",
        maxLines: 1,
        style: TextStyle(
            fontSize: 12, fontFamily: 'PB', color: Colors.white60));
  }

  Widget _buildDateSent() {
    return Text(_buildTime(_message.qbMessage.dateSent!),
        maxLines: 1, style: TextStyle(fontSize: 13, color: Colors.white54));
  }

  Widget _buildMessageBody() {
    return Container(
      constraints: BoxConstraints(maxWidth: 234),
      decoration: BoxDecoration(
          color:
              _message.isIncoming ? HexColor('#641637') : HexColor('#E8E7E7'),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
              bottomRight: _message.isIncoming
                  ? Radius.circular(22)
                  : Radius.circular(0),
              bottomLeft: _message.isIncoming
                  ? Radius.circular(0)
                  : Radius.circular(22)),
          // boxShadow: [
          //   BoxShadow(
          //       color: _message.isIncoming
          //           ? Colors.blue.withOpacity(0.15)
          //           : Colors.blue.withOpacity(0.35),
          //       spreadRadius: _message.isIncoming ? 0 : 3,
          //       blurRadius: _message.isIncoming ? 48 : 27,
          //       offset: _message.isIncoming ? Offset(0, 3) : Offset(5, 12))
          // ]
    ),
      padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child:
              _message.isIncoming && _dialogType != QBChatDialogTypes.CHAT
                  ? Text(_message.senderName!,
                  maxLines: null,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                      fontFamily: 'POPM'),
                  overflow: TextOverflow.clip)
                  : null),
          SizedBox(height: 3,),
          Text(_message.qbMessage.body ?? "[Attachment]",
              maxLines: null,
              style: TextStyle(
                  fontSize: 14,
                  color: _message.isIncoming ? Colors.white : Colors.black,
                  fontFamily: _message.isIncoming ? 'POPR' : 'POPM'),
              overflow: TextOverflow.clip),
        ],
      ),
    );
  }

  Widget _generateAvatarFromName(String? name) {
    if (name == null) {
      name = "Noname";
    }
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
          color: Color(ColorUtil.getColor(name)),
          borderRadius: new BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _buildTime(int timeStamp) {
    String completedTime = "";
    DateFormat timeFormat = DateFormat("HH:mm");
    DateTime messageTime =
        new DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    completedTime = timeFormat.format(messageTime);

    return completedTime;
  }
}
