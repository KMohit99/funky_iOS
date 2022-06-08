import 'package:flutter/material.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

class PrivcacyScreen extends StatefulWidget {
  const PrivcacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivcacyScreen> createState() => _PrivcacyScreenState();
}

enum OS { public, private }
enum OS2 { contactonly, everyone }

class _PrivcacyScreenState extends State<PrivcacyScreen> {
  OS? _os = OS.private;
  OS2? _os2 = OS2.contactonly;
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Privacy Settings',
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
              SizedBox(height: 30,),
              Container(
                child: Text(
                  'Control',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Text('Public',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'PR  ')),
                        leading: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Radio<OS>(
                            activeColor: HexColor(CommonColor.pinkFont),
                            value: OS.public,
                            groupValue: _os,
                            onChanged: (OS? value) {
                              setState(() {
                                _os = value;
                              });
                            },
                          ),
                        )),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Text('Private',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<OS>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS.private,
                              groupValue: _os,
                              onChanged: (OS? value) {
                                setState(() {
                                  _os = value;
                                });
                              },
                            ))),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Text(
                  'Suggest Account',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              SizedBox(height: 20,),

              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,

                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Text('Contact only',
                            style: TextStyle(
                                fontSize: 14,
                                color:Colors.white,
                                fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.contactonly,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Text('Everyone',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'PR  ')),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.everyone ,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 31),
                child:Text('Sync phone contatcs',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor('#878787'),
                        fontFamily: 'PR  ')) ,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child:Text('Ads personalization',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')) ,
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont)
                        ),
                        child: Switch(

                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
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
                      child:Text('Request to Download their Data, collected by Funky',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')) ,
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor: HexColor(CommonColor.pinkFont)
                        ),
                        child: Switch(

                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
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
                margin: EdgeInsets.symmetric(vertical: 25),
                child:Text('Who can view their liked videos',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR  ')) ,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        dense:true,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text('Only me',
                            style: TextStyle(
                                fontSize: 12,
                                color:Colors.white,
                                fontFamily: 'PR  '))),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.contactonly,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text('Friends',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'PR  '))),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.everyone ,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,

                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text('Everyon',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'PR  '))),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.everyone ,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child:Text('Who can view social media links',
                    style: TextStyle(
                        fontSize: 16,
                        color: HexColor(CommonColor.pinkFont),
                        fontFamily: 'PR  ')) ,
              ),
              Row(
                children: [
                  Flexible(
                    child: ListTile(
                        dense:true,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text('Only me',
                            style: TextStyle(
                                fontSize: 12,
                                color:Colors.white,
                                fontFamily: 'PR  '))),
                        leading: Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.contactonly,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text('Friends',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'PR  '))),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.everyone ,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                  Flexible(
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,

                        visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                        title: Transform(
                            transform: Matrix4.translationValues(-16, 0.0, 0.0),
                            child: Text('Everyon',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'PR  '))),
                        leading: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Radio<OS2>(
                              activeColor: HexColor(CommonColor.pinkFont),
                              value: OS2.everyone ,
                              groupValue: _os2,
                              onChanged: (OS2? value) {
                                setState(() {
                                  _os2 = value;
                                });
                              },
                            ))),
                  ),
                ],
              ),
              SizedBox(height: 20,)

            ],
          ),
        ),
      ),
    );
  }
}
