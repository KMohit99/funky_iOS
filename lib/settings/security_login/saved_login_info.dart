import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Utils/colorUtils.dart';

class SaveLoginInfo extends StatefulWidget {
  const SaveLoginInfo({Key? key}) : super(key: key);

  @override
  State<SaveLoginInfo> createState() => _SaveLoginInfoState();
}

class _SaveLoginInfoState extends State<SaveLoginInfo> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Change Password',
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
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 40),
                      child: Text('Ads personalization',
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor('#E84F90'),
                              fontFamily: 'PR')),
                    ),
                    Container(
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor:
                                HexColor(CommonColor.pinkFont)),
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
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 45),
                  child: Text(
                      "We will remember your account info for you on this device. You won't need to enter it when you login again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: HexColor('#A8A8A8'),
                          fontFamily: 'PR  ')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
