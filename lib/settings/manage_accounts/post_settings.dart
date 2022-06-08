import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

class PostSettings extends StatefulWidget {
  const PostSettings({Key? key}) : super(key: key);

  @override
  State<PostSettings> createState() => _PostSettingsState();
}

enum OS { Everyone, Peopleyoufollow, Noone }

class _PostSettingsState extends State<PostSettings> {
  OS? _os = OS.Everyone;
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Post Settings',
          style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PB'),
        ),
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 0.0,
            bottom: 5.0,
          ),
          child: ClipRRect(
              child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 31),
                child: Text(
                  'Allow tags from',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              Column(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('Everyone',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                      leading: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Radio<OS>(
                          activeColor: HexColor(CommonColor.pinkFont),
                          value: OS.Everyone,
                          groupValue: _os,
                          onChanged: (OS? value) {
                            setState(() {
                              _os = value;
                            });
                          },
                        ),
                      )),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('People you follow',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                      leading: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.Peopleyoufollow,
                            groupValue: _os,
                            onChanged: (OS? value) {
                              setState(() {
                                _os = value;
                              });
                            },
                          ))),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                      title: Text('No one',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                      leading: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.Noone,
                            groupValue: _os,
                            onChanged: (OS? value) {
                              setState(() {
                                _os = value;
                              });
                            },
                          ))),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 31),
                child: Text(
                  'Tagged posts',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text('Manually approve tags',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
                        child: Switch(
                          value: isSwitched1,
                          onChanged: (value) {
                            setState(() {
                              isSwitched1 = value;
                              print(isSwitched1);
                            });
                          },
                          activeColor: HexColor(CommonColor.pinkFont),
                          inactiveTrackColor: Colors.red[100],
                          inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Likes and views',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
                        child: Switch(
                          value: isSwitched2,
                          onChanged: (value) {
                            setState(() {
                              isSwitched2 = value;
                              print(isSwitched2);
                            });
                          },
                          activeColor: HexColor(CommonColor.pinkFont),
                          inactiveTrackColor: Colors.red[100],
                          inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Hide like counts',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
                        child: Switch(
                          value: isSwitched3,
                          onChanged: (value) {
                            setState(() {
                              isSwitched3= value;
                              print(isSwitched3);
                            });
                          },
                          activeColor: HexColor(CommonColor.pinkFont),
                          inactiveTrackColor: Colors.red[100],
                          inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text('Hide comment counts',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')),
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
                        child: Switch(
                          value: isSwitched4,
                          onChanged: (value) {
                            setState(() {
                              isSwitched4 = value;
                              print(isSwitched4);
                            });
                          },
                          activeColor: HexColor(CommonColor.pinkFont),
                          inactiveTrackColor: Colors.red[100],
                          inactiveThumbColor: HexColor(CommonColor.pinkFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Text('Tagged post',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR  ')),
              ),
              SizedBox(
                height:31,
              ),
              Container(
                child: Text('Mentions',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR  ')),
              ),
              SizedBox(
                height:31,
              ),
              Container(
                child: Text('Guide controls',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR  ')),
              ),
              SizedBox(
                height:31,
              ),
              Container(
                child: Text('Live',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR  ')),
              ),
              SizedBox(
                height:51,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
