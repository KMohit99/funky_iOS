import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:funky_new/chat_quickblox/presentation/screens/select_users/select_users_screen_item.dart';
import 'package:funky_new/chat_quickblox/presentation/screens/select_users/select_users_screen_loading_item.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/chat/constants.dart';

import '../../../bloc/select_users/select_users_screen_bloc.dart';
import '../../../bloc/select_users/select_users_screen_events.dart';
import '../../../bloc/select_users/select_users_screen_states.dart';
import '../../../bloc/stream_builder_with_listener.dart';
import '../../../models/user_wrapper.dart';
import '../../utils/notification_utils.dart';
import '../../widgets/decorated_app_bar.dart';
import '../../widgets/progress.dart';
import '../base_screen_state.dart';
import '../chat/chat_screen.dart';
import '../enter_chat_name/enter_chat_name_screen.dart';

/// Created by Injoit in 2021.
/// Copyright © 2021 Quickblox. All rights reserved.

class SelectUsersScreen extends StatefulWidget {
  final String _dialogId;

  SelectUsersScreen(this._dialogId);

  @override
  _SelectUsersScreenState createState() => _SelectUsersScreenState(_dialogId);
}

class _SelectUsersScreenState extends BaseScreenState<SelectUsersScreenBloc> {
  ScrollController? _scrollController;
  String _dialogId;

  _SelectUsersScreenState(this._dialogId);

  final _searchDelay = SearchTimer(milliseconds: 1000);
  bool _search = false;

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initBloc(context);
    if (_dialogId.isNotEmpty) {
      bloc?.setArgs(_dialogId);
    }

    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);

    return Stack(
      children: [
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
                HexColor("#330417"),
                HexColor("#000000"),
                HexColor("#000000"),
                HexColor("#000000"),
              ],
            ),
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: DecoratedAppBar(appBar: buildAppBar()),
            body: Stack(children: [
              StreamBuilderWithListener<SelectUsersScreenStates>(
                stream: bloc?.states?.stream as Stream<SelectUsersScreenStates>,
                listener: (state) {
                  if (state is ErrorState) {
                    NotificationBarUtils.showSnackBarError(
                        context, state.error);
                  }
                  if (state is CreateDialogErrorState) {
                    NotificationBarUtils.showSnackBarError(
                        context, state.error);
                  }
                  if (state is CreatedDialogState) {
                    _navigateToChatScreen(state.dialogId);
                  }
                },
                builder: (context, state) {
                  return SizedBox.shrink();
                },
              ),
              Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(color: Colors.white60, width: 1)),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 12, right: 10),
                            child: SizedBox(
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  color: Colors.pink,
                                ),
                                height: 28,
                                width: 28)),
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          minLines: 1,
                          maxLength: 25,
                          onChanged: (text) {
                            if (text.length >= 3) {
                              _search = true;
                              _searchDelay.run(() =>
                                  bloc?.events?.add(SearchUsersEvent(text)));
                            }

                            if (text.length == 0) {
                              _search = false;
                              bloc?.events?.add(LoadUsersEvent());
                            }
                          },
                          style:
                              TextStyle(fontSize: 15, fontFamily: 'PM',color: Color(0xFFFFFFFF)),
                          decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Color(0xFF6C7A92)),
                              counterText: ""),
                        ))
                      ]),
                ),
                Expanded(
                    child: RawScrollbar(
                  isAlwaysShown: false,
                  thickness: 3,
                  radius: Radius.circular(3),
                  thumbColor: Colors.blue,
                  controller: _scrollController,
                  child: StreamProvider<SelectUsersScreenStates>(
                    initialData: LoadUsersInProgressState(),
                    create: (context) =>
                        bloc?.states?.stream as Stream<SelectUsersScreenStates>,
                    child: Selector<SelectUsersScreenStates,
                        SelectUsersScreenStates>(
                      selector: (_, state) => state,
                      shouldRebuild: (previous, next) {
                        return next is LoadUsersSuccessState ||
                            next is LoadUsersInProgressState;
                      },
                      builder: (_, state, __) {
                        if (state is LoadUsersSuccessState) {
                          List<QBUserWrapper> users = state.users;

                          if (users.isEmpty) {
                            return Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("No user with that name",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF6C7A92))));
                          }
                          return ListView.builder(
                            addAutomaticKeepAlives: true,
                            itemCount: users.length,
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              if (users.length > 1 &&
                                  index == users.length - 1) {
                                return SelectUsersScreenLoadingItem();
                              } else {
                                return SelectUsersScreenItem(users[index]);
                              }
                            },
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                )),
              ]),
              _buildProgress()
            ])),
      ],
    );
  }

  AppBar buildAppBar() {
    const int ONE_USER = 1;
    return AppBar(
      centerTitle: false,
      // backgroundColor: Color(0xff3978fc),
      backgroundColor: Colors.transparent,
      title: StreamProvider<SelectUsersScreenStates>(
          create: (context) =>
              bloc?.states?.stream as Stream<SelectUsersScreenStates>,
          initialData: ChangedSelectedUsersState([]),
          child: Selector<SelectUsersScreenStates, SelectUsersScreenStates>(
              selector: (_, state) => state,
              shouldRebuild: (previous, next) {
                return next is ChangedSelectedUsersState;
              },
              builder: (_, state, __) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _dialogId.isNotEmpty ? 'Add Users' : 'Select User',
                        style: TextStyle(fontFamily: 'PM', fontSize: 16),
                      ),
                      _buildSubtitle(state as ChangedSelectedUsersState)
                    ]);
              })),
      leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            NotificationBarUtils.hideSnackBar(context);
            bloc?.events?.add(LeaveSelectUsersScreenEvent());
            Navigator.pop(context);
          }),
      actions: <Widget>[
        StreamProvider<SelectUsersScreenStates>(
            create: (context) =>
                bloc?.states?.stream as Stream<SelectUsersScreenStates>,
            initialData: ChangedSelectedUsersState([]),
            child: Selector<SelectUsersScreenStates, SelectUsersScreenStates>(
              selector: (_, state) => state,
              shouldRebuild: (previous, next) {
                return next is ChangedSelectedUsersState ||
                    next is CreateDialogErrorState ||
                    next is CreatingDialogState;
              },
              builder: (_, state, __) {
                if ((state is ChangedSelectedUsersState &&
                        state.usersIds.isNotEmpty) ||
                    state is CreateDialogErrorState) {
                  return TextButton(
                      child: Text(_dialogId.isNotEmpty ? "Add" : "Create",
                          style: TextStyle(
                              fontFamily: 'PM',
                              fontSize: 16,
                              color: Colors.white60)),
                      onPressed: () {
                        if (state is ChangedSelectedUsersState) {
                          NotificationBarUtils.hideSnackBar(context);
                          bloc?.events?.add(LeaveSelectUsersScreenEvent());
                          if (_dialogId.isNotEmpty) {
                            Navigator.pop(context, state.usersIds);
                          } else {
                            if (state.usersIds.length > ONE_USER) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EnterChatNameScreen(
                                          QBChatDialogTypes.GROUP_CHAT,
                                          state.usersIds),
                                    ));
                              });
                            } else {
                              bloc?.events
                                  ?.add(CreatePrivateChatEvent(state.usersIds));
                            }
                          }
                        }
                      });
                }
                return SizedBox.shrink();
              },
            ))
      ],
    );
  }

  Widget _buildProgress() {
    return StreamProvider<SelectUsersScreenStates>(
        create: (context) =>
            bloc?.states?.stream as Stream<SelectUsersScreenStates>,
        initialData: LoadUsersInProgressState(),
        child: Selector<SelectUsersScreenStates, SelectUsersScreenStates>(
            selector: (_, state) => state,
            shouldRebuild: (previous, next) {
              return next is CreatingDialogState ||
                  next is LoadUsersInProgressState ||
                  next is LoadUsersSuccessState ||
                  next is CreateDialogErrorState ||
                  next is ChangedSelectedUsersState ||
                  next is ErrorState;
            },
            builder: (_, state, __) {
              if (state is CreatingDialogState ||
                  state is LoadUsersInProgressState) {
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
        (route) => route.isFirst);
  }

  void _scrollListener() {
    if (_scrollController == null) {
      return;
    }
    double? maxScroll = _scrollController?.position.maxScrollExtent;
    double? currentScroll = _scrollController?.position.pixels;
    if (maxScroll == currentScroll) {
      if (_search) {
        bloc?.events?.add(SearchNextUsersEvent());
      } else {
        bloc?.events?.add(LoadNextUsersEvent());
      }
    }
  }

  Widget _buildSubtitle(ChangedSelectedUsersState state) {
    int usersCount = state.usersIds.length;

    String subtitle = usersCount.toString() +
        " user" +
        (usersCount == 1 ? "" : "s") +
        " selected";
    return Text('$subtitle',
        style: TextStyle(
            fontSize: 13,
            color: Colors.white60,
            fontFamily: 'PM',
            fontWeight: FontWeight.normal));
  }
}

class SearchTimer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  SearchTimer({this.milliseconds});

  run(VoidCallback callback) {
    if (milliseconds != null) {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: milliseconds!), callback);
    }
  }
}
