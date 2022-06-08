import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Utils/colorUtils.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}
enum OS { public, private }
enum OS2 { contactonly, everyone }

class _NotificationSettingsState extends State<NotificationSettings> {
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
          'Notification setting',
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

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child:Text('Pause all',
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
                      child:Text('Post, stories and comment',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child:Text('Following and followers',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child:Text('Messages and callss',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child:Text('Live and video',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child:Text('From Funky',
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

              SizedBox(height: 20,),
              Container(
                child: Text(
                  'Other Notification Type',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child:Text('From Funky',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'PR  ')) ,
                    ),
                    // Container(
                    //   child: Theme(
                    //     data: ThemeData(
                    //         unselectedWidgetColor: HexColor(CommonColor.pinkFont)
                    //     ),
                    //     child: Switch(
                    //
                    //       value: isSwitched,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           isSwitched = value;
                    //           print(isSwitched);
                    //         });
                    //       },
                    //       activeColor: HexColor(CommonColor.pinkFont),
                    //       inactiveTrackColor: Colors.red[100],
                    //       inactiveThumbColor: HexColor(CommonColor.pinkFont),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),

              SizedBox(height: 20,)

            ],
          ),
        ),
      ),

    );
  }
}
