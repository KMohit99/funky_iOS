import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/colorUtils.dart';

class Email_sms_Screen extends StatefulWidget {
  const Email_sms_Screen({Key? key}) : super(key: key);

  @override
  State<Email_sms_Screen> createState() => _Email_sms_ScreenState();
}

class _Email_sms_ScreenState extends State<Email_sms_Screen> {
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
          'Email and SMS',
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
                  'Email and SMS',
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
                height:51,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
