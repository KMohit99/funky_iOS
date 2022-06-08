import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../Utils/asset_utils.dart';
import '../../../Utils/colorUtils.dart';
import 'package:hexcolor/hexcolor.dart';

class RequestVerification extends StatefulWidget {
  const RequestVerification({Key? key}) : super(key: key);

  @override
  State<RequestVerification> createState() => _RequestVerificationState();
}

class _RequestVerificationState extends State<RequestVerification> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Comments',
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
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  'Change Account',
                  style: TextStyle(
                      fontSize: 16,
                      color: HexColor(CommonColor.pinkFont),
                      fontFamily: 'PR'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Block comment',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white, fontFamily: 'PR'),
                    ),
                    Row(
                      children: [
                        Container(
                          child: Image.asset(
                            AssetUtils.block_icon,
                            height: 25,
                            width: 25,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          '10 people',
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor('#878787'),
                              fontFamily: 'PR'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                          'Request to Download their Data, collected by Funky',
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
            ],
          ),
        ),
      ),
    );
  }
}
